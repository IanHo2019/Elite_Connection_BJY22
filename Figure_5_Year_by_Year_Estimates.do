* This do file replicates FIGURE V in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 17, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"


********************************************************************************
**# Re-Construct the Dataset
********************************************************************************
use "$dtadir\HunanCntyYr.dta",clear

* Zeng Guofan took power in 1853.
gen Post = (year>=1854)

foreach y of varlist Zeng_all0_invdist_pc Zeng_all0_pc Zenghu_all Zenghu_all_invdist  Zeng_all0 Zeng_all0_invdist Zeng_exam0_invdist Zeng_BMF_invdist Zeng_Juren_invdist lnarea capital lnurbanpop lnpop dist_nanjing lnjinshi lnquotas mainriv route1 dist2canal lnwheat lnrice {
	gen `y'_Post=`y'*Post
}


* Generate year dummies
tab year, gen(year)

local c=1
while `c'<16 {
	local t = `c'+1849
	rename year`c' yr`t'
	local ++c
}


* Generate interactions between independent variables and year dummies 
foreach y of varlist Zeng_all0_invdist Zeng_all0 Zeng_all0_invdist_pc Zeng_all0_pc {
	foreach x of varlist yr1850-yr1852 yr1854-yr1864 {
		gen `y'_`x' = `y'*`x'
	}
}


********************************************************************************
**# Run Event-Study DID Regressions
********************************************************************************

* Define control variables
global controls = "lnurbanpop_Post mainriv_Post dist2canal_Post lnwheat_Post lnrice_Post lnpop_Post lnarea_Post capital_Post lnjinshi_Post lnquotas_Post route1_Post dist_nanjing_Post"

* Weighted Connections
reghdfe lnmartyr1 Zeng_all0_invdist_yr* $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)
parmest, saving("$figdir\w_connect.dta", replace)

* Unweighted Connections
reghdfe lnmartyr1 Zeng_all0_yr* $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)
parmest, saving("$figdir\uw_connect.dta", replace)

* Weighted Connections per capita
reghdfe lnmartyr1 Zeng_all0_invdist_pc_yr* $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)
parmest, saving("$figdir\w_connect_pc.dta", replace)

* Unweighted Connections per capita
reghdfe lnmartyr1 Zeng_all0_pc_yr* $controls , ///
	absorb(year cntyid prefid#year) cluster(cntyid)
parmest, saving("$figdir\uw_connect_pc.dta", replace)


********************************************************************************
**# Draw Graphs
********************************************************************************
foreach y in w_connect uw_connect w_connect_pc uw_connect_pc {
	use "$figdir\\`y'.dta", clear

	* Generate year variable
	keep if _n <= 14
	gen year = substr(parm, -4, 4)
	destring year, replace

	keep year estimate min95 max95

	* Add base year: 1853
	set obs 15
	replace year = 1853 in 15
	replace estimate = 0 in 15
	replace min95 = 0 in 15
	replace max95 = 0 in 15

	sort year

	* Draw graph
	if "`y'"=="w_connect" {
		local panel = "A. Weighted connections"
		local axis = "-0.25(0.25)0.5"
	}
	
	if "`y'"=="uw_connect" {
		local panel = "B. Unweighted connections"
		local axis = "-0.25(0.25)0.5"
	}
	
	if "`y'"=="w_connect_pc" {
		local panel = "C. Weighted connections per capita"
		local axis = "-0.08(0.08)0.16"
	}
	
	if "`y'"=="uw_connect_pc" {
		local panel = "D. Unweighted connections per capita"
		local axis = "-0.08(0.08)0.16"
	}
	
	twoway (rcap max95 min95 year, lstyle(ci)) ///
		(scatter estimate year, mc(navy) msize(medlarge) connect(l) lc(black) lw(medthick)), ///
		yline(0, lpattern(solid) lcolor(red)) ///
		xline(1853, lpattern(solid) lcolor(blue)) ///
		title(`panel', size(medsmall) position(11)) xtitle("") ///
		xlabel(1850(5)1865, nogrid) ylabel(`axis', angle(90)) ///
		legend(order(2 "Effects of elite connections" 1 "95% CI") size(small) row(1) position(6) span region(lc(black))) ///
		plotregion(fcolor(white) lcolor(white)) ///
		graphregion(fcolor(white) lcolor(white)) ///
		name(`y', replace)
}

grc1leg w_connect uw_connect w_connect_pc uw_connect_pc, ///
	legendfrom(w_connect) cols(2) ///
	name(connect_effect, replace)
gr draw connect_effect, xsize(7) ysize(5)
graph export "$figdir\Figure5_Dynamic_Estimates.svg", replace
