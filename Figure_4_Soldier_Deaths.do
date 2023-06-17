* This do file replicates FIGURE IV in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 15, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"


********************************************************************************
use "$dtadir\HunanCntyYr.dta",clear

gen connect = (Zeng_all0_invdist > 0)

collapse (mean) martyr, by(year connect)

twoway (connect martyr year if connect==1, msymbol(O) mc(gs6) lc(gs6) lw(medthick)) ///
	(connect martyr year if connect==0, msymbol(Oh) mc(gs6) lp(dash) lc(gs6) lw(medthick)), ///
	xline(1853, lc(blue) lp(solid)) ///
	title("Number of soldier deaths:" "Connected & unconnected counties in Hunan", size(medium) height(5)) ///
	xtitle("Year") ytitle("") ///
	xlabel(1850(5)1865 1853, nogrid) ylabel(0(40)120, angle(90)) ///
	legend(order(1 "Connected" 2 "Unconnected") row(1) position(6) span region(lc(black))) ///
	xsize(8) ysize(6) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white))
graph export "$figdir\Figure4_Soldier_Death.svg", replace
