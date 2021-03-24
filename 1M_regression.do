clear
local path "D:\User_Data\Documents\GitHub\1_Million\"
log using "`path'1M_regression_by_SEX.log",replace
use "`path'cd20210211weekd.dta"
gen vote=DDPtownP
gen POST=1 if R>=0
replace POST=0 if R<0
gen vote_pre=vote*(1-POST)
gen vote_post=vote*POST
gen R_post= R*POST
gen R_1_minus_post=R*(1-POST)
//
gen DPP=1 if vote>=0.5
replace DPP=0 if vote<0.5
gen vote_pre_DPP=vote_pre*DPP
gen vote_post_DPP=vote_post*DPP
gen vote_DPP=vote*DPP

reg Dcd vote DPP vote_DPP if ID_SEX=="F"
reg Dcd vote DPP vote_DPP if ID_SEX=="M"
log close
//
reg Dcd vote_pre vote_post POST R_post R_1_minus_post if ID_SEX=="F"
reg Dcd vote_pre_DPP vote_post_DPP vote_DPP DPP vote POST R_post R_1_minus_post if ID_SEX=="F"
reg Dpsy vote_pre vote_post POST R_post R_1_minus_post if ID_SEX=="F"
reg Dpsy vote_pre_DPP vote_post_DPP vote_DPP DPP vote POST R_post R_1_minus_post if ID_SEX=="F"

reg Dcd vote_pre vote_post POST R_post R_1_minus_post if ID_SEX=="M"
reg Dcd vote_pre_DPP vote_post_DPP vote_DPP DPP vote POST R_post R_1_minus_post if ID_SEX=="M"
reg Dpsy vote_pre vote_post POST R_post R_1_minus_post if ID_SEX=="M"
reg Dpsy vote_pre_DPP vote_post_DPP vote_DPP DPP vote POST R_post R_1_minus_post if ID_SEX=="M"

log close
//
gen close=(vote-0.5)^2
gen close_DPPc=close*DPP
save "temp20210304.dta",replace
reg Dcd close DPP close_DPPc if ID_SEX=="M"& POST==1
reg Dcd close DPP close_DPPc if ID_SEX=="F"   & POST==1
reg Dpsy close DPP close_DPPc if ID_SEX=="M" & POST==1
reg Dpsy close DPP close_DPPc if ID_SEX=="F"   & POST==1
//
log using "1M_regression_by_ID_SEX_POST_2",replace
//drop close
gen close=1-abs(vote-0.5)
//drop close_DPPc
gen close_DPPc=close*DPP
save "temp20210305.dta",replace
reg Dcd close close_DPPc if ID_SEX=="M"& POST==1
reg Dcd close close_DPPc if ID_SEX=="F"& POST==1
reg Dcd close close_DPPc if ID_SEX=="M"& POST==0
reg Dcd close close_DPPc if ID_SEX=="F"& POST==0
reg Dpsy close close_DPPc if ID_SEX=="M"& POST==1
reg Dpsy close close_DPPc if ID_SEX=="F"& POST==1
reg Dpsy close close_DPPc if ID_SEX=="M"& POST==0
reg Dpsy close close_DPPc if ID_SEX=="F"& POST==0
log close

//
log using "1M_regression_FEMALE_3.log"
gen FEMALE=1 if ID_SEX=="F"
replace FEMALE=0 if ID_SEX=="M"
rename close CLOSE
gen CLOSE_FEMALE=CLOSE*FEMALE
gen CLOSE_POST=CLOSE*POST
gen FEMALE_POST=FEMALE*POST
gen CLOSE_FEMALE_POST=CLOSE*FEMALE*POST
save "temp20210305_1.dta"
reg Dcd CLOSE FEMALE POST CLOSE_FEMALE CLOSE_POST FEMALE_POST CLOSE_FEMALE_POST
reg Dpsy CLOSE FEMALE POST CLOSE_FEMALE CLOSE_POST FEMALE_POST CLOSE_FEMALE_POST
log close

//
log using "1M_regression_NEAR_4.log"
qui sum R
local max=r(max)
gen NEAR=`max'-abs(R)
gen CLOSE_NEAR=CLOSE*NEAR
gen CLOSE_FEMALE_NEAR=CLOSE*FEMALE*NEAR
save "temp20210311.dta"
reg Dcd CLOSE FEMALE NEAR CLOSE_FEMALE CLOSE_NEAR FEMALE_POST CLOSE_FEMALE_NEAR 
reg Dpsy CLOSE FEMALE NEAR CLOSE_FEMALE CLOSE_NEAR FEMALE_POST CLOSE_FEMALE_NEAR 


//
log using "1M_regression_NEAR_FEMALE_5.log",replace
gen FEMALE_NEAR=FEMALE*NEAR
save "temp20210311_1.dta",replace
reg Dcd CLOSE FEMALE CLOSE_FEMALE CLOSE_NEAR FEMALE_NEAR CLOSE_FEMALE_NEAR
reg Dpsy CLOSE FEMALE CLOSE_FEMALE CLOSE_NEAR FEMALE_NEAR CLOSE_FEMALE_NEAR
log close



