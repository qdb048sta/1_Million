


/*----------------------------------------------------------------------------*/
clear
set more off
set max_memory 40g			  
cap log c

// cd "D:\User_Data\Desktop\kan-2"

global log "cd20210211weekd_Sep"
local log "$log"

log using "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\\$log", text replace


// global datapath "F:\1Million\Documentation\"
global datapath "D:\User_Data\Desktop\kan-2\1_Million\data\raw_data\"
// global datapath "d:\1Million\Documentation\"
global dayrange "60" 
global wrange "8"
local  dayrange =$dayrange
local  wrange =$wrange
local year1=2004
local year2=2005
local yr1=substr("`year1'",3,2)
local yr2=substr("`year2'",3,2)
if `year2'==2006{
                   local march20="0918"
                }
if `year2'==2005{
                   local march20="0917"
                }

 local datatype = "temp"
//local datatype = "all"

global dataCD04temp "CD`year1'_one_tenth.dta"
global dataCD04all  "CD`year1'.dta"

global dataCD05temp "CD`year2'_one_tenth.dta"
global dataCD05all  "CD`year2'.dta"

//create R(+-30 days of specific Saturday `year1'0320 )
use $datapath\${dataCD04`datatype'} ,clear

preserve
// gen R1=date(FUNC_DATE,"YMD")
// gen Rw6=wofd(R1-2)
//gen Rw =wofd(R1)
gen R=date(FUNC_DATE,"YMD")-date("`year1'0918","YMD")
gen abs_R=abs(R)
keep if abs_R<=$dayrange
sort FUNC_DATE
tempfile unique_R
keep R
duplicates drop 
save `unique_R',replace
restore

drop if ID==""
tempfile id`year1'
keep ID ID_BIRTHDAY ID_SEX
qui compress
save `id`year1'',replace



use $datapath\${dataCD05`datatype'} ,clear
drop if ID==""
tempfile id0405
keep ID ID_BIRTHDAY ID_SEX
append using `id`year1''
duplicates drop
qui compress
save `id0405',replace


use `id0405',clear
duplicates drop
cross using `unique_R'
tempfile unique_R_cross_ID
count
qui compress
save `unique_R_cross_ID',replace


use $datapath\${dataCD04`datatype'} ,clear
gen R1=date(FUNC_DATE,"YMD")
gen Rw6=wofd(R1-2)
gen Rw =wofd(R1)
gen R=date(FUNC_DATE,"YMD")-date("`year1'0918","YMD")
gen abs_R=abs(R)
keep if abs_R<=$dayrange
global spirit = "290/319 319"
qui icd9 check ACODE_ICD9_1   ,  gen(ivicd1)
qui icd9  gen  ICD_spirit = ACODE_ICD9_1     if  (ivicd1 ==0 ) , range("$spirit")       /*icd9*/
gen cd_count=1
gen cd_spirit_count=1 if ICD_spirit==1

/*For each R and ID count it's CD record happened in `year1' i.g ID:E110000000 went to clinic for depressive disorder twice on `year1'/03/18 then 
it will record 2 on ID:E110000000 R:-2 CD`year1'=2 cd`year1'_spirit=2 
*/
egen cd_`year1'=sum(cd_count), by(ID R)
egen cd_`year1'_spirit=sum(cd_spirit_count) if ICD_spirit==1 , by(ID R)
replace cd_`year1'=0 if missing(cd_`year1')
replace cd_`year1'_spirit=0 if missing(cd_`year1'_spirit)
keep ID R ID_BIRTHDAY cd_`year1' cd_`year1'_spirit 
duplicates drop ID R, force
tempfile ID_R_CD_`year1'
qui compress
save `ID_R_CD_`year1'',replace
//0319
use $datapath\${dataCD05`datatype'},clear
gen R=date(FUNC_DATE,"YMD")-date("`year2'`march20'","YMD")
gen abs_R=abs(R)
keep if abs_R<=$dayrange
global spirit = "290/319 319"
qui icd9 check ACODE_ICD9_1   ,  gen(ivicd1)
qui icd9  gen  ICD_spirit = ACODE_ICD9_1     if  (ivicd1 ==0 ) , range("$spirit")       /*icd9*/
gen cd_count=1
gen cd_spirit_count=1 if ICD_spirit==1
egen cd_`year2'=sum(cd_count), by(ID R)
egen cd_`year2'_spirit=sum(cd_count) if ICD_spirit==1 , by(ID R)
replace cd_`year2'=0 if missing(cd_`year2'_spirit)
replace cd_`year2'_spirit=0 if missing(cd_`year2'_spirit)
tempfile ID_R_CD_`year2'
keep ID R ID_BIRTHDAY cd_`year2' cd_`year2'_spirit 
duplicates drop ID R, force
qui compress
save `ID_R_CD_`year2'',replace


use `unique_R_cross_ID'
joinby ID R using `ID_R_CD_`year1'',unmatched(master)
drop _merge
joinby ID R using `ID_R_CD_`year2'',unmatched(master)
drop _merge
qui compress


replace cd_`year1'=0 if missing(cd_`year1')
replace cd_`year1'_spirit=0 if missing(cd_`year1'_spirit)
replace cd_`year2'=0 if missing(cd_`year2')
replace cd_`year2'_spirit=0 if missing(cd_`year2'_spirit)


destring ID_BIRTHDAY,replace
bysort ID :egen birth = max(ID_BIRTHDAY)
qui gen sex0 = 1 if ID_SEX=="M"
qui replace sex0 = 0 if ID_SEX=="F"
bysort ID :egen sex = max(sex0)
tostring sex,replace
qui replace sex = "M" if sex=="1"
qui replace sex = "F" if sex=="0"
cap drop sex0

egen IDN=count(ID),by(ID)
tab IDN
drop if IDN !=1+($dayrange)*2
save "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\CD`year1'_`year2'_Sep.dta" ,replace




global dayrange1 =$dayrange
global wrange1 =$wrange


tostring ID_BIRTHDAY, replace
replace ID_BIRTHDAY=ID_BIRTHDAY+"20"
gen D_ID_BIRTHDAY=date("`year1'0320","YMD")-date(ID_BIRTHDAY,"YMD")
cap drop age1019 age2029 age3039 age4049 age5059 age6069 age7099

global age ="10 20 30 40 50 60 70"
foreach age of global age{
local `age'_min  = `year1' - `age'
local `age'_max  = `year1' - (`age'+10)

scalar min_`age'=date("`year1'0918","YMD")-date("``age'_min'0918","YMD")
scalar max_`age'=date("`year1'0918","YMD")-date("``age'_max'0918","YMD")
local c=substr("`age'",1,1)
local age1=`age'+9 + (`c'==7)*20
local gr="gen"
if `c'>1{
            local gr="replace"
          }
`gr'  age_group=`c' if D_ID_BIRTHDAY>= min_`age' & D_ID_BIRTHDAY< max_`age'
gen     age`age'`age1'  = age_group==`c'
}


