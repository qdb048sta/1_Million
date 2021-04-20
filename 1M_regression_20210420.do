log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210420.log",replace
set max_memory 80g	
use "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210413.dta",clear
replace Dcd=Dcd*100
reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==0,cluster (township) 
reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==1,cluster (township) 
foreach i of num 1/60{
	gen Rp`i'=1 if R==`i'
	replace Rp`i'=0 if missing(Rp`i')
}

foreach i of num 1/60{
	gen Rn`i'=1 if R==-`i'
	replace Rn`i'=0 if missing(Rn`i')
	
} 
foreach i of num 1/8{
	gen Wp`i'=1 if R>=1+7*(i-1) & R<=7+7*(i-1)
	replace Wp`i' if missing(Wp`i')

}
foreach i of num 1/8{
	gen Wn`i'=1 if R>=-7-(i-1)*7 & R>=-1-(i-1)*7
	replace Wn`i' if missing(Wn`i')
}
save "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210420.dta",replace
reg Dcd POST Wp* Wp*##POST Wn* Wn*##POST if FEMALE==0, cluster(township) 
coefplot
graph export "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\Weekly_FEMALE==0.png", as(PNG) name("Graph")
reg Dcd POST Wp* Wp*##POST Wn* Wn*##POST if FEMALE==1, cluster(township) 
coefplot
graph export "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\Weekly_FEMALE==1.png", as(PNG) name("Graph")
reg Dcd POST Rp* Rp*##POST Rn* Rn*##POST if FEMALE==0 , cluster(township) 
coefplot
graph export "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\Daily_FEMALE==0.png", as(PNG) name("Graph")
reg Dcd POST Rp* Rp*##POST Rn* Rn*##POST if FEMALE==1, cluster(township) 
coefplot
graph export "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\Daily_FEMALE==1.png", as(PNG) name("Graph")



