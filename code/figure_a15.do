		
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
// FIGURE A15: COUNTY DAMAGES FROM 1% RPS INCREASE BY STATE
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//This file will create a marginal damages estimate for actual  SO2, NOX, PM 2.5, PM 10, VOC, and NH3
	//for each US County on every other US County
	//Based off of Nick Mueller
	
	clear all
//Set Maximum Number of Variables
	set maxvar 32767 
//Change Working Directory	
	clear all
	cd "$root_path/apeep/Damage_Matrices"
//Get FIPS Ready
	insheet using "$root_path/apeep/Damage_Matrices/fips.csv"
	rename v1 fips

//pull state fips and county fips from this combined one
	tostring fips, replace format(%05.0f)

	gen StateFIPS=substr(fips,1,2)
	gen CountyFIPS=substr(fips,3,3)

	drop fips

	destring StateFIPS, replace
	destring CountyFIPS, replace

	gen order=_n
	save "$temp_path/temp_all_fips.dta", replace

//NOx Damages
	clear all
	cd "$root_path/apeep/Damage_Matrices"

	//Import Marginal Damages Transport Matrix

		insheet using "$root_path/apeep/Damage_Matrices/nox_md_m_trans.csv"
		gen order=_n
	
		merge 1:1 order using "$temp_path/temp_all_fips.dta"


	//Rename Variables Appropriatley 
		*Use the formate state_#_county_#, where the # is the FIPS code
		*This assumes that the variables in the matrix are in the same order as the fips vector we imported
			ds v*

			local i=1

			foreach variable in `r(varlist)' {

				rename `variable' nox_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
				local i = `i' + 1

			}


			drop _merge
			save "$temp_path/temp_all.dta", replace


//SO2 Damages
	cd "$root_path/apeep/Damage_Matrices"

	insheet using "$root_path/apeep/Damage_Matrices/so2_md_m_trans.csv", clear
	gen order=_n

	merge 1:1 order using "$temp_path/temp_all_fips.dta"

	//Rename Variables Appropriatley 
		*Use the formate state_#_county_#, where the # is the FIPS code


		ds v*

		local i=1
	
		foreach variable in `r(varlist)' {

			rename `variable' so2_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
			local i = `i' + 1

		}
		drop _merge
		merge 1:1 StateFIPS CountyFIPS using "$temp_path/temp_all.dta"
		drop _merge
		save "$temp_path/temp_all.dta", replace
	
//PM 2.5 Damages
		cd "$root_path/apeep/Damage_Matrices"

		insheet using "$root_path/apeep/Damage_Matrices/pm25_md_m_trans.csv", clear
		gen order=_n

		merge 1:1 order using "$temp_path/temp_all_fips.dta"

	//Rename Variables Appropriatley 
	*Use the formate state_#_county_#, where the # is the FIPS code


		ds v*

		local i=1

		foreach variable in `r(varlist)' {

			rename `variable' pm_25_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
			local i = `i' + 1

		}
		drop _merge
		merge 1:1 StateFIPS CountyFIPS using "$temp_path/temp_all.dta"
		drop _merge
		save "$temp_path/temp_all.dta", replace

//PM 10 Damages
	cd "$root_path/apeep/Damage_Matrices"

	insheet using "$root_path/apeep/Damage_Matrices/pm10_md_m_trans.csv", clear
	gen order=_n

	merge 1:1 order using "$temp_path/temp_all_fips.dta"

	//Rename Variables Appropriatley 
	*Use the formate state_#_county_#, where the # is the FIPS code


		ds v*

		local i=1

		foreach variable in `r(varlist)' {

			rename `variable' pm_10_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
			local i = `i' + 1

		}
		drop _merge
		merge 1:1 StateFIPS CountyFIPS using "$temp_path/temp_all.dta"
		drop _merge
		save "$temp_path/temp_all.dta", replace

//VOC Damages
	cd "$root_path/apeep/Damage_Matrices"

	insheet using "$root_path/apeep/Damage_Matrices/voc_md_m_trans.csv", clear
	gen order=_n

	merge 1:1 order using "$temp_path/temp_all_fips.dta"

	//Rename Variables Appropriatley 
	*Use the formate state_#_county_#, where the # is the FIPS code


		ds v*

		local i=1

		foreach variable in `r(varlist)' {

			rename `variable' voc_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
			local i = `i' + 1

		}
		drop _merge
		merge 1:1 StateFIPS CountyFIPS using "$temp_path/temp_all.dta"
		drop _merge
		save "$temp_path/temp_all.dta", replace

//Ammonia Damages
	cd "$root_path/apeep/Damage_Matrices"

	insheet using "$root_path/apeep/Damage_Matrices/nh3_md_m_trans.csv", clear
	gen order=_n

	merge 1:1 order using "$temp_path/temp_all_fips.dta"

	//Rename Variables Appropriatley 
	*Use the formate state_#_county_#, where the # is the FIPS code


		ds v*

		local i=1

		foreach variable in `r(varlist)' {

			rename `variable' nh3_s_`=StateFIPS[`i']'_c_`=CountyFIPS[`i']'
	
			local i = `i' + 1

		}
		drop _merge
		merge 1:1 StateFIPS CountyFIPS using "$temp_path/temp_all.dta"
		drop _merge
		save "$temp_path/temp_all.dta", replace

//Combine with emissions as a result of Actual and Marginal RPS increases
	order StateFIPS CountyFIPS 
	sort StateFIPS CountyFIPS 

	merge 1:1 StateFIPS CountyFIPS using  "$data_path/rps_induced_emission_changes_2011_to_2012.dta"
	
	keep if _merge==3
	drop _merge

//Save Intermediate Point 
	save "$temp_path/temp_states.dta", replace
	use  "$temp_path/temp_states.dta", clear