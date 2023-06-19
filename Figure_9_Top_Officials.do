* This do file replicates FIGURE IX in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 18, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global figdir   "$localdir\Figures"


********************************************************************************
**# Panels A and B

use "$dtadir\ProvGovernors.dta", clear

* Calculate the ratios from Hunan*Counnected counties in three periods: 1820-1853 (pre-war), 1854-1864 (in-war), and 1865-1899 (post-war)
gen ratio2053 = mobbased2053/num2053
gen ratio5464 = mobbased5464/num5464
gen ratio6599 = mobbased6599/num6599 


* Compare pre-war with in-war (exluding Hunan province)
scatter ratio5464 ratio2053 if provinceid!=6, ///
	ms(Oh) mc(blue) mlwidth(medthick) ///
	mlabel(prov_en) mlabsize(vsmall) mlabcolor(black) mlabposition(1) ///
	xlabel(0(0.1)0.3, labsize(small)) ///
	ylabel(0(0.1)0.3, angle(90) labsize(small)) ///
	title("A. 1820-53 (Pre-war) vs 1854-64 (In-war)") ///
	xtitle("From Hunan*connected counties, 1820-53", size(medium)) ///
	ytitle("From Hunan*connected counties, 1854-64", size(medium)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(pre_in, replace)


* Compare post-war with in-war (exluding Hunan province)
scatter ratio6599 ratio5464 if provinceid!=6, ///
	ms(Oh) mc(blue) mlwidth(medthick) ///
	mlabel(prov_en) mlabsize(vsmall) mlabcolor(black) mlabposition(1) ///
	xlabel(0(0.1)0.3, labsize(small)) ///
	ylabel(0(0.1)0.3, angle(90) labsize(small)) ///
	title("B. 1854-64 (In-war) vs 1854-99 (Post-war)") ///
	xtitle("From Hunan*connected counties, 1854-64", size(medium)) ///
	ytitle("From Hunan*connected counties, 1854-99", size(medium)) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	name(in_post, replace)
 
graph combine pre_in in_post, ///
	row(1) xsize(12) ysize(5) graphregion(fcolor(white) lcolor(white))
graph export "$figdir\Figure9_1_Share_of_Top_Officials.svg", replace


********************************************************************************
**# Panel C

twoway (lfitci Yangtze ratio5464 if provinceid!=6, ciplot(rline) lp(solid) lcolor(black)) ///
	(scatter Yangtze ratio5464, ms(Oh) mc(blue) mlwidth(medthick)), ///
	xlabel(, labsize(small)) ylabel(0(1)2, nogrid angle(90) labsize(small)) ///
	xtitle("From Hunan*connected counties, 1854-64", size(medium)) ytitle("") ///
	title("C. Prob of disobeying the imperial edict") ///
	legend(off) xsize(6) ysize(6) ///
	plotregion(fcolor(white) lcolor(white)) ///
	graphregion(fcolor(white) lcolor(white))
graph export "$figdir\Figure9_2_Prob_Disobey.svg", replace