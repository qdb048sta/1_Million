log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210421_1.log",replace
set max_memory 80g	
use "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210413.dta",clear

replace Dcd=Dcd*100

keep Dcd CLOSE NEAR CLOSE_NEAR FEMALE township R POST
compress

//reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==0,cluster (township) 
//reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==1,cluster (township) 

//Weekly
foreach i of num 1/8{
	gen Wp`i'=1 if R>=0+7*(`i') & R<=7+7*(`i')
	replace Wp`i'=0 if missing(Wp`i')

}
compress
foreach i of num 1/8{
	gen Wn`i'=1 if R>=-7-(`i'-1)*7 & R>=-1-(`i'-1)*7
	replace Wn`i'=0 if missing(Wn`i')
}
reg Dcd POST Wp* Wp*##POST Wn* Wn*##POST if FEMALE==0, cluster(township) 

reg Dcd POST Wp* Wp*##POST Wn* Wn*##POST if FEMALE==1, cluster(township) 


/*20210421早上加上
log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210421_2.log",replace
reg Dcd CLOSE NEAR  if FEMALE==0,cluster (township) 
reg Dcd CLOSE NEAR  if FEMALE==1,cluster (township) 
log close
*/

save "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210421.dta",replace
log close



