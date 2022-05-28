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
 cd .\bulgarian_maps
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



use "C:\Users\PC\Documents\GitHub\COVID-19-MH\data\COVID_MH_data\all_regions.dta"



* мърджане с това което искаме да плотнем 
merge 1:1 NUTS_NAME using "C:\Users\Kostadin\Desktop\all_regions.dta"

gen alpha_per_1000 = (alpha/ Pop_2019)*1000
spmap  alpha_per_1000 using bulgaria_shp, id(_ID) cln(7) fcolor(Heat)

gen infected = D + R

gen delta_per_1000 = (delta/ Pop_2019)*1000

twoway (lfitci  letalitet vac_pop ) (scatter  letalitet vac_pop , mlabel( NUTS_NAME ) )

