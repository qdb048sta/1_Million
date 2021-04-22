use "Weekly_Result_M.dta"
keep if strpos(var,"Wp") | strpos(var,"Wn")
replace var="Wp0" in 16

gen num_value=substr(var,3,3)
gen WR=int(num_value) if strpos(var,"Wp")
replace WR=-1*int(num_value) if strpos(var,"Wn")
qui tw (lpoly W WR) (lpoly W95lb WR) (lpoly W95ub WR) ,legend(lab (1 "W") lab(2 "W 95 Lower Bound") lab(3 "W 95 Upper Bound")) xline(1) yline(0) xlabel(-8 "Wn8" -7 "Wn7" -8 "Wn8" -6 "Wn6" -5 "Wn5" -4 "Wn4" -3 "Wn3" -2 "Wn2" -1 "Wn1" 1 "Wp1" 2 "Wp2" 3 "Wp3" 4 "Wp4" 5 "Wp5" 6 "Wp6" 7 "Wp7" 8 "Wp8")

use "Weekly_Result_F.dta"
keep if strpos(var,"Wp") | strpos(var,"Wn") 
replace var="Wp0" in 16
gen num_value=substr(var,3,3)
gen WR=int(num_value) if strpos(var,"Wp")
replace WR=-1*int(num_value) if strpos(var,"Wn")

qui tw (lpoly coef WR) (lpoly W95lb WR) (lpoly W95ub WR) ,legend(lab (1 "W") lab(2 "W 95 Lower Bound") lab(3 "W 95 Upper Bound")) xline(1) yline(0) xlabel(-8 "Wn8" -7 "Wn7" -8 "Wn8" -6 "Wn6" -5 "Wn5" -4 "Wn4" -3 "Wn3" -2 "Wn2" -1 "Wn1" 1 "Wp1" 2 "Wp2" 3 "Wp3" 4 "Wp4" 5 "Wp5" 6 "Wp6" 7 "Wp7" 8 "Wp8")


