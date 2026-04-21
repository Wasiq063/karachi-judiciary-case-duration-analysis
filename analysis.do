/* Quantitative Research Methods - T3
Final Project - Spring 2026
22nd April, 2026
Shazmah Jilani, Wasiq Shaikh

Step 1. DATA CLEANING

Label the caseyear variable to make the dataset easier to read */
use Karachi_data_QRM.dta

label variable caseyear "Year the case was filed"

// Convert string date variables into Stata date format using DMY format
// 2050 is the cutoff for 2-digit years to ensure dates are interpreted correctly
gen inst_date = date(institutiondate, "DMY", 2050)
gen disp_date = date(disposaldate, "DMY", 2050)

// Apply the standard date format so the numbers look like readable dates (e.g., 01jan2020)
format inst_date disp_date %td

// Calculate the duration of each case in days by finding the difference between dates
gen dur_days = disp_date - inst_date

// Convert days to months using a standard average of 30.44 days per month for precision
gen dur_months = dur_days / 30.44
label variable dur_months "Duration of case in months"

// Create a dummy variable for Plaintiff Type: 0 for Individuals, 1 for Institutional entities
gen plaint_party = .
replace plaint_party = 0 if plaintif_type == "Individual"
replace plaint_party = 1 if (plaintif_type == "Corporate" | plaintif_type == "Government Entities" | plaintif_type == "State")

// Create a dummy variable for Defendant Type: 0 for Individuals, 1 for Institutional entities
 
gen def_party = .
replace def_party = 0 if trim(lower(defendant_type)) == "individual"
replace def_party = 1 if defendant_type == "Corporate" | defendant_type == "Government Entities" | defendant_type == "State"

// Define and apply value labels to make output tables easily interpretable
label define plaint_type1 0 "individual" 1 "gov/corp"
label values plaint_party plaint_type1
label values def_party plaint_type1

// Apply descriptive labels to the variables
label variable inst_date "Date of institution (formatted)"
label variable disp_date "Date of disposal (formatted)"
label variable dur_days "Duration of case in days"
label variable plaint_party "Plaintiff type: individual vs corp/govt"
label variable def_party "Defendant type: individual vs corp/govt"

// Categorize the specific case names into broader categories: Family, Criminal, or Civil
gen case_category = ""
replace case_category = "Family" if inlist(case_name, "Divorce P.", "Family Appeal", "S.M.A")
replace case_category = "Criminal" if strpos(case_name, "Cr.") == 1 | strpos(case_name, "Spl. Cr.") == 1 | ///
    strpos(case_name, "Spl.Cr.") == 1 | strpos(case_name, "Spl.Anti.") == 1 | ///
    strpos(case_name, "Spl. Cus.") == 1 | strpos(case_name, "Spl.Cus.") == 1 | ///
    inlist(case_name, "CR.INT MISC APPLNS (C.M.A)", "Conf. Case", "Conf. Case (A.T.A)")
replace case_category = "Civil" if case_category == ""

// Create a 4-category variable to analyze specific Litigant Combinations
gen case_type_combo = . 
replace case_type_combo = 1 if plaint_party == 0 & def_party == 0 
replace case_type_combo = 2 if plaint_party == 0 & def_party == 1 
replace case_type_combo = 3 if plaint_party == 1 & def_party == 0 
replace case_type_combo = 4 if plaint_party == 1 & def_party == 1 

label define combo_lbl 1 "Ind vs Ind" 2 "Ind vs Corp/Govt" 3 "Corp/Govt vs Ind" 4 "Corp/Govt vs Corp/Govt" 
label values case_type_combo combo_lbl
label variable case_type_combo "Litigant combination (plaintiff vs defendant)"

// Commands for Graphs
// Mean comparison (defendant)
graph bar (mean) dur_months, over(def_party) asyvars bar(1, color(navy)) bar(2, color(maroon)) title("Mean Duration by Defendant Type") ytitle("Months")

// Mean comparison (plaintiff)
graph bar (mean) dur_months, over(plaint_party) asyvars bar(1, color(navy)) bar(2, color(maroon)) title("Mean Duration by Plaintiff Type") ytitle("Months")

// general boxplot
graph box dur_months, over(case_type_combo, label(angle(30))) asyvars box(1, color(navy)) box(2, color(maroon)) box(3, color(forest_green)) box(4, color(orange)) medtype(cline) medline(lcolor(black)) title("Case Duration by Litigant Combination") ytitle("Duration (Months)") note("Format: Plaintiff vs Defendant")


// Commands used for hypothesis testing
// Two-sample t-test (robust to unequal variance)

	// Summary statistics for manual interpretation
	tabstat dur_months, by(def_party) stat(mean sd n)
	tabstat dur_months, by(plaint_party) stat(mean sd n)

	
	// Test 1: Based on defendant type
	ttest dur_months, by(def_party) unequal

	// Test 2: Based on plaintiff type
	ttest dur_months, by(plaint_party) unequal