/*----------------------------------------------------------------------------*/																		

/*merge ID　AREA_NO_I*/
sort ID
merge m:m ID using "$datapath\ID.dta",nogen keep(master match) keepusing(ID AREA_NO_I)

/*百萬人次裡面的地區代碼 是city98*/
qui gen cityno98 = AREA_NO_I
sort cityno98 
merge m:1 cityno98 using "D:\User_Data\Desktop\kan-2\1_Million\data\raw_data\CD_townshipnumber98_20200512.dta",nogen keep(master match) 

sort countytown
merge m:1 countytown using "D:\User_Data\Desktop\kan-2\1_Million\data\raw_data\Taiwan_Presidential_Election_Data_BYtown_2004.dta",nogen keep(master match) 

qui gen DDPtownP  = DDPtown/validtown
qui gen KMTtownP  = KMTtown/validtown

sum DDPtownP 
cap drop  qDDPtownP
qui xtile qDDPtownP  = DDPtownP ,nq(4)

/*gap = 0 票數接近中間的50%*/
qui gen gap = 1 if qDDPtownP ==1 | qDDPtownP==4
qui replace gap = 0 if qDDPtownP ==2 | qDDPtownP==3
tab gap
/*----------------------------------------------------------------------------*/																				
gen Dpsy=cd_`year1'_spirit-cd_`year2'_spirit
gen Dcd =cd_`year1'-cd_`year2'

