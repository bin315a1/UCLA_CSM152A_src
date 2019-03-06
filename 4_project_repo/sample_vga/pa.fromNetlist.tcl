
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name sample_vga -dir "C:/Users/152/Desktop/lab6_group11/UCLA_CSM152A_src/4_project_repo/sample_vga/planAhead_run_2" -part xc6slx45tfgg484-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/152/Desktop/lab6_group11/UCLA_CSM152A_src/4_project_repo/sample_vga/NERP_demo_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/152/Desktop/lab6_group11/UCLA_CSM152A_src/4_project_repo/sample_vga} }
set_property target_constrs_file "Nexys3.ucf" [current_fileset -constrset]
add_files [list {Nexys3.ucf}] -fileset [get_property constrset [current_run]]
link_design
