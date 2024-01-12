
* The Interplay of Education, Gender and Income on Religiosity 
* A Comparative Study in Italy, Norway, and Switzerland

ssc install fre


* Set the working directory to the location of your dataset
cd "/Users/angelopillon/Desktop/Data Analysis Paper/"

* Load the data from the European Social Survey Round 10 - 2020
use ESS10.dta, clear


* Recode and explore the religiosity variable
lookfor religious
fre rlgdgr
hist rlgdgr
replace rlgdgr = . if rlgdgr == .b | rlgdgr == .c | rlgdgr == .d

recode rlgdgr (0/3 = 1 "Low") (4/7 = 2 "Medium") ///
    (8/10 = 3 "High"), gen(relint)
fre relint

* Recode and explore highst level of education variable
lookfor education
fre edulvlb
replace edulvlb = . if edulvlb == .b | edulvlb == .c | edulvlb == .d

drop if edulvlb == 5555

recode edulvlb (0/223 = 1 "Low") (229/423 = 2 "Medium") ///
    (510/800 = 3 "High"), gen(educ)
fre educ

* Recode and explore the total household's net income viariable
lookfor income
fre hinctnta
hist hinctnta
replace hinctnta = . if rlgdgr == .b | rlgdgr == .c | rlgdgr == .d

recode hinctnta (1/3 = 1 "Low") (4/7 = 2 "Medium") ///
    (8/10 = 3 "High"), gen(incgr)
fre incgr

* Explore and preprocess the gender variable
fre gndr
tab gndr, gen(dum)
fre dum1 dum2

* Sample selection: Keep only adults aged 18 to 80 in Italy, Switzerland, and Norway
keep if agea >= 18 & agea <= 80
keep if cntry == "IT" | cntry == "CH" | cntry == "NO"

* Create a Control Variable for Religiosity, Gender, and Education:
egen control = rownonmiss(rlgdgr gndr educ), strok
fre control

* Keep Only Valid Cases for my analysis:
keep if control == 3 

* Calculate summary statistics for religiosity, education, gender, and net income
summarize rlgdgr educ gndr incgr


***** Hypothesis Testing *****
  
* Hypothesis 1: People with higher education tend to be less religious
reg rlgdgr i.educ

margins educ
marginsplot, title("Relationship Between Education and Religiosity") ///
    xtitle("Education Level") ytitle("Level of Religiosity")

* Hypothesis 2: Women tend to be more religious than men
ttest rlgdgr, by(gndr) unequal

graph bar (mean) rlgdgr, over(gndr) blabel(bar, format(%9.2f)) ytitle("Religiosity Levels") title("Difference in Religiosity Between Men and Women")


* Hypothesis 3: People with higher net income tend to be less religious
reg rlgdgr hinctnta

reg rlgdgr i.incgr
margins incgr
marginsplot, title("Relationship Between Net Income and Religiosity") ///
    xtitle("Net Income Level") ytitle("Level of Religiosity") noci








