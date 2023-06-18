* This do file replicates TABLE V in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 17, 2023

* Goal: Estimate the impact of elite connections on number of national-level offices.
* Data: A balanced panel with 1646 counties over China in 1820-1910.
* Method: Static DID and DDD.
********************************************************************************

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"


********************************************************************************

use "$dtadir\NationalCntyYr.dta",clear


* Select time window
keep if year>=1820


* Generate interactions
gen nhXZenghu_all_invdist = nonhunan * Zenghu_all_invdist
gen hXZenghu_all_invdist = hunan * Zenghu_all_invdist
gen nhXZeng_all0_invdist = nonhunan * Zeng_all0_invdist
gen hXZeng_all0_invdist = hunan * Zeng_all0_invdist

foreach x of varlist Zeng_all0_invdist hXZeng_all0_invdist hunan {
	gen `x'Xperiod = `x' * period
}

foreach x of varlist lnurbanpop mainriv dist2canal lnwheat lnrice lncntypop lncntyarea prefcap lnjinshi lncntyquota0 Taiping_route1 dist_nanjing {
	gen `x'Xperiod = `x' * period
}

global Xcontrols = "lnurbanpopXperiod mainrivXperiod dist2canalXperiod lnwheatXperiod lnriceXperiod lncntypopXperiod lncntyareaXperiod prefcapXperiod lnjinshiXperiod lncntyquota0Xperiod Taiping_route1Xperiod dist_nanjingXperiod"


* DID, Hunan
eststo col1: reghdfe alloff Zeng_all0_invdistXperiod if hunan==1, ///
	absorb(year samcntyid) cluster(prefid)

eststo col2: reghdfe alloff Zeng_all0_invdistXperiod $Xcontrols if hunan==1, ///
	absorb(year samcntyid) cluster(prefid)


* DID, non-Hunan
eststo col3: reghdfe alloff Zeng_all0_invdistXperiod if hunan==0, ///
	absorb(year samcntyid) cluster(prefid)

eststo col4: reghdfe alloff Zeng_all0_invdistXperiod $Xcontrols if hunan==0, ///
	absorb(year samcntyid) cluster(prefid)


* DDD, all counties
eststo col5: reghdfe alloff Zeng_all0_invdistXperiod hXZeng_all0_invdistXperiod hunanXperiod, ///
	absorb(year samcntyid) cluster(prefid)

eststo col6: reghdfe alloff Zeng_all0_invdistXperiod hXZeng_all0_invdistXperiod hunanXperiod $Xcontrols , ///
	absorb(year samcntyid) cluster(prefid)


* Export a LaTeX table
label var Zeng_all0_invdistXperiod "Baseline connections $ \times $ 1854-1910"
label var hXZeng_all0_invdistXperiod "Baseline Connections $ \times $ Hunan $ \times $ 1854-1910"
label var hunanXperiod "Hunan $ \times $ 1854-1910"

estout col* using "$tabdir\Table5_DID_and_DDD_Estimates.tex", ///
	keep(Zeng_all0_invdistXperiod hXZeng_all0_invdistXperiod hunanXperiod) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{6}{c}}" "\hline \hline" ///
		"Specification & \multicolumn{4}{c}{DID} & \multicolumn{2}{c}{DDD} \\ \cmidrule(r){2-5}\cmidrule(l){6-7}" ///
		"Sample & \multicolumn{2}{c}{Hunan} & \multicolumn{2}{c}{Non-Hunan} & \multicolumn{2}{c}{All} \\ \cmidrule(r){2-3}\cmidrule(lr){4-5}\cmidrule(l){6-7}" ///
		"& (1) & (2) & (3) & (4) & (5) & (6) \\ \hline") ///
	prefoot("\hline" ///
		"County FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"Year FE	& Y & Y & Y & Y & Y & Y \\ " ///
		"Controls $ \times $ 1854-1910	&  & Y &  & Y &  & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}}") replace
