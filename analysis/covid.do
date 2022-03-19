* Графични пакети
net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme swift_red

* текстови пакети /or Edit- prefernces
net install cleanplots, from("https://tdmize.github.io/data/cleanplots")
set scheme cleanplots, perm
graph set window fontface "CormorantInfant-Light"
* импортиране на данни
import delimited "https://raw.githubusercontent.com/kostadinoff/COVID-19-MH/master/data/COVID_MH_data/national_stata_data.csv"

*формиране на дати
gen Date = date(date, "DMY")
format Date %td
tsset Date

* Графика - смъртност/заболеваемост
gen cfr = case_fatality_ratio*10
graph twoway (tsline deaths , yaxis(1)) (tsline positive_total ,yaxis(2)) 