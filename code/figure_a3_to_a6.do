////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
// FIGURES A3 - A6: HISTOGRAM OF COAL, NG, WIND, and, SOLAR
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

// Clear memory
clear all

// Set local macro for each type of pollutant
local plant_type_list coal ng wind solar 

// Start local macro to label figures 
local fig_numb = 3

// Loop over each of these energy types
foreach plant_type in `plant_type_list' {

	// Use the plant level dataset
	use "$data_path/PLANT_DATASET.dta", clear

	// Drop years outside our sample
	drop if year<1993
	drop if year>2013

	// Set plant ID
	egen id=group(StateFIPS plantid)
	drop if missing(id)
	xtset id year

	// Set energy type
	if "`plant_type'"=="coal" {
		local y plant_coal_mwh 
		local lbl "Coal"
	}
	
	if "`plant_type'"=="ng" {
		local y plant_ng_twh 
		replace plant_ng_twh = plant_ng_twh*1000000
		local lbl "Natural Gas"
	}

	if "`plant_type'"=="wind" {
		local y plant_wind_twh 
		replace plant_wind_twh = plant_wind_twh*1000000
		local lbl "Wind"
	}

	if "`plant_type'"=="solar" {
		local y plant_solar_twh 
		replace plant_solar_twh = plant_solar_twh*1000000
		local lbl "Solar"
	}

	// Keep only the correct type of plant
	bysort id: egen ever_`plant_type' = max(`y')
	keep if ever_`plant_type' > 0

	// Create a log(x + 1) version of the variable)
	drop if `y' < 0
	gen ln_y = ln(`y'+ 1) 

	// Create untransformed histogram
	hist `y' , ///
		xlabel(,nogrid notick) ///
		ylabel(,nogrid notick) ///
		xtitle("`lbl' Plant Generation (MWh)") ///
		ytitle("") ///
		subtitle("Density", pos(11) size(3))

	graph export "$results_path/`fig_numb'a_`plant_type'_histogram.pdf", replace

	// Create histogram of ln(x+1)
	hist ln_y , ///
		xlabel(,nogrid notick) ///
		ylabel(,nogrid notick) ///
		xtitle("Natural Log of `lbl' Plant Generation (MWh)") ///
		ytitle("") ///
		subtitle("Density", pos(11) size(3))
		
	graph export "$results_path/`fig_numb'b_ln_`plant_type'_histogram.pdf", replace

	// Update local macro to label figures 
	local fig_numb = `fig_numb' + 1
}
	