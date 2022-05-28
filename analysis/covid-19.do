
///////////////////////////////////////////////////////////////////////////////
*** за графики *******
*формиране на дати
import delimited "https://raw.githubusercontent.com/kostadinoff/COVID-19-MH/master/data/COVID_MH_data/national_stata_data.csv"
gen Date = date(date, "DMY")
format Date %td
tsset Date

* 7 дневни средни
tsegen double deaths_14 = rowmean(L(0/13).deaths) 
tsegen double positive_14 = rowmean(L(0/13).positive_total) 


* на 14 дневна база
graph twoway (tsline deaths_14 , yaxis(1)) (tsline positive_14 ,yaxis(2)) 

* на дневна база
graph twoway (tsline deaths , yaxis(1)) (tsline positive_total ,yaxis(2)) 

keep if date >="27dec2020"

tsegen double vax_14 = rowmean(L(0/13).vaccinated ) 
tsegen double death_vaccinated_14 = rowmean(L(0/13).death_vaccinated ) 
tsegen double death_non_vax_14 = rowmean(L(0/13).death_non_vax) 


* 7 дневни средни
tsegen double deaths_14 = rowmean(L(0/13).deaths) 
tsegen double positive_14 = rowmean(L(0/13).positive_total) 


* на 14 дневна база
graph twoway (tsline deaths_14 , yaxis(1)) (tsline positive_14 ,yaxis(2)) 

* на дневна база
graph twoway (tsline deaths , yaxis(1)) (tsline positive_total ,yaxis(2)) 

keep if date >="27dec2020"

tsegen double vax_14 = rowmean(L(0/13).vaccinated ) 
tsegen double death_vaccinated_14 = rowmean(L(0/13).death_vaccinated ) 
tsegen double death_non_vax_14 = rowmean(L(0/13).death_non_vax) 


///////////////////////////////////////////////////////////////////////////////
******** Индивидуални данни ***********************
* Графични пакети
//ssc install tsegen
// net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme swift_red

* текстови пакети /or Edit- prefernces
// net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
// set scheme cleanplots, perm
// graph set window fontface "CormorantInfant-Light"
// ssc install color_style, replace
// ssc install asrol

* импортиране на данни
import delimited  "C:\Users\PC\Desktop\covid_full.csv"

*формиране на дати
gen exam_dat = date( exam_date , "DMY")
format exam_dat %td
drop exam_date

gen lastvac_dat = date(lastvac_date , "DMY")
format lastvac_dat %td
drop lastvac_date

gen start_hospital = date(start_hospis , "DMY")
format start_hospital %td
drop start_hospis

gen end_hospital = date(end_hospis , "DMY")
format end_hospital %td
drop end_hospis

encode gender, gen (sex)
encode province, gen (region)
encode hospital_name, gen (hospital)
encode status, gen (status_lab)
encode vaccine_name, gen (vax_name)

drop municipality
drop gender
drop province
drop status


gen death = 1
replace death = 0 if outcome_covid == ""

gen vacinated = 1
replace vacinated = 0 if vaccine_name == "" 
replace vacinated = 0 if lastvac_dat > exam_dat
replace vax_name = 0  if vaccine_name == ""

gen hospitalized = 1
replace hospitalized = 0 if hospital_name == ""

recode age (min/14 = 0 "0-14")(15/24= 1 "15-24")(25/34=2 "25-34")(35/44=3 "35-44")(45/54=4 "45-54")(55/64=5 "55-64")(65/74=6 "65-74")(75/84=7 "75-84")(85/94=8 "85-94")(95/max = 9 "95 +" ), generate(agecat)


*ssc install coefplot, replace

*logistic death i.vacinated age i.sex
*margins i.sex,  dydx(vacinated) at(age=(20(5)85)) vsquish
*marginsplot, recast(line) recastci(rarea)
gen wav = "alpha"
replace wav = "delta" if exam_dat > td(07jul2021)
replace wav = "omicron" if exam_dat > td(26jan2022) 
encode wav, gen (wave)
drop wav

gen time_outcome = (14 + exam_dat) - exam_dat
replace time_outcome = end_hospital - exam_dat if hospitalized == 1
gen time_vacinated =  exam_dat-lastvac_dat  if vacinated == 1


logistic hospitalized age sex
logistic death age sex i.region


keep if time_outcome >= 0

stset time_outcome, failure(death==1)
sts test vacinated , logrank
stcurve, survival at1(vacinated=0) at2(vacinated=1) risktable










