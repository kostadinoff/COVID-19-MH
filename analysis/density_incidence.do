set scheme swift_red
import delimited "C:\Users\PC\Desktop\file.csv"
rename region NUTS_NAME

cd .\bulgarian_maps
 spshape2dta "Bulgaria_regions_NUTS_3.shp", replace saving(bulgaria)
 use bulgaria_shp, clear
 merge m:1 _ID using bulgaria
 
 
 // scatter _Y _X, msize(tiny) msymbol(point)
 use bulgaria, clear
 spmap using bulgaria_shp, id(_ID)

* мърджане с това което искаме да плотнем 
merge 1:1 NUTS_NAME using "C:\Users\PC\Desktop\file.dta"

*плотваме 
spmap covid_proportion using bulgaria_shp, id(_ID) cln(11) fcolor(Heat)


ssc install bimap, replace
ssc install palettes, replace
ssc install colrspace, replace

bimap incidence density using bulgaria_shp, cut(pctile) palette(pinkgreen)