gen R1=R+date("`year1'0918","YMD")
gen Rw6=wofd(R1+1)
gen Rw3=wofd(R1-2)
gen Rw =wofd(R1)

cap drop  scd_`year1'
cap drop  scd_`year2'
tostring Rw6, gen(W6)
tostring Rw3, gen(W3)

di "$S_DATE $S_TIME	save temp dta"
qui compress
save "D:\User_Data\Desktop\kan-2\1_Million\data\dataset\\`log'_temp_Sep.dta",replace
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

/*gen IDW6=ID+W6
bysort IDW6: egen s6Dcd=mean(Dcd)
bysort IDW6: egen s6Dpsy=mean(Dpsy)
bysort IDW6: egen s6cd_`year1'=mean(cd_`year1')
bysort IDW6: egen s6cd_`year2'=mean(cd_`year2')
bysort IDW6: egen s6cd_`year1'_spirit=mean(cd_`year1'_spirit)
bysort IDW6: egen s6cd_`year2'_spirit=mean(cd_`year2'_spirit)
bysort IDW6: gen Wday6=_n

sum Rw6 if R==0
local Rw6_0=r(mean)

replace Rw6=Rw6-`Rw6_0'

gen IDW3=ID+W3
bysort IDW3: egen s3Dcd=mean(Dcd)
bysort IDW3: egen s3Dpsy=mean(Dpsy)
bysort IDW3: egen s3cd_`year1'=mean(cd_`year1')
bysort IDW3: egen s3cd_`year2'=mean(cd_`year2')
bysort IDW3: egen s3cd_`year1'_spirit=mean(cd_`year1'_spirit)
bysort IDW3: egen s3cd_`year2'_spirit=mean(cd_`year2'_spirit)
bysort IDW3: gen Wday3=_n */


di "$S_DATE $S_TIME	check "
sum Rw3 if R==0
local Rw3_0=r(mean)
replace Rw3=Rw3-`Rw3_0'

/*bysort Rw6 ID_SEX gap: egen m6Dcd      = mean(Dcd)     
bysort Rw6 ID_SEX gap: egen m6Dpsy     = mean(Dpsy)    
bysort Rw6 ID_SEX gap: egen m6cd_`year1' = mean(cd_`year1') 
bysort Rw6 ID_SEX gap: egen m6cd_`year2' = mean(cd_`year2')  
bysort Rw6 ID_SEX gap: egen m6psy_`year1'= mean(cd_`year1'_spirit)   
bysort Rw6 ID_SEX gap: egen m6psy_`year2'= mean(cd_`year2'_spirit)   
bysort Rw6 ID_SEX gap: gen  Rw6n       = _n */
									   

bysort Rw3 ID_SEX gap: egen m3Dcd      = mean(Dcd)    
di "$S_DATE $S_TIME	check a"
bysort Rw3 ID_SEX gap: egen m3Dpsy     = mean(Dpsy)     
di "$S_DATE $S_TIME	check b"          
bysort Rw3 ID_SEX gap: egen m3cd_`year1' = mean(cd_`year1')  
di "$S_DATE $S_TIME	check c"              
bysort Rw3 ID_SEX gap: egen m3cd_`year2' = mean(cd_`year2')      
di "$S_DATE $S_TIME	check d"          
bysort Rw3 ID_SEX gap: egen m3psy_`year1'= mean(cd_`year1'_spirit)   
di "$S_DATE $S_TIME	check e"     
bysort Rw3 ID_SEX gap: egen m3psy_`year2'= mean(cd_`year2'_spirit)   
di "$S_DATE $S_TIME	check f"
bysort Rw3 ID_SEX gap: gen  Rw3n       = _n		
di "$S_DATE $S_TIME	check g"

di "$S_DATE $S_TIME	save final dta"
qui compress
save "`log'.dta",replace

/*----------------------------------------------------------------------------*/

global age "5059 6069 7099"
global age "4049 5059 6069 7099"
global sex "M F"

