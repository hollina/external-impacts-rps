////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
// FIGURE 4: Map of potential and actual REC trade sales for six states in 2012
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

// Clear memory
clear 

// Open sales eligibility data that is adapted from  Holt (2014), DSIRE, and, State Legislative Documents 
use "$data_path/rec_sales_eligibility.dta"

// Keep 2011
keep if year==2011

// Drop year
drop year

// Transpose dataset
xpose, clear varname
keep _varname
drop if _varname=="StateFIPS"
drop if _varname=="state"
drop if missing(_varname)
tempfile temp1    /* create a temporary file */
save "`temp1'"      /* save memory into the temporary file */

// Repeat the procedure but then merge in the above data
clear all
use "$data_path/rec_sales_eligibility.dta"
keep if year==2011
drop year
sxpose, clear firstnames force destring

merge 1:1 _n using "`temp1'" 
split _varname, p("_")
rename _varname2 state_buying
replace state_buying=upper(state_buying)
drop _*
rename * pos_to_buy_from_*
rename pos_to_buy_from_state_buying state_buying
order state_buying
drop if missing(state_buying)

tempfile temp2   /* create a temporary file */
save "`temp2'"      /* save memory into the temporary file */

// Now edit and merge in actual sales from NREL released in 2012
clear all
import excel "$data_path/actual_and_potential_rec_sales_2012.xlsx", sheet("Sheet1") firstrow
drop DC DD 
gen year=2011
keep State *percentage*
rename State state_buying

// Merge in the potential buyers
merge 1:1 state_buying using "`temp2'"

// Reshape the data 
reshape long  pos_to_buy_from_@ @_percentage, i(state_buying) j(state_selling) string
rename _* *
rename *_ *

// Rename the variables so they make sense
rename percentage percentage_bought
rename pos_to_buy possible_to_buy
replace percentage_bought=0 if missing(percentage_bought)
replace possible_to_buy=0 if missing(possible_to_buy)

replace possible_to_buy=1 if state_selling==state_buying
drop if state_selling=="UK" ///
	|	state_selling=="QC" ///
	|	state_selling=="PE" ///
	|	state_selling=="MB" ///
	|	state_selling=="BC" 

sort state_buying state_selling


// Add State FIPS codes
gen StateFIPS_buying=.					
replace StateFIPS_buying=	15	if 	state_buying=="HI"
replace StateFIPS_buying=	1	if 	state_buying=="AL"
replace StateFIPS_buying=	2	if 	state_buying=="AK"
replace StateFIPS_buying=	4	if 	state_buying=="AZ"
replace StateFIPS_buying=	5	if 	state_buying=="AR"
replace StateFIPS_buying=	6	if 	state_buying=="CA"
replace StateFIPS_buying=	8	if 	state_buying=="CO"
replace StateFIPS_buying=	9	if 	state_buying=="CT"
replace StateFIPS_buying=	10	if 	state_buying=="DE"
replace StateFIPS_buying=	11	if 	state_buying=="DC"
replace StateFIPS_buying=	12	if 	state_buying=="FL"
replace StateFIPS_buying=	13	if 	state_buying=="GA"
replace StateFIPS_buying=	16	if 	state_buying=="ID"
replace StateFIPS_buying=	17	if 	state_buying=="IL"
replace StateFIPS_buying=	18	if 	state_buying=="IN"
replace StateFIPS_buying=	19	if 	state_buying=="IA"
replace StateFIPS_buying=	20	if 	state_buying=="KS"
replace StateFIPS_buying=	21	if 	state_buying=="KY"
replace StateFIPS_buying=	22	if 	state_buying=="LA"
replace StateFIPS_buying=	23	if 	state_buying=="ME"
replace StateFIPS_buying=	24	if 	state_buying=="MD"
replace StateFIPS_buying=	25	if 	state_buying=="MA"
replace StateFIPS_buying=	26	if 	state_buying=="MI"
replace StateFIPS_buying=	27	if 	state_buying=="MN"
replace StateFIPS_buying=	28	if 	state_buying=="MS"
replace StateFIPS_buying=	29	if 	state_buying=="MO"
replace StateFIPS_buying=	30	if 	state_buying=="MT"
replace StateFIPS_buying=	31	if 	state_buying=="NE"
replace StateFIPS_buying=	32	if 	state_buying=="NV"
replace StateFIPS_buying=	33	if 	state_buying=="NH"
replace StateFIPS_buying=	34	if 	state_buying=="NJ"
replace StateFIPS_buying=	35	if 	state_buying=="NM"
replace StateFIPS_buying=	36	if 	state_buying=="NY"
replace StateFIPS_buying=	37	if 	state_buying=="NC"
replace StateFIPS_buying=	38	if 	state_buying=="ND"
replace StateFIPS_buying=	39	if 	state_buying=="OH"
replace StateFIPS_buying=	40	if 	state_buying=="OK"
replace StateFIPS_buying=	41	if 	state_buying=="OR"
replace StateFIPS_buying=	42	if 	state_buying=="PA"
replace StateFIPS_buying=	44	if 	state_buying=="RI"
replace StateFIPS_buying=	45	if 	state_buying=="SC"
replace StateFIPS_buying=	46	if 	state_buying=="SD"
replace StateFIPS_buying=	47	if 	state_buying=="TN"
replace StateFIPS_buying=	48	if 	state_buying=="TX"
replace StateFIPS_buying=	49	if 	state_buying=="UT"
replace StateFIPS_buying=	50	if 	state_buying=="VT"
replace StateFIPS_buying=	51	if 	state_buying=="VA"
replace StateFIPS_buying=	53	if 	state_buying=="WA"
replace StateFIPS_buying=	54	if 	state_buying=="WV"
replace StateFIPS_buying=	55	if 	state_buying=="WI"
replace StateFIPS_buying=	56	if 	state_buying=="WY"

