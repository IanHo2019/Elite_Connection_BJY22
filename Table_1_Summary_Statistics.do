* This do file replicates TABLE I in Bai, Jia & Yang (2022).
* Author: Ian He
* Date: Jun 18, 2023

clear all

global localdir "D:\research\Bai, Jia & Yang (2022)"

global dtadir   "$localdir\Data"
global tabdir   "$localdir\Tables"


********************************************************************************
*** Using "listtex" ************************************************************
********************************************************************************

**# Panel A: Hunan counties, 1850-1864
use "$dtadir\HunanCntyYr.dta",clear

* Edit unit, names, and labels
replace martyrs_tot_hn = martyrs_tot_hn/10^3

* Summarize the variables
local outlist = "martyr martyrs_tot_hn Zeng_all0_invdist Zeng_all0_invdist_pc lnarea lnpop lnrice lnwheat mainriv dist2canal lnurbanpop capital lnjinshi lnquotas dist_nanjing route1"

foreach var in `outlist' {
	qui{
		sum `var'
		local N1_`var' = `r(N)'
		local m1_`var' = `r(mean)'
		local sd1_`var' = `r(sd)'
	}
}
	
g labels = ""
local row = 1

* Customize row names
replace labels = "Number of soldier deaths by year" in `row'
local ++row
replace labels = "Number of soldier deaths during 1854-64 (1K)" in `row'
local ++row
replace labels = "Elite connections, baseline networks (weighted)" in `row'
local ++row
replace labels = "Elite connections per capita, baseline networks (weighted)" in `row'
local ++row
replace labels = "Number of national-level offices" in `row'
local ++row
replace labels = "ln area" in `row'
local ++row
replace labels = "ln population" in `row'
local ++row
replace labels = "ln rice suitability" in `row'
local ++row
replace labels = "ln wheat suitability" in `row'
local ++row
replace labels = "Main river dummy" in `row'
local ++row
replace labels = "Distance to the Grand Cannal" in `row'
local ++row
replace labels = "ln urban population" in `row'
local ++row
replace labels = "Prefecture capital" in `row'
local ++row
replace labels = "ln number of Jinshi" in `row'
local ++row
replace labels = "ln quotas for the entry-level exam" in `row'
local ++row
replace labels = "Distance to Nanjing" in `row'
local ++row
replace labels = "Along the route of Taipings during 1950-53" in `row'
local ++row

* Input values into the subtable
foreach var in N1 m1 sd1 {
	qui{
		local row = 1
		if "`var'"=="N1" {
			local decimal = "0fc"
		}
		else{
			local decimal = "2f"
		}
		
		g `var' = ""
		replace `var' = string(``var'_martyr', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_martyrs_tot_hn', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_Zeng_all0_invdist', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_Zeng_all0_invdist_pc', "%12.`decimal'") in `row'
		local ++row
		local ++row
		replace `var' = string(``var'_lnarea', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnpop', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnrice', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnwheat', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_mainriv', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_dist2canal', "%12.`decimal'") in `row'
		local ++row
		
		replace `var' = string(``var'_lnurbanpop', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_capital', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnjinshi', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnquotas', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_dist_nanjing', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_route1', "%12.`decimal'") in `row'
		local ++row
	}
}

keep labels N1 m1 sd1
drop if labels == ""
save "$tabdir\Table1_part.dta", replace


********************************************************************************
**# Panel B: 
use "$dtadir\NationalCntyYr.dta",clear

keep if year >= 1820 & year <= 1910

* Construct a subtable
local outlist = "martyrs_tot_post Zeng_all0_invdist Zeng_all0_invdist_pc alloff lncntyarea lncntypop lnrice lnwheat mainriv dist2canal lnurbanpop prefcap lnjinshi lncntyquota0 dist_nanjing Taiping_route1"

foreach var in `outlist' {
	qui{
		sum `var'
		local N2_`var' = `r(N)'
		local m2_`var' = `r(mean)'
		local sd2_`var' = `r(sd)'
	}
}
	
g labels = ""
local row = 1

