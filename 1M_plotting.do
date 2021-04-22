use "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_M.dta",clear
//keep if strpos(var,"Wp") | strpos(var,"Wn")
drop if coef==0
set obs 16
replace var="Wp0" in 16
replace coef=0 if var=="Wp0"
replace ci_lower=0 if var=="Wp0"
replace ci_upper=0 if var=="Wp0"
gen num_value=substr(var,3,3)
destring(num_value),replace
gen WR=num_value //if strpos(var,"Wp")
replace WR=-WR if strpos(var,"Wn")
gsort -WR
br
qui tw (connected coef WR) (connected ci_lower WR) (connected ci_upper WR) ,legend(lab (1 "Wp or Wn value") lab(2 "W 95 Lower Bound") lab(3 "W 95 Upper Bound")) xline(0) yline(0) xlabel(-8 "8 Weeks Before" -7 "7 Weeks Before" -6 "6 Weeks Before" -5 "5 Weeks Before" -4 "4 Weeks Before" -3 "3 Weeks Before" -2 "2 Weeks Before" -1 "1 Weeks Before" 0 "Election Week" 1 "1 Weeks After" 2 "2 Weeks After" 3 "3 Weeks After" 4 "4 Weeks After" 5 "5 Weeks After" 6 "6 Weeks After" 7 "7 Weeks After",ang(60)) title("Dcd Change Weekly")
graph export "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Change_M.png", as(png) name("Graph"),replace

use "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Result_F.dta",clear
//keep if strpos(var,"Wp") | strpos(var,"Wn")
drop if coef==0
set obs 16
replace var="Wp0" in 16
replace coef=0 if var=="Wp0"
replace ci_lower=0 if var=="Wp0"
replace ci_upper=0 if var=="Wp0"
gen num_value=substr(var,3,3)
destring(num_value),replace
gen WR=num_value //if strpos(var,"Wp")
replace WR=-WR if strpos(var,"Wn")
gsort -WR
br
qui tw (connected coef WR) (connected ci_lower WR) (connected ci_upper WR) ,legend(lab (1 "Wp or Wn value") lab(2 "W 95 Lower Bound") lab(3 "W 95 Upper Bound")) xline(0) yline(0) xlabel(-8 "8 Weeks Before" -7 "7 Weeks Before" -6 "6 Weeks Before" -5 "5 Weeks Before" -4 "4 Weeks Before" -3 "3 Weeks Before" -2 "2 Weeks Before" -1 "1 Weeks Before" 0 "Election Week" 1 "1 Weeks After" 2 "2 Weeks After" 3 "3 Weeks After" 4 "4 Weeks After" 5 "5 Weeks After" 6 "6 Weeks After" 7 "7 Weeks After",ang(60)) title("Dcd Change Weekly")
graph export "D:\User_Data\Desktop\kan-2\1_Million\result\Weekly_Change_F.png", as(png) name("Graph")





