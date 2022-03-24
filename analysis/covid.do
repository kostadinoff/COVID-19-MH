* Графични пакети
//ssc install tsegen
// net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme swift_red

* текстови пакети /or Edit- prefernces
// net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
// set scheme cleanplots, perm
// graph set window fontface "CormorantInfant-Light"

// ssc install asrol

* импортиране на данни
import delimited "https://raw.githubusercontent.com/kostadinoff/COVID-19-MH/master/data/COVID_MH_data/national_stata_data.csv"

*формиране на дати
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


*импорт на данните за починалите
import delimited "https://raw.githubusercontent.com/kostadinoff/COVID-19-MH/master/data/COVID_MH_data/deaths.csv"
