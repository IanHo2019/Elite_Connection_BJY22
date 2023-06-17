* This do file replicates TABLE II in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 15, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"


********************************************************************************
* Goal: Estimate the impact of elite connections on soldier deaths.
* Data: A balanced panel with 75 Hunan counties in 1850-1864.
* Method: Static DID.

use "$dtadir\HunanCntyYr.dta",clear

* Zeng Guofan took power in 1853.
gen Post = (year>=1854)

foreach y of varlist Zeng_all0_invdist_pc Zeng_all0_pc Zenghu_all Zenghu_all_invdist Zeng_all0 Zeng_all0_invdist Zeng_exam0_invdist Zeng_BMF_invdist Zeng_Juren_invdist lnarea capital lnurbanpop lnpop dist_nanjing lnjinshi lnquotas mainriv route1 dist2canal lnwheat lnrice {
	gen `y'_Post=`y'*Post
}

* Define control variables
global gcontrol = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnpop_Post lnarea_Post"
global pcontrol = "capital_Post lnjinshi_Post lnquotas_Post"
global wcontrol = "route1_Post dist_nanjing_Post"

********************************************************************************
**# DID Regressions: Panel A

* Measure of elite connections: inverse distance.

* col1: only control two FEs.
eststo col1: reghdfe lnmartyr1 Zeng_all0_invdist_Post, ///
	absorb(year cntyid) cluster(cntyid)

* col2: add geographic-economic controls
eststo col2: reghdfe lnmartyr1 Zeng_all0_invdist_Post $gcontrol , ///
	absorb(year cntyid) cluster(cntyid)

* col3: add political controls
eststo col3: reghdfe lnmartyr1 Zeng_all0_invdist_Post $gcontrol $pcontrol , ///
	absorb(year cntyid) cluster(cntyid)

* col4: add war controls
eststo col4: reghdfe lnmartyr1 Zeng_all0_invdist_Post $gcontrol $pcontrol $wcontrol , ///
	absorb(year cntyid) cluster(cntyid)


* Measure of elite connections: inverse distance, per capita.

* col5: only control two FEs.
eststo col5: reghdfe lnmartyr1 Zeng_all0_invdist_pc_Post, ///
	absorb(year cntyid) cluster(cntyid)

* col6: add all controls
eststo col6: reghdfe lnmartyr1 Zeng_all0_invdist_pc_Post $gcontrol $pcontrol $wcontrol , ///
	absorb(year cntyid) cluster(cntyid)


********************************************************************************
**# DID Regressions: Panel B

* Measure of elite connections: unweighted sum.

* col7: only control two FEs.
eststo col7: reghdfe lnmartyr1 Zeng_all0_Post, ///
	absorb(year cntyid) cluster(cntyid)

* col8: add all controls
eststo col8: reghdfe lnmartyr1 Zeng_all0_Post $gcontrol $pcontrol $wcontrol , ///
	absorb(year cntyid) cluster(cntyid)


* Measure of elite connections: unweighted sum, per capita.

* col9: only control two FEs.
eststo col9: reghdfe lnmartyr1 Zeng_all0_pc_Post, ///
	absorb(year cntyid) cluster(cntyid)

* col10: add all controls
eststo col10: reghdfe lnmartyr1 Zeng_all0_pc_Post $gcontrol $pcontrol $wcontrol , ///
	absorb(year cntyid) cluster(cntyid)


********************************************************************************
**# Export a TeX Table
label var Zeng_all0_invdist_Post "Baseline Connections"
label var Zeng_all0_invdist_pc_Post "Baseline Connections per capita"
label var Zeng_all0_Post "Baseline Connections"
label var Zeng_all0_pc_Post "Baseline Connections per capita"

estout col* using "$tabdir\Table2_DID_Estimates.tex", ///
	keep(Zeng_all0_invdist_Post Zeng_all0_invdist_pc_Post Zeng_all0_Post Zeng_all0_pc_Post) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) sty(tex) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{10}{c}}" "\hline \hline" ///
		"Dependent variable & \multicolumn{10}{c}{ln(Soldier deaths + 1)} \\ \cline{2-11}" ///
		"Connection measured by & \multicolumn{6}{c}{$\sum_{n=1}^{N_c} \frac{1}{d_{c,n}}$} & \multicolumn{4}{c}{$ N_c $} \\ \cmidrule(r){2-7}\cmidrule(l){8-11}" ///
		"& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) & (9) & (10) \\ \hline") ///
	prefoot("\hline" ///
		"Year FE	& Y & Y & Y & Y & Y & Y & Y & Y & Y & Y \\ " ///
		"Country FE	& Y & Y & Y & Y & Y & Y & Y & Y & Y & Y \\ " ///
		"Geographic-Economic Controls	&   & Y & Y & Y &   & Y &   & Y &   & Y \\ " ///
		"Political Controls	&   &   & Y & Y &   & Y &   & Y &   & Y \\ " ///
		"War Controls	&   &   &   & Y &   & Y &   & Y &   & Y \\ ") ///
	stats(N r2, nostar labels("Observations" "R-Squared") fmt("%9.0fc" 3)) ///
	postfoot("\hline\hline" "\end{tabular}}") replace