* Графични пакети
//ssc install tsegen
// net install schemepack, from("https://raw.githubusercontent.com/asjadnaqvi/Stata-schemes/main/schemes/") replace
set scheme swift_red


*импорт на данните за починалите
import delimited "https://raw.githubusercontent.com/kostadinoff/COVID-19-MH/master/data/RHI_Data_HR/rhi_%D0%BC.csv"

*формиране на дати
gen Date = date(date, "DMY")
drop date
format Date %td

encode region , gen(region_f)
drop region
encode month, gen(month_f)
drop month

tsset region_f Date
twoway (tsline covid_proportion), by( region_f )