* Customize row names
replace labels = "Number of soldier deaths by year" in `row'
local ++row
replace labels = "Number of soldier deaths during 1854-64 (1K)" in `row'
local ++row
replace labels = "Elite connections, baseline networks (weighted)" in `row'
local ++row
replace labels = "Elite connections per capita, baseline networks (weighted)" in `row'
local ++row
replace labels = "Number of national-level offices" in `row'
local ++row
replace labels = "ln area" in `row'
local ++row
replace labels = "ln population" in `row'
local ++row
replace labels = "ln rice suitability" in `row'
local ++row
replace labels = "ln wheat suitability" in `row'
local ++row
replace labels = "Main river dummy" in `row'
local ++row
replace labels = "Distance to the Grand Cannal" in `row'
local ++row
replace labels = "ln urban population" in `row'
local ++row
replace labels = "Prefecture capital" in `row'
local ++row
replace labels = "ln number of Jinshi" in `row'
local ++row
replace labels = "ln quotas for the entry-level exam" in `row'
local ++row
replace labels = "Distance to Nanjing" in `row'
local ++row
replace labels = "Along the route of Taipings during 1950-53" in `row'
local ++row

* Input values in a table
foreach var in N2 m2 sd2 {
	qui{
		local row = 1
		if "`var'"=="N2" {
			local decimal = "0fc"
		}
		else{
			local decimal = "2f"
		}
		
		g `var' = ""
		local ++row
		replace `var' = string(``var'_martyrs_tot_post', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_Zeng_all0_invdist', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_Zeng_all0_invdist_pc', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_alloff', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lncntyarea', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lncntypop', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnrice', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnwheat', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_mainriv', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_dist2canal', "%12.`decimal'") in `row'
		local ++row
		
		replace `var' = string(``var'_lnurbanpop', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_prefcap', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lnjinshi', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_lncntyquota0', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_dist_nanjing', "%12.`decimal'") in `row'
		local ++row
		replace `var' = string(``var'_Taiping_route1', "%12.`decimal'") in `row'
		local ++row
	}
}

keep labels N2 m2 sd2
drop if labels == ""


********************************************************************************
**# Combining Two Panels
merge 1:1 labels using "$tabdir\Table1_part.dta"
drop _merge

* Re-order
order labels N1 m1 sd1 N2 m2 sd2

gen ordernum = 1 if labels == "Number of soldier deaths by year"
replace ordernum = 2 if labels == "Number of soldier deaths during 1854-64 (1K)"
replace ordernum = 3 if labels == "Elite connections, baseline networks (weighted)"
replace ordernum = 4 if labels == "Elite connections per capita, baseline networks (weighted)"
replace ordernum = 5 if labels == "Number of national-level offices"
replace ordernum = 6 if labels == "ln area"
replace ordernum = 7 if labels == "ln population"
replace ordernum = 8 if labels == "ln rice suitability"
replace ordernum = 9 if labels == "ln wheat suitability"
replace ordernum = 10 if labels == "Main river dummy"
replace ordernum = 11 if labels == "Distance to the Grand Cannal"
replace ordernum = 12 if labels == "ln urban population"
replace ordernum = 13 if labels == "Prefecture capital"
replace ordernum = 14 if labels == "ln number of Jinshi"
replace ordernum = 15 if labels == "ln quotas for the entry-level exam"
replace ordernum = 16 if labels == "Distance to Nanjing"
replace ordernum = 17 if labels == "Along the route of Taipings during 1950-53"

sort ordernum
drop ordernum

* Construct a LaTeX tabular
g tab = "\adjustbox{max width=\textwidth}{\begin{tabular}{l*{6}{c}}" in 1
g panel = "Sample & \multicolumn{3}{c}{Hunan counties 1850-1864} & \multicolumn{3}{c}{All counties, 1820-1910}" in 1
g titlerow = "& Obs. & Mean & Std. dev. & Obs. & Mean & Std. dev." in 1
g hline = "\hline" in 1
g cline = "\cmidrule(lr){2-4}\cmidrule(lr){5-7}"
g end = "\end{tabular}}" in 1