gen StateFIPS_selling=.					
replace StateFIPS_selling=	15	if 	state_selling=="HI"
replace StateFIPS_selling=	1	if 	state_selling=="AL"
replace StateFIPS_selling=	2	if 	state_selling=="AK"
replace StateFIPS_selling=	4	if 	state_selling=="AZ"
replace StateFIPS_selling=	5	if 	state_selling=="AR"
replace StateFIPS_selling=	6	if 	state_selling=="CA"
replace StateFIPS_selling=	8	if 	state_selling=="CO"
replace StateFIPS_selling=	9	if 	state_selling=="CT"
replace StateFIPS_selling=	10	if 	state_selling=="DE"
replace StateFIPS_selling=	11	if 	state_selling=="DC"
replace StateFIPS_selling=	12	if 	state_selling=="FL"
replace StateFIPS_selling=	13	if 	state_selling=="GA"
replace StateFIPS_selling=	16	if 	state_selling=="ID"
replace StateFIPS_selling=	17	if 	state_selling=="IL"
replace StateFIPS_selling=	18	if 	state_selling=="IN"
replace StateFIPS_selling=	19	if 	state_selling=="IA"
replace StateFIPS_selling=	20	if 	state_selling=="KS"
replace StateFIPS_selling=	21	if 	state_selling=="KY"
replace StateFIPS_selling=	22	if 	state_selling=="LA"
replace StateFIPS_selling=	23	if 	state_selling=="ME"
replace StateFIPS_selling=	24	if 	state_selling=="MD"
replace StateFIPS_selling=	25	if 	state_selling=="MA"
replace StateFIPS_selling=	26	if 	state_selling=="MI"
replace StateFIPS_selling=	27	if 	state_selling=="MN"
replace StateFIPS_selling=	28	if 	state_selling=="MS"
replace StateFIPS_selling=	29	if 	state_selling=="MO"
replace StateFIPS_selling=	30	if 	state_selling=="MT"
replace StateFIPS_selling=	31	if 	state_selling=="NE"
replace StateFIPS_selling=	32	if 	state_selling=="NV"
replace StateFIPS_selling=	33	if 	state_selling=="NH"
replace StateFIPS_selling=	34	if 	state_selling=="NJ"
replace StateFIPS_selling=	35	if 	state_selling=="NM"
replace StateFIPS_selling=	36	if 	state_selling=="NY"
replace StateFIPS_selling=	37	if 	state_selling=="NC"
replace StateFIPS_selling=	38	if 	state_selling=="ND"
replace StateFIPS_selling=	39	if 	state_selling=="OH"
replace StateFIPS_selling=	40	if 	state_selling=="OK"
replace StateFIPS_selling=	41	if 	state_selling=="OR"
replace StateFIPS_selling=	42	if 	state_selling=="PA"
replace StateFIPS_selling=	44	if 	state_selling=="RI"
replace StateFIPS_selling=	45	if 	state_selling=="SC"
replace StateFIPS_selling=	46	if 	state_selling=="SD"
replace StateFIPS_selling=	47	if 	state_selling=="TN"
replace StateFIPS_selling=	48	if 	state_selling=="TX"
replace StateFIPS_selling=	49	if 	state_selling=="UT"
replace StateFIPS_selling=	50	if 	state_selling=="VT"
replace StateFIPS_selling=	51	if 	state_selling=="VA"
replace StateFIPS_selling=	53	if 	state_selling=="WA"
replace StateFIPS_selling=	54	if 	state_selling=="WV"
replace StateFIPS_selling=	55	if 	state_selling=="WI"
replace StateFIPS_selling=	56	if 	state_selling=="WY"

