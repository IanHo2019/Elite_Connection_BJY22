* This do file replicates FIGURE VI in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 16, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"


********************************************************************************

* Data: a balanced panel of 1,646 counties over China in 1800-1910.
use "$dtadir\NationalCntyYr.dta",clear

gen connect = (Zenghu_all_invdist > 0)
gen death = (martyrs_tot_post > 0)

* Classify four groups
gen hunanXconnect = 1 if hunan==0 & connect==0
replace hunanXconnect = 2 if hunan==1 & connect==0
replace hunanXconnect = 3 if hunan==0 & connect==1
replace hunanXconnect = 4 if hunan==1 & connect==1

* Count number of counties in each group: (38, 670, 37, 901)
table year hunanXconnect

* Select time window
keep if year >= 1820

* Calculate the mean
collapse (mean) alloff, by(hunanXconnect year)

* Draw a graph
twoway (connect alloff year if hunanXconnect==4, m(O) msize(vsmall) mc(gs6) lp(solid) lc(gs6)) ///
	(connect alloff year if hunanXconnect==3, m(Oh) msize(vsmall) mc(gs6) lp(dash) lc(gs6)) ///
	(line alloff year if hunanXconnect==2, lp(solid) lc(gs6)) ///
	(line alloff year if hunanXconnect==1, lp(dash) lc(gs6)), ///
	xline(1850, lc(blue) lp(dash)) ///
	xline(1853, lc(blue) lp(solid)) ///
	xline(1864, lc(blue) lp(dash)) ///
	xlabel(1820(10)1910, nogrid) ylabel(, angle(90)) ///
	xtitle("Year") ytitle("") ///
	title("Average number of natioinal-level offices", position(11) size(medium)) ///
	legend(order(1 "Connected, Hunan (38)" 2 "Connected, non-Hunan (670)" 3 "Unconnected, Hunan (37)" 4 "Unconnected, non-Hunan (901)") row(2) size(small) span region(lc(black)) position(6)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white))
graph export "$figdir\Figure6_Number_of_Offices.svg", replace