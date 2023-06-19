* This do file replicates FIGURE VIII in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 17, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"



********************************************************************************
*## Calculate Ellison-Glaeser Index
********************************************************************************

* Data: a balanced panel of 1,646 counties over China in 1820-1910.
use "$dtadir\EG_Index.dta", clear

* Generate a dummy indicating Hunan 
gen hunan = (provcd==11)

* Calculate number of offices net the effect of (Hunan * Connections) 
gen alloff_NoConn = alloff
replace alloff_NoConn = alloff_NoConn - estimate * Zeng_all0_invdist if hunan==1

* Aggregate at province-year level
collapse (sum) alloff alloff_NoConn labor, by(provcd year)

* Calculate the EG indices
bysort year: egen tot_labor = total(labor)
gen x = labor/tot_labor

gen x2 = x^2
bysort year: egen sigmax2 = total(x2)

local vars "alloff alloff_NoConn"

foreach y of local vars {
	bysort year: egen t`y' = total(`y')
	gen s`y' = `y'/t`y'
	gen H`y' = 1/t`y'
	gen sminusx`y' = s`y' - x
	gen sminusx2`y' = (s`y' - x)^2
	bysort year: egen G`y' = total(sminusx2`y')
	gen gama`y' = (G`y'-(1-sigmax2)*H`y')/((1-sigmax2)*(1-H`y'))
}

keep if provcd==11
keep year gamaalloff gamaalloff_NoConn 

gen hXconnRole = gamaalloff - gamaalloff_NoConn

label var hXconnRole "The role of Hunan*Connections"
label var gamaalloff "EG Index"
label var gamaalloff_NoConn "Counterfactual: Net the effect of Hunan*Connections"



********************************************************************************
*## Draw Graphs
********************************************************************************

twoway (scatter gamaalloff year, ms(O) mc(gs4) msize(medium)) ///
	(scatter gamaalloff_NoConn year, ms(Oh) mc(blue) msize(medium) mlwidth(medthick)), ///
	xline(1853, lc(gs11) lp(solid)) ///
	xline(1850, lc(gs11)) xline(1864, lc(gs11)) ///
	ylabel(0(0.02)0.06, angle(90)) xlabel(1820(30)1910, nogrid) ///
	xtitle("Year") ytitle("EG index") title("A. EG Index", size(medlarge)) ///
	legend(order(1 "Real" 2 "Counterfactual: Net the effect of Hunan*connections") rows(1) size(small) span region(lc(black)) position(6)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(panelA, replace)

scatter hXconnRole year, ///
	ms(Oh) mc(gs1) mlwidth(medthick) msize(medium) ///
	xline(1853, lc(gs11) lp(solid)) ///
	xline(1850, lc(gs11)) xline(1864, lc(gs11)) ///
	xtitle("Year") ytitle("Difference in the two indices") ///
	title("B. The Role of Hunan*Connections", size(medlarge)) ///
	xlabel(1820(30)1910, nogrid) ylabel(0(0.01)0.03, angle(90)) ///
	legend(on order(1 "The role of Hunan*connections") size(small) span region(lc(black)) position(6)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(panelB, replace)

graph combine panelA panelB, ///
	row(1) xsize(9) ysize(4.5) graphregion(fcolor(white) lcolor(white))

graph export "$figdir\Figure8_Power_Distribution.svg", replace