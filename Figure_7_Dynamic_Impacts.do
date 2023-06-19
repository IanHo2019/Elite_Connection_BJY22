* This do file replicates FIGURE V in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 18, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"


********************************************************************************
**# Re-Construct the Dataset

use "$dtadir\NationalCntyYr.dta", clear

* Select time window
keep if year >= 1820


* Generate interactions
gen nhXZenghu_all_invdist = nonhunan * Zenghu_all_invdist
gen hXZenghu_all_invdist = hunan * Zenghu_all_invdist
gen nhXZeng_all0_invdist = nonhunan * Zeng_all0_invdist
gen hXZeng_all0_invdist = hunan * Zeng_all0_invdist


* "period" is 1{year >= 1854}, "period1" is 1{year >= 1850 & year <= 1864}, "period2" is 1{year > 1864}.
foreach x of varlist hunan Zenghu_all_invdist Zeng_all0_invdist Zeng_all0_invdist_pc invdist0_L1 invdist0_F1 Zeng_exam0_invdist  Zeng_Extraexam_invdist Zeng_BMF_invdist Zeng_juren0_invdist nhXZenghu_all_invdist nhXZeng_all0_invdist hXZenghu_all_invdist hXZeng_all0_invdist {
	gen `x'Xperiod  = `x' * period
	gen `x'Xperiod1 = `x' * period1
	gen `x'Xperiod2 = `x' * period2
}


* Define controls
foreach x of varlist lnurbanpop mainriv dist2canal lnwheat lnrice lncntypop lncntyarea prefcap lnjinshi lncntyquota0 Taiping_route1 dist_nanjing {
	gen `x'Xperiod  = `x' * period
	gen `x'Xperiod1 = `x' * period1
	gen `x'Xperiod2 = `x' * period2
}


* Generate year dummies
tab year, gen(year)

local c=1
while `c'< 92 {
	local t = `c'+1819
	rename year`c' yr`t'
	local ++c
}

* Generate interations between indepenedent variables and year dummies
foreach y of varlist hunan Zeng_all0_invdist hXZeng_all0_invdist nhXZeng_all0_invdist Zenghu_all_invdist hXZenghu_all_invdist nhXZenghu_all_invdist {
	foreach x of varlist yr1821-yr1910 {
		gen `y'X`x' = `y' * `x'
	}
}



********************************************************************************
**# Run Regressions

* DID, Hunan and Non-Hunan
reghdfe alloff hXZeng_all0_invdistXyr1821-hXZeng_all0_invdistXyr1910 nhXZeng_all0_invdistXyr1821-nhXZeng_all0_invdistXyr1910 hunanXyr1821-hunanXyr1910 lnurbanpopXperiod-Taiping_route1Xperiod2, ///
	absorb(year samcntyid) cluster(prefid)
parmest, saving("$figdir\Figure7_DID.dta", replace)

* DDD
reghdfe alloff hXZeng_all0_invdistXyr1821-hXZeng_all0_invdistXyr1910 hunanXyr1821-hunanXyr1910 Zeng_all0_invdistXyr1821-Zeng_all0_invdistXyr1910 lnurbanpopXperiod-Taiping_route1Xperiod2, ///
	absorb(year samcntyid) cluster(prefid)
parmest, saving("$figdir\Figure7_DDD", replace)



********************************************************************************
**# Draw Graphs

local p = 1
foreach y in DID DID DDD {
	use "$figdir\Figure7_`y'.dta", clear
	
	if `p'==1 {
		local panel = "A. Hunan"
		keep if _n<=90
	}
	
	if `p'==2 {
		local panel = "B. Non-Hunan"
		keep if inrange(_n, 91, 180)
	}
	
	if `p'==3 {
		local panel = "C. Difference between Hunan and Non-Hunan"
		keep if _n<=90
	}
	
	gen year = substr(parm, -4, 4)
	destring year, replace

	keep year estimate min95 max95

	* Add base year: 1820
	set obs 91
	replace year = 1820 in 91
	replace estimate = 0 in 91
	replace min95 = 0 in 91
	replace max95 = 0 in 91
	
	sort year
	gen zero = 0	// this is generated just for plotting a horizontal line above all other plots
	
	twoway (rarea max95 min95 year, fc(gs12) lc(gs12)) ///
	(connect estimate year, msize(vsmall) lp(solid) lw(medthick) lc(gs7)) ///
	(line zero year, lp(dash) lw(medthick) lc(black)), ///
	xline(1850, lpattern(dash) lcolor(blue)) ///
	xline(1853, lpattern(solid) lcolor(blue)) ///
	xline(1864, lpattern(dash) lcolor(blue)) ///
	title("`panel'", position(11) size(medium)) ///
	xtitle("Year", size(medsmall)) ///
	xlabel(1820(30)1910, nogrid labsize(small)) ///
	ylabel(-0.2(0.1)0.3, angle(90) labsize(small)) ///
	legend(order(1 "95% CI" 2 "Effects of connections") rows(1) span size(small) region(lc(black)) position(6)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(graph`p', replace)
	
	local ++p
}

grc1leg graph1 graph2 graph3, ///
	legendfrom(graph1) position(7) rows(1) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(figure7, replace)

gr draw figure7, ysize(3) xsize(9)
graph export "$figdir\Figure7_Dynamic_Impacts.svg", replace