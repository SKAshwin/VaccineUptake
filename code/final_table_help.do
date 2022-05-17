frame reset
macro drop _all
eststo clear
global est_dir "/home/elven/Documents/College/metrics_project/estimates"
global tables_dir "/home/elven/Documents/College/metrics_project/raw_tables"
*global reg_ready_dir "/home/elven/Documents/College/metrics_project/data/regression_ready"
*global reg_dataset_31Dec "cross_section_31Dec"
*global reg_dataset_1Jun "cross_section_1Jun"

* The White Tests
cd "$est_dir"
eststo dose1_1jun: est use cross_section_dose1_short_1Jun_white.ster
est
eststo fullvax_1jun: est use cross_section_fullvax_short_1Jun_white.ster
est
eststo dose1_31dec: est use cross_section_dose1_short_31Dec_white.ster
est
eststo fullvax_31dec: est use cross_section_fullvax_short_31Dec_white.ster
est

esttab fullvax_31dec dose1_31dec fullvax_1jun, se scalar(F)

* The Rural significance
cd "$est_dir"
est use cross_section_dose1_short_1Jun.ster
test 2.rural_rating 3.rural_rating 4.rural_rating 5.rural_rating 6.rural_rating /// 
7.rural_rating 8.rural_rating 9.rural_rating
est use cross_section_fullvax_short_1Jun.ster
test 2.rural_rating 3.rural_rating 4.rural_rating 5.rural_rating 6.rural_rating /// 
7.rural_rating 8.rural_rating 9.rural_rating
est use cross_section_dose1_short_31Dec.ster
test 2.rural_rating 3.rural_rating 4.rural_rating 5.rural_rating 6.rural_rating /// 
7.rural_rating 8.rural_rating 9.rural_rating
est use cross_section_fullvax_short_31Dec.ster
test 2.rural_rating 3.rural_rating 4.rural_rating 5.rural_rating 6.rural_rating /// 
7.rural_rating 8.rural_rating 9.rural_rating

* The Wald Stat for income variables
cd "$est_dir"
est use cross_section_dose1_short_1Jun.ster
test poverty lmedincome lcol 
est use cross_section_fullvax_short_1Jun.ster
test poverty lmedincome lcol 
est use cross_section_dose1_short_31Dec.ster
test poverty lmedincome lcol 
est use cross_section_fullvax_short_31Dec.ster
test poverty lmedincome lcol 
