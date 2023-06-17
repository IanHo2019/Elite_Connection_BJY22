* This do file replicates TABLE III in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 16, 2023

* Goal: Estimate the impacts of different types of elite connections on soldier deaths.
* Method: Static DID.
********************************************************************************

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"



********************************************************************************
**# Table 3 Columns (1)-(4)
* Data: A balanced panel with 75 Hunan counties in 1850-1864.

use "$dtadir\HunanCntyYr.dta", clear


* Zeng Guofan took power in 1853.
gen Post = (year>=1854)


* Define control variables
foreach y of varlist Zeng_all0_invdist_pc Zeng_all0_pc Zenghu_all Zenghu_all_invdist Zeng_all0 Zeng_all0_invdist Zeng_exam0_invdist Zeng_BMF_invdist Zeng_Juren_invdist lnarea capital lnurbanpop lnpop dist_nanjing lnjinshi lnquotas mainriv route1 dist2canal lnwheat lnrice {
	gen `y'_Post=`y'*Post
}

global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnpop_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"


* Edit labels for row names
label var Zenghu_all_invdist_Post "Expanded network $ \times $ post"
label var Zeng_BMF_invdist_Post "Blood, marriage, and friends $ \times $ post"
label var Zeng_Juren_invdist_Post "Provincial-level exam connections $ \times $ post"
label var Zeng_exam0_invdist_Post "National-level eam connections $ \times $ post"


* Column (1): Expanded network
eststo col1: reghdfe lnmartyr1 Zenghu_all_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

* Column (2): Blood, marriage, and friends
eststo col2: reghdfe lnmartyr1 Zeng_BMF_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

* Column (3): Provincial-level exam connections
eststo col3: reghdfe lnmartyr1 Zeng_Juren_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

* Column (4): National-level exam connections
eststo col4: reghdfe lnmartyr1 Zeng_exam0_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

* Export a LaTeX table
estout col* using "$tabdir\Table3_1_Expanded_Network.tex", ///
	keep(Zenghu_all_invdist_Post Zeng_BMF_invdist_Post Zeng_Juren_invdist_Post Zeng_exam0_invdist_Post) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\begin{tabular}{l*{4}{c}}" "\hline \hline" ///
		"& (1) & (2) & (3) & (4) \\ \hline") ///
	prefoot("\hline" ///
		"County FE	& Y & Y & Y & Y \\ " ///
		"Year FE	& Y & Y & Y & Y \\ " ///
		"Controls $ \times $ post	& Y & Y & Y & Y \\ " ///
		"Pref $ \times $ year FE	& Y & Y & Y & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}") replace



********************************************************************************
**# Table 3 column (5)-(7)
* Data: A balanced panel with 27,000 county-surname pairs in Hunan in 1850-1864.
clear all
use "$dtadir\HunanSurname.dta"

* Zeng Guofan took power in 1853.
gen Post = (year>=1854)


* Define control variables
foreach y of varlist sur_invdis_zeng_all0 lnurbanpop mainriv dist2canal lnwheat lnrice lnhh lnarea capital lnjinshi lnquotas route1 dist_nanjing {
	gen `y'_Post=`y'*Post
}

global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnhh_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"


* Select subsample whose connected surname or martyr surname does not equal 0
bysort cntyid surname_id: egen mean_sur_invdis_zeng_all0 = mean(sur_invdis_zeng_all0)
bysort cntyid surname_id: egen mean_martyr_surname = mean(martyr_surname)

gen subsample = (mean_sur_invdis_zeng_all0 != 0 | mean_martyr_surname != 0)
gen subsample_network = (mean_sur_invdis_zeng_all0 != 0)
gen subsample_martyr = (mean_martyr_surname != 0)


* Construct diff-surname baseline connections
bysort cntyid year: egen sum_sur_invdis_zeng_all0 = sum(sur_invdis_zeng_all0)
gen oth_sur_invdis_zeng_all0 = sum_sur_invdis_zeng_all0 - sur_invdis_zeng_all0
gen oth_sur_invdis_zeng_all0_Post = oth_sur_invdis_zeng_all0 * Post


* Edit labels for row names
label var sur_invdis_zeng_all0_Post "Same-surname baseline connections $ \times $ post"
label var oth_sur_invdis_zeng_all0_Post "Diff-surname baseline connections $ \times $ post"


