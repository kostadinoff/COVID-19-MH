 ssc install spmap   
 ssc install geo2xy 
 ssc install palettes, replace
 ssc install colrspace, replace
 ssc install bimap, replace

 * подготвяне на това което искаме да плотнем
import delimited "C:\Users\Kostadin\Desktop\rhi_full.csv", varnames(1) parselocale(bg_BG) clear
rename nuts_name NUTS_NAME
save ./documents/rhi_full.dta, replace

* импортиране и работа със шейп файла
 cd bulgaria_regions_NUTS_3
 spshape2dta "Bulgaria_regions_NUTS_3.shp", replace saving(bulgaria)
 use bulgaria_shp, clear
 merge m:1 _ID using bulgaria
 // scatter _Y _X, msize(tiny) msymbol(point)
 use bulgaria, clear
 spmap using bulgaria_shp, id(_ID)

* мърджане с това което искаме да плотнем 
merge 1:1 NUTS_NAME using "C:\Users\Kostadin\Documents\bulgaria_regions_NUTS_3\rhi_full.dta"

*плотваме 
spmap covid_proportion using bulgaria_shp, id(_ID) cln(11) fcolor(Heat)