listtex tab if _n == 1 using "$tabdir/Table1_Summary_Statistics.tex", replace
listtex hline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex hline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex panel if _n==1, appendto("$tabdir/Table1_Summary_Statistics.tex") rstyle(tabular)
listtex cline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex titlerow if _n==1, appendto("$tabdir/Table1_Summary_Statistics.tex") rstyle(tabular)
listtex hline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex labels N1 m1 sd1 N2 m2 sd2 if _n<=17, appendto("$tabdir/Table1_Summary_Statistics.tex") rstyle(tabular)
listtex hline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex hline if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")
listtex end if _n == 1, appendto("$tabdir/Table1_Summary_Statistics.tex")



/*
********************************************************************************
*** Using "outreg2" ************************************************************
********************************************************************************

**# Panel A: Hunan counties, 1850-1864
use "$dtadir\HunanCntyYr.dta",clear

* Edit unit, names, and labels
replace martyrs_tot_hn = martyrs_tot_hn/10^3

rename martyrs_tot_hn martyrs_tot

label var martyr "Number of soldier deaths by year"
label var martyrs_tot "Number of soldier deaths during 1854-64 (1K)"
label var Zeng_all0_invdist "Elite connections, baseline networks (weighted)"
label var Zeng_all0_invdist_pc "Elite connections per capita, baseline networks (weighted)"
label var lnarea "ln area"
label var lnpop "ln population"
label var lnrice "ln rice suitability"
label var lnwheat "ln wheat suitability"
label var mainriv "Main river dummy"
label var lnurbanpop "ln urban population"
label var capital "Prefecture capital"
label var lnjinshi "ln number of Jinshi"
label var lnquotas "ln quotas for the entry-level exam"
label var route1 "Along the route of Taipings during 1950-53"

* Export a table
outreg2 using "$tabdir\Table1.tex", ///
	keep(martyr martyrs_tot Zeng_all0_invdist Zeng_all0_invdist_pc lnarea lnpop lnrice lnwheat mainriv dist2canal lnurbanpop capital lnjinshi lnquotas dist_nanjing route1) ///
	sortvar(martyr martyrs_tot_hn Zeng_all0_invdist Zeng_all0_invdist_pc lnarea lnpop lnrice lnwheat mainriv dist2canal lnurbanpop capital lnjinshi lnquotas dist_nanjing route1) ///
	sum(log) eqkeep(N mean sd) cttop(Hunan counties 1850-1864) ///
	label dec(2) tex replace


********************************************************************************
**# PanelB: All counties
use "$dtadir\NationalCntyYr.dta",clear

keep if year >= 1820 & year <= 1910

* Edit names and labels
rename martyrs_tot_post martyrs_tot
rename lncntyarea lnarea
rename lncntypop lnpop
rename prefcap capital
rename lncntyquota0 lnquotas
rename Taiping_route1 route1

label var martyrs_tot "Number of soldier deaths during 1854-64 (1K)"
label var Zeng_all0_invdist "Elite connections, baseline networks (weighted)"
label var Zeng_all0_invdist_pc "Elite connections per capita, baseline networks (weighted)"
label var lnarea "ln area"
label var lnpop "ln population"
label var lnrice "ln rice suitability"
label var lnwheat "ln wheat suitability"
label var mainriv "Main river dummy"
label var lnurbanpop "ln urban population"
label var capital "Prefecture capital"
label var lnjinshi "ln number of Jinshi"
label var lnquotas "ln quotas for the entry-level exam"
label var route1 "Along the route of Taipings during 1950-53"

* Export a table
outreg2 using "$tabdir\Table1_Summary_Statistics.tex", ///
	keep(martyrs_tot Zeng_all0_invdist Zeng_all0_invdist_pc alloff lnarea lnpop lnrice lnwheat mainriv dist2canal lnurbanpop capital lnjinshi lnquotas dist_nanjing route1) ///
	groupvar(martyr martyrs_tot Zeng_all0_invdist Zeng_all0_invdist_pc alloff lnarea lnpop lnrice lnwheat mainriv dist2canal lnurbanpop capital lnjinshi lnquotas dist_nanjing route1) ///
	sum(log) eqkeep(N mean sd) cttop(All counties 1820-1910) ///
	label dec(2) tex append
*/
