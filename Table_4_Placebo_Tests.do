* This do file replicates TABLE IV in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 16, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"



********************************************************************************
**# Placebo Test 1, Columns (1)-(6)
********************************************************************************

use "$dtadir\HunanCntyYr.dta", clear


* Zeng Guofan took power in 1853.
gen Post = (year>=1854)

foreach y of varlist Zeng_all0_invdist_pc Zeng_all0_pc Zenghu_all Zenghu_all_invdist Zeng_all0 Zeng_all0_invdist Zeng_exam0_invdist Zeng_BMF_invdist Zeng_Juren_invdist invdist0_L1 invdist0_F1 lnarea capital lnurbanpop lnpop dist_nanjing lnjinshi lnquotas mainriv route1 dist2canal lnwheat lnrice {
	gen `y'_Post=`y'*Post
}


* Define control variables
global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnpop_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"


* Change the year when Zeng passed the national-level exam.
* Data: a balanced panel with 74 Hunan counties in 1850-1864.
* Note: Zeng's home county (cntyid is 25) is excluded.

* OLS
eststo col1: reghdfe lnmartyr1 Zeng_exam0_invdist_Post invdist0_L1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)

eststo col2: reghdfe lnmartyr1 Zeng_exam0_invdist_Post invdist0_F1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)

eststo col3: reghdfe lnmartyr1 Zeng_exam0_invdist_Post invdist0_L1_Post invdist0_F1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)


* IV
eststo col4: ivreghdfe lnmartyr1 (Zeng_all0_invdist_Post =Zeng_exam0_invdist_Post) invdist0_L1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)

eststo col5: ivreghdfe lnmartyr1 (Zeng_all0_invdist_Post =Zeng_exam0_invdist_Post) invdist0_F1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)

eststo col6: ivreghdfe lnmartyr1 (Zeng_all0_invdist_Post =Zeng_exam0_invdist_Post) invdist0_L1_Post invdist0_F1_Post $controls if cntyid!=25, ///
	absorb(year cntyid prefid#year) cluster(cntyid)

* Export a LaTeX table
label var Zeng_all0_invdist_Post "Baseline connections $ \times $ Post"
label var Zeng_exam0_invdist_Post "National-level exam connections $ \times $ Post"
label var invdist0_L1_Post "Placebo connections I $ \times $ Post"
label var invdist0_F1_Post "Placebo connections II $ \times $ Post"

estout col* using "$tabdir\Table4_Placebo1.tex", ///
	keep(Zeng_all0_invdist_Post Zeng_exam0_invdist_Post invdist0_L1_Post invdist0_F1_Post) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{6}{c}}" "\hline \hline" ///
		"Sample & \multicolumn{6}{c}{Hunan} \\ \cline{2-7}" ///
		"& \multicolumn{3}{c}{OLS estimates} & \multicolumn{3}{c}{IV estimates} \\ \cmidrule(r){2-4}\cmidrule(l){5-7}" ///
		"& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline") ///
	prefoot("\hline" ///
		"Year FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"County FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"Controls $ \times $ Post	& Y & Y & Y & Y & Y & Y \\ " ///
		"Pref $ \times $ year FE	& Y & Y & Y & Y & Y & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}}") replace



********************************************************************************
**# Placebo Test 2, Columns (7)-(11)
********************************************************************************
clear all

* Data: a balanced panel with 133 counties in Huai region in 1850-1864.
use "$dtadir\HuaiYr.dta"


* Zeng Guofan took power in 1853.
gen Post = (year>=1854)

foreach y of varlist Zeng_all0_invdist Zeng_exam0_invdist invdist0_L1 invdist0_F1 lnurbanpop mainriv dist2canal lnwheat lnrice lncntypop lncntyarea prefcap lnjinshi lncntyquota0 Taiping_route1 dist_nanjing {
	gen `y'_Post=`y'*Post
}


* Define control variables
global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lncntypop_Post lncntyarea_Post prefcap_Post lnjinshi_Post lncntyquota0_Post Taiping_route1_Post dist_nanjing_Post"


* Regressions
eststo col7: reghdfe lnmartyr_yr Zeng_all0_invdist_Post $controls , ///
	absorb(year samcntyid prefid#year) cluster(samcntyid)

eststo col8: reghdfe lnmartyr_yr Zeng_exam0_invdist_Post $controls , ///
	absorb(year samcntyid prefid#year) cluster(samcntyid)

eststo col9: reghdfe lnmartyr_yr Zeng_exam0_invdist_Post invdist0_L1_Post $controls , ///
	absorb(year samcntyid prefid#year) cluster(samcntyid)

eststo col10: reghdfe lnmartyr_yr Zeng_exam0_invdist_Post invdist0_F1_Post $controls , ///
	absorb(year samcntyid prefid#year) cluster(samcntyid)

eststo col11: reghdfe lnmartyr_yr Zeng_exam0_invdist_Post invdist0_L1_Post invdist0_F1_Post $controls , ///
	absorb(year samcntyid prefid#year) cluster(samcntyid)


* Export a LaTeX table
label var Zeng_all0_invdist_Post "Baseline connections $ \times $ Post"
label var Zeng_exam0_invdist_Post "National-level exam connections $ \times $ Post"
label var invdist0_L1_Post "Placebo connections I $ \times $ Post"
label var invdist0_F1_Post "Placebo connections II $ \times $ Post"

estout col* using "$tabdir\Table4_Placebo2.tex", ///
	keep(Zeng_all0_invdist_Post Zeng_exam0_invdist_Post invdist0_L1_Post invdist0_F1_Post) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{5}{c}}" "\hline \hline" ///
		"Sample & \multicolumn{5}{c}{Huai region} \\ \cline{2-6}" ///
		"& (7) & (8) & (9) & (10) & (11) \\ \hline") ///
	prefoot("\hline" ///
		"Year FE	& Y & Y & Y & Y & Y \\ " ///
		"County FE	& Y & Y & Y & Y & Y \\ " ///
		"Controls $ \times $ Post	& Y & Y & Y & Y & Y \\ " ///
		"Pref $ \times $ year FE	& Y & Y & Y & Y & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}}") replace