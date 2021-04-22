log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210421_Weekly.log",replace
set max_memory 80g	
use "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210413.dta",clear

replace Dcd=Dcd*100

keep Dcd CLOSE NEAR CLOSE_NEAR FEMALE township R POST
//compress

//reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==0,cluster (township) 
//reg Dcd CLOSE NEAR CLOSE_NEAR if FEMALE==1,cluster (township) 

//Weekly
foreach i of num 0/8{
	gen Wp`i'=1 if R>=0+7*(`i') & R<=6+7*(`i')
	replace Wp`i'=0 if missing(Wp`i')

}
//compress
foreach i of num 1/8{
	gen Wn`i'=1 if R>=-7-(`i'-1)*7 & R<=-1-(`i'-1)*7
	replace Wn`i'=0 if missing(Wn`i')
}
log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210422_Weekly.log",replace
preserve
reg Dcd Wp1 Wp2 Wp3 Wp4 Wp5 Wp6 Wp7 Wn1 Wn2 Wn3 Wn4 Wn5 Wn6 Wn7 Wn8 if FEMALE==0, absorb(township) cluster(township) 
regsave,tstat pval ci
save "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_M.dta", replace

restore
preserve
drop Wp0 Wp8
reg Dcd Wp1 Wp2 Wp3 Wp4 Wp5 Wp6 Wp7 Wn1 Wn2 Wn3 Wn4 Wn5 Wn6 Wn7 Wn8 if FEMALE==0, absorb(township) cluster(township) 
regsave,tstat pval ci
save "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_F.dta", replace
restore
log close


/*20210421早上加上
log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210421_2.log",replace
reg Dcd CLOSE NEAR  if FEMALE==0,cluster (township) 
reg Dcd CLOSE NEAR  if FEMALE==1,cluster (township) 
log close
*/
save "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\temp20210421.dta",replace
log close



