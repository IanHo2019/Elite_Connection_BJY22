* This do file replicates TABLE VI in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 18, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"


********************************************************************************
* Goal: Check the role of soldier deaths in explaining the power effect of elite connections.
* Data: A balanced panel with 1,646 counties over China in 1820-1910.
* Method: DDD and IV.

use "$dtadir\NationalCntyYr.dta",clear


* Select years
keep if year >= 1820


* Generate interactions
gen hXZeng_all0_invdist = hunan * Zeng_all0_invdist
gen hXZeng_exam0_invdist = hunan * Zeng_exam0_invdist
gen hXZeng_Extraexam_invdist = hunan * Zeng_Extraexam_invdist

foreach x of varlist hunan Zeng_all0_invdist Zenghu_all_invdist Zeng_exam0_invdist Zeng_Extraexam_invdist hXZeng_all0_invdist hXZeng_exam0_invdist hXZeng_Extraexam_invdist martyrs_tot_post {
	gen `x'Xperiod = `x' * period
}


* Define controls
foreach x of varlist lnurbanpop mainriv dist2canal lnwheat lnrice lncntypop lncntyarea prefcap lnjinshi lncntyquota0 Taiping_route1 dist_nanjing {
	gen `x'Xperiod = `x' * period
}

global controls = "lnurbanpopXperiod mainrivXperiod dist2canalXperiod lnwheatXperiod lnriceXperiod lncntypopXperiod lncntyareaXperiod prefcapXperiod lnjinshiXperiod lncntyquota0Xperiod Taiping_route1Xperiod dist_nanjingXperiod"


* DDD (OLS) regressions
eststo col1: reghdfe alloff hXZeng_all0_invdistXperiod Zeng_all0_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)

eststo col2: reghdfe alloff martyrs_tot_postXperiod Zeng_all0_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)

eststo col3: reghdfe alloff hXZeng_all0_invdistXperiod martyrs_tot_postXperiod Zeng_all0_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)


* IV regressions, overidentified cases
eststo col4: ivreghdfe alloff (martyrs_tot_postXperiod = hXZeng_exam0_invdistXperiod hXZeng_Extraexam_invdistXperiod) Zeng_exam0_invdistXperiod Zeng_Extraexam_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)

eststo col5: ivreghdfe alloff (martyrs_tot_postXperiod =     hXZeng_Extraexam_invdistXperiod) hXZeng_exam0_invdistXperiod Zeng_exam0_invdistXperiod Zeng_Extraexam_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)

eststo col6: ivreghdfe alloff (martyrs_tot_postXperiod = hXZeng_exam0_invdistXperiod) hXZeng_Extraexam_invdistXperiod Zeng_exam0_invdistXperiod Zeng_Extraexam_invdistXperiod hunanXperiod $controls , ///
	absorb(year samcntyid) cluster(prefid)


* Export a LaTeX table
label var hXZeng_all0_invdistXperiod "Baseline connections $ \times $ Hunan $ \times $ 1854-1910"
label var martyrs_tot_postXperiod "$ \text{Soldier Deaths}_{1854-64} \times $ 1854-1910"
label var hXZeng_exam0_invdistXperiod "Natl-level exam connections $ \times $ Hunan $ \times $ 1854-1910"
label var hXZeng_Extraexam_invdistXperiod "Other connections $ \times $ Hunan $ \times $ 1854-1910"
label var Zeng_all0_invdistXperiod "Baseline connections $ \times $ 1854-1910"
label var Zeng_exam0_invdistXperiod "Natl-level exam connections $ \times $ 1854-1910"
label var Zeng_Extraexam_invdistXperiod "Other connections $ \times $ 1854-1910"
label var hunanXperiod "Hunan $ \times $ 1854-1910"

sum alloff
local m = `r(mean)'

estout col* using "$tabdir\Table6_Deaths_Explain_Power.tex", ///
	keep(hXZeng_all0_invdistXperiod martyrs_tot_postXperiod hXZeng_exam0_invdistXperiod hXZeng_Extraexam_invdistXperiod Zeng_all0_invdistXperiod Zeng_exam0_invdistXperiod Zeng_Extraexam_invdistXperiod hunanXperiod) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{6}{c}}" "\hline \hline" ///
		"Dependent variable & \multicolumn{6}{c}{National-level offices (mean: `m')} \\ \cline{2-7}" ///
		"Methods & \multicolumn{3}{c}{OLS} & \multicolumn{3}{c}{IV} \\ \cmidrule(r){2-4}\cmidrule(l){5-7}" ///
		"& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline") ///
	prefoot("\hline" ///
		"County FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"Year FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"Controls $ \times $ 1854-1910	& Y & Y &  & Y & Y & Y \\ ") ///
	stats(N r2 cdf jp, nostar labels("Observations" "R-Squared" "First-stage F-test" "Overidentification test p-value") fmt("%9.0fc" 3 1 2)) ///
	postfoot("\hline\hline" "\end{tabular}}") replace