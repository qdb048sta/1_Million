log using "D:\Google 雲端硬碟\result\1M_regression_reuslt_20210420\1Mregression_20210422_Weekly.log",replace
preserve
reg Dcd Wp1 Wp2 Wp3 Wp4 Wp5 Wp6 Wp7 Wn1 Wn2 Wn3 Wn4 Wn5 Wn6 Wn7 Wn8 if FEMALE==0, absorb(township) cluster(township) 
regsave,tstat pval ci
save "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_M.dta", replace

restore
preserve
reg Dcd Wp1 Wp2 Wp3 Wp4 Wp5 Wp6 Wp7 Wn1 Wn2 Wn3 Wn4 Wn5 Wn6 Wn7 Wn8 if FEMALE==1, absorb(township) cluster(township) 
regsave,tstat pval ci
save "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_F.dta", replace
restore
log close