* Column (5)
eststo col5: reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post $controls if subsample==1, ///
	absorb(cntyid year prefid#year surname_id#year cntyid#surname) cluster(cntyid surname_id)

* Column (6)
eststo col6: reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post $controls if subsample==1, ///
	absorb(cntyid year prefid#year surname_id#year cntyid#surname) cluster(cntyid surname_id)

* Column (7)
eststo col7: reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post if subsample==1, ///
	absorb(cntyid year surname_id#year cntyid#surname year#cntyid) cluster(cntyid surname_id)

* Export a LaTeX table
estout col* using "$tabdir\Table3_2_Surname.tex", ///
	keep(sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\begin{tabular}{l*{3}{p{0.12\textwidth}<{\centering}}}" "\hline \hline" ///
		"& (5) & (6) & (7) \\ \hline") ///
	prefoot("\hline" ///
		"County FE	& Y & Y & Y \\ " ///
		"Year FE	& Y & Y & Y \\ " ///
		"Controls $ \times $ post	& Y & Y & \\ " ///
		"Pref $ \times $ year FE	& Y & Y & \\ " ///
		"Year $ \times $ surname FE	& Y & Y & Y \\ " ///
		"County $ \times $ surname FE	& Y & Y & Y \\ " ///
		"Year $ \times $ county FE	&  &  & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}") replace




/* Use "outreg2"
********************************************************************************
**# Table 3 Columns (1)-(4)
* Data: A balanced panel with 75 Hunan counties in 1850-1864.

use "$dtadir\HunanCntyYr.dta", clear


* Zeng Guofan took power in 1853.
gen Post = (year>=1854)


* Define control variables
foreach y of varlist Zeng_all0_invdist_pc Zeng_all0_pc Zenghu_all Zenghu_all_invdist Zeng_all0 Zeng_all0_invdist Zeng_exam0_invdist Zeng_BMF_invdist Zeng_Juren_invdist lnarea capital lnurbanpop lnpop dist_nanjing lnjinshi lnquotas mainriv route1 dist2canal lnwheat lnrice {
	gen `y'_Post=`y'*Post
}

global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnpop_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"


* Edit labels for row names
label var Zenghu_all_invdist_Post "Expanded network $ \times $ post"
label var Zeng_BMF_invdist_Post "Blood, marriage, and friends $ \times $ post"
label var Zeng_Juren_invdist_Post "Provincial-level exam connections $ \times $ post"
label var Zeng_exam0_invdist_Post "National-level eam connections $ \times $ post"

* Column (1): Expanded network
reghdfe lnmartyr1 Zenghu_all_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

outreg2 using "$tabdir\Table3_1_Expanded_Network.tex", replace ///
	keep(Zenghu_all_invdist_Post Zeng_BMF_invdist_Post Zeng_Juren_invdist_Post Zeng_exam0_invdist_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y)


* Column (2): Blood, marriage, and friends
reghdfe lnmartyr1 Zeng_BMF_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

outreg2 using "$tabdir\Table3_1_Expanded_Network.tex", append ///
	keep(Zenghu_all_invdist_Post Zeng_BMF_invdist_Post Zeng_Juren_invdist_Post Zeng_exam0_invdist_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y)


* Column (3): Provincial-level exam connections
reghdfe lnmartyr1 Zeng_Juren_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

outreg2 using "$tabdir\Table3_1_Expanded_Network.tex", append ///
	keep(Zenghu_all_invdist_Post Zeng_BMF_invdist_Post Zeng_Juren_invdist_Post Zeng_exam0_invdist_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y)


* Column (4): National-level exam connections
reghdfe lnmartyr1 Zeng_exam0_invdist_Post $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)

outreg2 using "$tabdir\Table3_1_Expanded_Network.tex", append ///
	keep(Zenghu_all_invdist_Post Zeng_BMF_invdist_Post Zeng_Juren_invdist_Post Zeng_exam0_invdist_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y)



********************************************************************************
**# Table 3 column (5)-(7)
* Data: A balanced panel with 27,000 county-surname pairs in 1850-1864.

use "$dtadir\HunanSurname.dta",clear

* Zeng Guofan took power in 1853.
gen Post = (year>=1854)


* Define control variables
foreach y of varlist sur_invdis_zeng_all0 lnurbanpop mainriv dist2canal lnwheat lnrice lnhh lnarea capital lnjinshi lnquotas route1 dist_nanjing {
	gen `y'_Post=`y'*Post
}

global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnhh_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"


* Select subsample whose connected surname or martyr surname does not equal 0
bysort cntyid surname_id: egen mean_sur_invdis_zeng_all0 = mean(sur_invdis_zeng_all0)
bysort cntyid surname_id: egen mean_martyr_surname = mean(martyr_surname)

gen subsample = (mean_sur_invdis_zeng_all0 != 0 | mean_martyr_surname != 0)
gen subsample_network = (mean_sur_invdis_zeng_all0 != 0)
gen subsample_martyr = (mean_martyr_surname != 0)


* Construct diff-surname baseline connections
bysort cntyid year: egen sum_sur_invdis_zeng_all0 = sum(sur_invdis_zeng_all0)
gen oth_sur_invdis_zeng_all0 = sum_sur_invdis_zeng_all0 - sur_invdis_zeng_all0
gen oth_sur_invdis_zeng_all0_Post = oth_sur_invdis_zeng_all0 * Post


* Edit labels for row names
label var sur_invdis_zeng_all0_Post "Same-surname baseline connections $ \times $ post"
label var oth_sur_invdis_zeng_all0_Post "Diff-surname baseline connections $ \times $ post"


* Column (5)
reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post $controls if subsample==1, ///
	absorb(cntyid year prefid#year surname_id#year cntyid#surname) cluster(cntyid surname_id)

outreg2 using "$tabdir\Table3_2_Surname.tex", replace ///
	keep(sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y, Year-surname FE, Y, County-surname FE, Y, Year-county, -)

* Column (6)
reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post $controls if subsample==1, ///
	absorb(cntyid year prefid#year surname_id#year cntyid#surname) cluster(cntyid surname_id)

outreg2 using "$tabdir\Table3_2_Surname.tex", append ///
	keep(sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, Y, Pref-year FE, Y, Year-surname FE, Y, County-surname FE, Y, Year-county, -)

* Column (7)
reghdfe lnmartyr_surname1 sur_invdis_zeng_all0_Post if subsample==1, ///
	absorb(cntyid year surname_id#year cntyid#surname year#cntyid) cluster(cntyid surname_id)

outreg2 using "$tabdir\Table3_2_Surname.tex", append ///
	keep(sur_invdis_zeng_all0_Post oth_sur_invdis_zeng_all0_Post) ///
	label sdec(3) nocons nonotes ctitle(" ") ///
	addtext(County FE, Y, Year FE, Y, County-level controls, -, Pref-year FE, -, Year-surname FE, Y, County-surname FE, Y, Year-county, Y)