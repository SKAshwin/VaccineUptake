frame reset
macro drop _all
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global tables_dir "/home/elven/Documents/College/metrics_project/raw_tables"
global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
global reg_dataset_31Dec "cross_section_31Dec"
global reg_dataset_1Jun "cross_section_1Jun"

cd "$reg_ready_dir"
use "$reg_dataset_31Dec"
gen dec31 = 1
append using "$reg_dataset_1Jun"
replace dec31 = 0 if dec31 == .

eststo fullvax_31Dec: quietly reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 fullcollege cases_per_capita i.rural_rating i.statecode if dec31 == 1, r beta
testparm i.rural_rating
eststo dose1_31Dec: quietly reg dose1pct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 fullcollege cases_per_capita i.rural_rating  i.statecode if dec31 == 1, r beta 
testparm i.rural_rating
eststo fullvax_1Jun: quietly reg fullvaxpct repvotes2020pct whiteevangelical catholic black poverty lmedincome lcol pop60to79 above80 fullcollege cases_per_capita i.rural_rating  i.statecode if dec31 == 0, r beta 
testparm i.rural_rating

esttab, beta
esttab fullvax_31Dec fullvax_31Dec dose1_31Dec fullvax_1Jun fullvax_1Jun, ///
cells("b(pattern(1 0 1 1 0) fmt(2) star) beta(pattern(0 1 0 0 1) fmt(2))" se(pattern(1 0 1 1 0) fmt(2) par)) drop(*.statecode) mlabels("Two Doses, 31 December" "Standardized" "One Dose, 31 December" "Two Doses, 1 June" "Standardized")

cd "$tables_dir"
esttab fullvax_31Dec fullvax_31Dec dose1_31Dec fullvax_1Jun fullvax_1Jun using cross_section.tex, ///
cells("b(pattern(1 0 1 1 0) fmt(2) star) beta(pattern(0 1 0 0 1) fmt(2))" se(pattern(1 0 1 1 0) fmt(2) par)) drop(*.statecode) replace mlabels("Two Doses, 31 December" "Standardized" "One Dose, 31 December" "Two Doses, 1 June" "Standardized")