// Drop states that "sell" to themselves
drop if StateFIPS_selling==StateFIPS_buying

// Calculate percent
bysort state_buying: egen total_percent = sum(percentage_bought)
drop if total_percent==0
tab total_percent
sum percentage_bought if percentage_bought>0, detail

// Turn State selling to a string, and rename to merge with map file that is created by NHGIS
tostring StateFIPS_selling, gen(STATEFPa)
gen STATEFP10 = string(real(STATEFPa),"%02.0f")

tempfile temp1    /* create a temporary file */
save "`temp1'"

// Convert the shape file for the lower 48
clear
shp2dta using "$data_path/base_maps/us_48_states_2010_wgs_84", database("$temp_path/us_48_data") coordinates("$temp_path/us_48_corr") genid(id) replace


// Loop over each state that we want a legend for
local state_list_with_legend MD

foreach l in `state_list_with_legend' {

	// Use the temp data
	use  "`temp1'", clear

	// Keep only the buying state
	keep if state_buying=="`l'"

	// Save a dta
	save "$temp_path/`l'_map.dta", replace

	// Open map data
	use "$temp_path/us_48_data", clear

	// Merge in buying state
	merge 1:1 STATEFP  using "$temp_path/`l'_map.dta"

	// Move the number to a massive one if missing
	replace percentage_bought=10 if missing(percentage_bought)

	// Drop states who cannot buy (they will become missing in the map)
	drop if possible_to_buy==0

	// Create a map
	spmap percentage_bought using "$temp_path/us_48_corr.dta", id(id) ///
		clmethod(custom) clbreaks(-1 0 .01 .1  1.1 10) clnumber(5) ///
		fcolor("255 255 255"  "189 215 231" "107 174 214" "33 113 181" "179 0 0") ///
		legend( label(2 "Did Not Buy RECs From") label(3 "Bought <1%") ///
		label(4 "Bought between 1%-10%") label(5 "Bought More Than 10%") ///
		label(6 "REC Purchasing State") size(*3.75))

		graph export "$results_path/figure_4_`l'_map_with_legend.pdf", replace

}

// Loop over each state that we do not want a legend for
local state_list_no_legend IL CO RI OR ME

foreach l in `state_list_no_legend' {

	// Use the temp data
	use  "`temp1'", clear

	// Keep only the buying state
	keep if state_buying=="`l'"

	// Save a dta
	save "$temp_path/`l'_map.dta", replace

	// Open map data
	use "$temp_path/us_48_data", clear

	// Merge in buying state
	merge 1:1 STATEFP  using "$temp_path/`l'_map.dta"

	// Move the number to a massive one if missing
	replace percentage_bought=10 if missing(percentage_bought)

	// Drop states who cannot buy (they will become missing in the map)
	drop if possible_to_buy==0

	// Create map
	spmap percentage_bought using "$temp_path/us_48_corr.dta", id(id) ///
		clmethod(custom) clbreaks(-1 0 .01 .1  1.1 10) clnumber(5) ///
		fcolor("255 255 255"  "189 215 231" "107 174 214" "33 113 181" "179 0 0") ///
		legend(off)
	graph export "$results_path/figure_4_`l'_map_no_legend.pdf", replace

}