global B "1"
local bwidth "3"
keep if abs(R)<=$dayrange1
foreach bwidth of global B{
foreach gap of num 0/1{
foreach sex of global sex{
local bwidth1=`bwidth'
local male="Male"
if "`sex'"=="F"{
                local male="Female"
                }

global bandwidth ="bwidth(`bwidth')"
if "`bwidth'"=="0"{
                   global bandwidth = ""
                   local bwidth1 ="(rule-of-thumb)" 
                  }


// mean

#delimit ;
tw
(connect m3Dcd Rw3 if  sex=="`sex'" &  gap==`gap'  & abs(Rw3)<=$wrange1&Rw3n==1, ),
title("mean `year1'-`year2'  outpatient visits" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday is the first day of the week"
      , size(medium)
      )
legend(label(1 "`male', aged 40 up")
       )
xlabel(-$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean `year1' #visits minus `year2' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Outpatient`yr1'`yr2'_Weeks-`wrange'_Sex-`sex'_mean_Saturday_gap`gap'.pdf,as(pdf) replace

#delimit ;
tw 
(connect m3Dpsy Rw3 if  sex=="`sex'" &  gap==`gap'   & abs(Rw3)<=$wrange1&Rw3n==1 ),
title("mean `year1'-`year2' outpatient visits---psychological" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday is the first day of the week"
      , size(medium))
legend(label(1 "`male', aged 40 ")
       )
xlabel(
        -$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean `year1' #visits minus `year2' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Psycho`yr1'`yr2'_Weeks-`wrange'_Sex-`sex'_mean_Wednesday_gap`gap'.pdf ,as(pdf) replace


/* */
#delimit ;
tw
(connect m3cd_`year1' Rw3 if  sex=="`sex'" &  gap==`gap'   & abs(Rw3)<=$wrange1&Rw3n==1, ),
title("mean `year1'  outpatient visits" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday is the first day of the week"
      , size(medium)
      )
legend(label(1 "`male', aged 40 up")
       )
xlabel(-$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean `year1' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Outpatient`yr1'_Weeks-`wrange'_Sex-`sex'_mean_Wednesday_gap`gap'.pdf,as(pdf) replace

#delimit ;
tw 
(connect m3psy_`year1' Rw3 if  sex=="`sex'" &  gap==`gap'   & abs(Rw3)<=$wrange1&Rw3n==1 ),
title("mean `year1' outpatient visits---psychological" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday is the first day of the week"
      , size(medium))
legend(label(1 "`male', aged 40 ")
       )
xlabel(
        -$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean `year1' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Psycho`yr1'_Weeks-`wrange'_Sex-`sex'_mean_Wedneday_gap`gap'.pdf ,as(pdf) replace


#delimit ;
tw
(connect m3cd_`year2' Rw3 if  sex=="`sex'" &  gap==`gap'   & abs(Rw3)<=$wrange1&Rw3n==1, ),
title("mean `year2'  outpatient visits" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday-Tuesday Weekly Average"
      , size(medium)
      )
legend(label(1 "`male', aged 40 up")
       )
xlabel(-$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean  `year2' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Outpatient`yr2'_Weeks-`wrange'_Sex-`sex'_mean_Wednesday_gap`gap'.pdf,as(pdf) replace

#delimit ;
tw 
(connect m3psy_`year2' Rw3 if  sex=="`sex'" &  gap==`gap'   & abs(Rw3)<=$wrange1&Rw3n==1 ),
title("mean `year2' outpatient visits---psychological" 
      "$wrange1 weeks surrounding election day"
      "Sex = `sex',  Bandwidth = `bwidth1' Agegroup=`age'"
      "Wednesday-Tuesday Weekly Average"
      , size(medium))
legend(label(1 "`male', aged 40 ")
       )
xlabel(
        -$wrange1(1)$wrange1, grid angle(45) labsize(small)
       )
ylabel(, angle(45) labsize(small))
ytitle("mean `year2' #visits") 
xtitle("Weeks after election")
xline(0)
;
#delimit cr
graph export Psycho`yr2'_Weeks-`wrange'_Sex-`sex'_mean_Wednesday_gap`gap'.pdf ,as(pdf) replace



} /* sex */
} /* gap */
} /* bwidth */

log close 







