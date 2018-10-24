source -echo -verbose ./scripts_block/rm_setup/dc_setup.tcl

#################################################################################
# Design Compiler Reference Methodology Script for Top-Down MCMM Flow
# Script: dc.tcl
# Version: N-2017.09 (October 2, 2017)
# Copyright (C) 2007-2016 Synopsys, Inc. All rights reserved.
#################################################################################

# Note: UPF mode is on by default from Design Compiler B-2008.09 version
if {![shell_is_in_upf_mode]} {
  puts "RM-Warn: dc_shell must be run in UPF Mode for MV UPF support."
}

# Design Compiler must be run in topographical mode for MCMM flow support
# MCMM also requires a license for Design Compiler Graphical
if {![shell_is_in_topographical_mode]} {
  puts "RM-Warn: dc_shell must be run in topographical mode for MCMM support."
}

# Design Compiler must be run in topographical mode for SPG flow support
# SPG also requires a license for Design Compiler Graphical
if {![shell_is_in_topographical_mode]} {
  puts "RM-Warn: dc_shell must be run in topographical mode for SPG support."
}

#################################################################################
# Additional Variables
#
# Add any additional variables needed for your flow here.
#################################################################################


################################################################################
# You can enable inference of multibit registers from the buses defined in the RTL.
# The replacement of single-bit cells with multibit library cells occurs during execution 
# of the compile_ultra command. This variable has to be set before reading the RTL
#
# set_app_var hdlin_infer_multibit default_all
#################################################################################

if { $OPTIMIZATION_FLOW == "hplp"} {
 ## set_app_var hdlin_infer_multibit default_all
}

# Enable the insertion of level-shifters on clock nets for a multivoltage flow
set_app_var auto_insert_level_shifters_on_clocks all

# Enable the support of via resistance for RC estimation to improve the timing 
# correlation with IC Compiler
set_app_var spg_enable_via_resistance_support true

# Enable recovery and removal check
set_app_var enable_recovery_removal_arcs true

set_app_var timing_disable_recovery_removal_checks false

if {[file exists [which ${LIBRARY_DONT_USE_PRE_COMPILE_LIST}]]} {
  puts "RM-Info: Sourcing script file [which ${LIBRARY_DONT_USE_PRE_COMPILE_LIST}]\n"
  source -echo -verbose $LIBRARY_DONT_USE_PRE_COMPILE_LIST
}

#################################################################################
# Setup for Formality Verification
#################################################################################

set_svf ${RESULTS_DIR}/${DCRM_SVF_OUTPUT_FILE}

#################################################################################
# Setup SAIF Name Mapping Database
################################################################################

# saif_map -start

#################################################################################
# Read in the RTL Design
#################################################################################

define_design_lib WORK -path ./WORK

set_app_var hdlin_shorten_long_module_name true

if {0} {
    analyze -format sverilog -vcs "-f $RTL_SOURCE_FILES"
    elaborate ${DESIGN_NAME}
    link
    write -hierarchy -format ddc -output ${RESULTS_DIR}/${DCRM_ELABORATED_DESIGN_DDC_OUTPUT_FILE}
} else {
    read_ddc ${RESULTS_DIR}/nvdla.elab.ddc
}

create_port scan_en  -direction in
create_port com_mode -direction in
for {set i 0} {$i < 7 } {incr i} {
create_port scan_in_$i  -direction in
create_port scan_out_$i -direction out
}

set uniquify_naming_style "${DESIGN_NAME}_%s_%d"
uniquify

#################################################################################
# sets the multibit_mode attribute
#################################################################################
if { $OPTIMIZATION_FLOW == "hplp"} {
  # Enable mapping to multibit only if the timing is not degraded.
  ## set_multibit_options -mode timing_driven
}

#################################################################################
# Reports pre-synthesis congestion analysis.
#################################################################################
if { $OPTIMIZATION_FLOW == "hc"} {
  #Analyze the RTL constructs which may lead to congestion
  analyze_rtl_congestion > ${REPORTS_DIR}/${DCRM_ANALYZE_RTL_CONGESTION_REPORT_FILE}
}

#################################################################################
# Load UPF MV Setup
#################################################################################

if {![load_upf ${DCRM_MV_UPF_INPUT_FILE}]} {
  puts "RM-Warn: Unable to load UPF file ${DCRM_MV_UPF_INPUT_FILE}"
}

#################################################################################
# Apply Logical Design Constraints
#################################################################################

# For MCMM, do not apply the constraints here.  Constraints should be
# applied for each scenario in the ${DCRM_MCMM_SCENARIOS_SETUP_FILE}

#################################################################################
# Apply The Operating Conditions
#################################################################################

# For MCMM, do not apply the operating conditions here.  Operating conditions
# should be applied for each scenario in the ${DCRM_MCMM_SCENARIOS_SETUP_FILE}

#################################################################################
# Set Up the Multicorner Multimode (MCMM) Scenarios
#
# Note: The MCMM flow is only supported in topographical mode and it requires
#       a license for Design Compiler Graphical. 
#################################################################################

# Use the dc.mcmm.scenarios.tcl example file as as reference for
# what should be included in the ${DCRM_MCMM_SCENARIOS_SETUP_FILE}

puts "RM-Info: Sourcing script file [which ${DCRM_MCMM_SCENARIOS_SETUP_FILE}]\n"
source -echo -verbose ${DCRM_MCMM_SCENARIOS_SETUP_FILE}

set_active_scenarios [list mode_norm.OC_WC.RC_MAX_1]
current_scenario mode_norm.OC_WC.RC_MAX_1

report_scenarios > ${REPORTS_DIR}/${DCRM_MCMM_SCENARIOS_REPORT}
check_scenarios -output ${REPORTS_DIR}

#################################################################################
# Define Operating Voltages on Power Nets
#################################################################################

# Check and exit if any supply nets are missing a defined voltage.
## For MCMM, perform this check for each scenario.
set current_scenario_saved [current_scenario]
foreach scenario [all_active_scenarios] {
  current_scenario ${scenario}
  if {![check_mv_design -power_nets]} {
    puts "RM-Warn: One or more supply nets are missing a defined voltage.  Use the set_voltage command to set the appropriate voltage upon the supply."
    puts "This script will now exit."
  }
}
current_scenario ${current_scenario_saved}

#################################################################################
# Create Default Path Groups
#
# Separating these paths can help improve optimization.
# Remove these path group settings if user path groups have already been defined.
#################################################################################

set current_scenario_saved [current_scenario]
foreach scenario [all_active_scenarios] {
  current_scenario ${scenario}
  source -e -v scripts_block/rm_dc_user_scripts/nvdla.group_path.tcl
}
current_scenario ${current_scenario_saved}

#################################################################################
# Power Optimization Section
#################################################################################

    #############################################################################
    # Clock Gating Setup
    #############################################################################

    # If your design has instantiated clock gates, you should use identify_clock_gating
    # command to identify and the report_clock_gating -multi_stage to report them.

    #set_app_var power_cg_auto_identify true
    identify_clock_gating
    report_clock_gating -multi_stage -nosplit > ${REPORTS_DIR}/${DCRM_INSTANTIATE_CLOCK_GATES_REPORT}

    # If you do not want clock-gating to optimize your user instantiated
    # clock-gating cells, you should set the pwr_preserve_cg attribute upon
    # those clock-gating cells.
    set_clock_gating_style \
	-num_stages 3 \
	-minimum_bitwidth 4 \
	-max_fanout 24 \
	-sequential_cell latch \
	-positive_edge_logic {integrated:HDBSVT20_CKGTPLT_V7_12} \
	-control_point before \
	-control_signal scan_enable \
	-no_sharing

    set_app_var power_cg_physically_aware_cg true
    set_app_var compile_clock_gating_through_hierarchy true

    #############################################################################
    # Apply Power Optimization Constraints
    #############################################################################

    if {[shell_is_in_topographical_mode]} {
      # For multi-Vth design, replace the following to set the threshold voltage groups in the libraries.

      # set_attribute <my_hvt_lib> default_threshold_voltage_group HVT -type string
      # set_attribute <my_lvt_lib> default_threshold_voltage_group LVT -type string
    }

##################################################################################
# Apply Physical Design Constraints
##################################################################################
if {[shell_is_in_topographical_mode]} {

#############################################################################
# Apply Power Optimization Constraints
#############################################################################

#set_app_var power_low_power_placement true

#################################################################################
# Apply Physical Design Constraints
#################################################################################

set_preferred_routing_direction -layers $HORIZONTAL_ROUTING_LAYER_LIST -direction horizontal
set_preferred_routing_direction -layers $VERTICAL_ROUTING_LAYER_LIST   -direction vertical

# Specify ignored layers for routing to improve correlation
  if { ${MIN_ROUTING_LAYER} != ""} {
    set_ignored_layers -min_routing_layer ${MIN_ROUTING_LAYER}
  }
  if { ${MAX_ROUTING_LAYER} != ""} {
    set_ignored_layers -max_routing_layer ${MAX_ROUTING_LAYER}
  }

  report_ignored_layers

  if {[file exists [which ${DCRM_DCT_DEF_INPUT_FILE}]]} {

    puts "RM-Info: Reading in DEF file [which ${DCRM_DCT_DEF_INPUT_FILE}]\n"
    if { $OPTIMIZATION_FLOW == "hplp"} {
	  extract_physical_constraints -allow_physical_cells ${DCRM_DCT_DEF_INPUT_FILE}  
    } else {
      extract_physical_constraints ${DCRM_DCT_DEF_INPUT_FILE}
    }
  }
  
  if {[file exists [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects]]} {
    puts "RM-Info: Reading in secondary floorplan file [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects]\n"
    read_floorplan ${DCRM_DCT_FLOORPLAN_INPUT_FILE}.objects
  }

  if {[file exists [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}]]} {
    puts "RM-Info: Reading in floorplan file [which ${DCRM_DCT_FLOORPLAN_INPUT_FILE}]\n"
    read_floorplan ${DCRM_DCT_FLOORPLAN_INPUT_FILE}
  }

  if {[file exists [which ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}]]} {
    set_app_var enable_rule_based_query true
    puts "RM-Info: Sourcing script file [which ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}]\n"
    source -echo -verbose ${DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE}
    set_app_var enable_rule_based_query false 
  }


  ###################################################################################
  # For multivoltage multisupply designs, if your floor plan includes voltage
  # areas, please create the voltage areas corresponding to your power domains.
  ###################################################################################
  
  if {[file exists [which ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE}]]} {
    # Use read_floorplan to also handle files generated by write_floorplan
    puts "RM-Info: Reading in file [which ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE}]\n"
    read_floorplan ${DCRM_MV_DCT_VOLTAGE_AREA_INPUT_FILE}
  }

  #write_floorplan -all ${RESULTS_DIR}/${DCRM_DCT_FLOORPLAN_OUTPUT_FILE}

  # Verify that all the desired physical constraints have been applied
  #report_physical_constraints > ${REPORTS_DIR}/${DCRM_DCT_PHYSICAL_CONSTRAINTS_REPORT}

  #if {[info exists env(DISPLAY)]} {
  #  gui_start
  #  set MyLayout [gui_create_window -type LayoutWindow]
  #  gui_write_window_image -format png -file ${REPORTS_DIR}/${DESIGN_NAME}.layout.png
  #  gui_stop
  #}
}

#################################################################################
# Apply Additional Optimization Constraints
#################################################################################

# Prevent assignment statements in the Verilog netlist.
set_fix_multiple_port_nets -all -buffer_constants

#################################################################################
# Check for Design Problems 
#################################################################################

# Check the current design for consistency
check_design -summary
check_design > ${REPORTS_DIR}/${DCRM_CHECK_DESIGN_REPORT}

#################################################################################
# Multibit Register Reports pre-compile_ultra
#################################################################################

#################################################################################
# Uncomment the next line to verify that the desired bussed registers are grouped as multibit components 
# These multibit components are mapped to multibit registers during compile_ultra
#
# redirect ${REPORTS_DIR}/${DCRM_MULTIBIT_COMPONENTS_REPORT} {report_multibit -hierarchical }
#################################################################################


#################################################################################
# Compile the Design
#################################################################################
## RM+ Variable and Command Settings before first compile_ultra
#################################################################################
if { $OPTIMIZATION_FLOW == "hplp"} {
    if {[shell_is_in_topographical_mode]} {

	# The following variable, when set to true, runs additional optimizations to improve the timing of  
	# the design at the cost of additional run time.
	set_app_var compile_timing_high_effort true

	# The following variable enables a mode of coarse placement in which cells are not distributed  
	# evenly  across the surface but are allowed to clump together for better QoR     
	set_app_var placer_max_cell_density_threshold 0.7        

	# The following variable, when set to true, enables very high effort optimization to fix total negative slack 
	# Setting following variable to true may affect run time
	set_app_var psynopt_tns_high_effort true

	# Use the following variable to enable the physically aware clock gating 
	## set_app_var power_cg_physically_aware_cg true
	
	#The following variable helps to reduce the total negative slack of the design
	set_app_var placer_tns_driven true

	# Enable low power placement.  
	# Low power placement affects the placement of cells, pulls them closer together, 
	# on nets with high switching activity to reduce the overall dynamic power of your design.  
    #set_app_var power_low_power_placement true

    # In MCMM flow use set_scenario_options -dynamic_power true 
	# set_dynamic_optimization true

	# Enable enhanced SPG timing model
	set_app_var spg_enhanced_timing_model true

	set_app_var compile_prefer_mux true
	
    }
    # The following variable enables register replication across the hierarchy by creating new ports
	# on the instances of the subdesigns if it is necessary to improve the timing of the design
	set_app_var compile_register_replication_across_hierarchy true 
}
if { $OPTIMIZATION_FLOW == "hc"} {
   if {[shell_is_in_topographical_mode]} {

       # This command enables congestion aware Global buffering based on Zroutebased estimation,
       # reducing congestion along narrow channels across macros. Enabling this feature may have 
       # runtime and QOR impact. Enable this variable on macro intensive designs with narrow channels.
       # set_ahfs_options -global_route true


       # With the following variables set, Zroute-based congestion-driven placement is enabled
       # instead of virtual route based estimation. 
       # Enabling this feature may have runtime impact. Enable this for highly congested designs
       # set_app_var placer_congestion_effort medium
       # set_app_var placer_enable_enhanced_router true

       # Enabling the variable can lead to lower congestion for designs that have congestion due to
       # multiplexing logic in the RTL. This variable is supported only in the initial compile step,
       # Not supported in incremental compile.
       set_app_var compile_prefer_mux true
   }
}
if { $OPTIMIZATION_FLOW == "rtm_exp"} {
  if {[shell_is_in_topographical_mode]} {
  
      ## set_host_options -max_cores 8
      # The following command overrides runtime-intensive user settings with settings designed
      # to improve runtime. Since the run time intensive optimizations are turned off it might 
      # impact QoR. You can use this as an exploration flow when run time is a concern.
      compile_prefer_runtime
  }
}
if {[shell_is_in_topographical_mode]} {
  # Use the "-check_only" option of "compile_ultra" to verify that your
  # libraries and design are complete and that optimization will not fail
  # in topographical mode.  Use the same options as will be used in compile_ultra.

   compile_ultra -scan -gate_clock -spg -check_only
}

 set_compile_spg_mode icc2 

# glji
source -e -v ./scripts_block/rm_dc_user_scripts/keep_module_hier.tcl
source -e -v ./scripts_block/rm_dc_user_scripts/nvdla.misc.tcl

compile_ultra -scan -spg

echo "First Compile_ultra Finished!" >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}
cputime -verbose >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}

report_qor > ${REPORTS_DIR}/${DCRM_COMPILE_ULTRA_QOR_REPORT}
proc_qor   > ${REPORTS_DIR}/${DESIGN_NAME}.compile_ultra.proc_qor
report_timing -scenarios [all_active_scenarios] -attributes -max_paths 20 -sort_by group -derate > ${REPORTS_DIR}/${DCRM_COMPILE_ULTRA_TIMING_REPORT_GROUP}
report_timing -scenarios [all_active_scenarios] -attributes -max_paths 20 -sort_by slack -derate > ${REPORTS_DIR}/${DCRM_COMPILE_ULTRA_TIMING_REPORT_SLACK}

#################################################################################
# Save Design after First Compile
#################################################################################

write -format ddc -hierarchy -output ${RESULTS_DIR}/${DCRM_COMPILE_ULTRA_DDC_OUTPUT_FILE}
write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_COMPILE_ULTRA_VERILOG_OUTPUT_FILE}

if {$OPTIMIZATION_FLOW != "rtm_exp"} {
#################################################################################
# Performing placement aware multibit banking
#################################################################################

#################################################################################
if {[shell_is_in_topographical_mode]} {
       # identify_register_banks -output ${RESULTS_DIR}/${DCRM_MULTIBIT_CREATE_REGISTER_BANK_FILE}
       # redirect ${REPORTS_DIR}/${DCRM_MULTIBIT_CREATE_REGISTER_BANK_REPORT} {source -echo -verbose ${RESULTS_DIR}/${DCRM_MULTIBIT_CREATE_REGISTER_BANK_FILE}}
}
#################################################################################


################################################################################
## RM+ Variable and Command Settings before incremental compile
################################################################################
if { $OPTIMIZATION_FLOW == "hplp" } {
    if {[shell_is_in_topographical_mode]} {
	# You can use placement aware multibit banking to group single-bit register cells that 
	# are physically near each other into a multibit registers
    # Please use -wns_threshold option with identify_register_banks command if u want to 
    # exclude specific percentage of timing critical registers from multibit banking
	## identify_register_banks -output \
	##     ${RESULTS_DIR}/${DCRM_MULTIBIT_CREATE_REGISTER_BANK_FILE}
	## source -echo -verbose ${RESULTS_DIR}/${DCRM_MULTIBIT_CREATE_REGISTER_BANK_FILE}
    }
    proc_auto_weights -tns -exclude_groups {REGOUT FEEDTHROUGH REGIN}
}
#################################################################################
# DFT Compiler Optimization Section
#################################################################################
source -e -v ./scripts_block/rm_dc_user_scripts/scan_insert.tcl

################################################################################
## RM+ Variable and Command Settings before incremental compile
################################################################################
if { $OPTIMIZATION_FLOW == "hplp" } {
  # Creating path groups to reduce TNS
 create_auto_path_groups -mode mapped
}
if { (${OPTIMIZATION_FLOW} == "hc") || (${OPTIMIZATION_FLOW} == "hplp") } {
    if {[shell_is_in_topographical_mode]} {

	# Enable congestion-driven  placement  in incremental compile to improve congestion    
	# while preserving quality of results
	set_app_var spg_congestion_placement_in_incremental_compile true
    }
}

if {[file exists [which ${LIBRARY_DONT_USE_PRE_INCR_COMPILE_LIST}]]} {
  puts "RM-Info: Sourcing script file [which ${LIBRARY_DONT_USE_PRE_INCR_COMPILE_LIST}]\n"
  source -echo -verbose $LIBRARY_DONT_USE_PRE_INCR_COMPILE_LIST
}

#########################################################################
# Incremental compile is required if netlist and/or constraints are 
# changed after first compile
# Example: DFT insertion, Placement aware multibit banking etc.       
# Incremental compile is also recommended for final QoR signoff as well
#########################################################################   

#compile_prefer_runtime

compile_ultra -incremental -scan -spg

echo "Second Compile_ultra Finished!" >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}
cputime -verbose >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}

proc_qor   > ${REPORTS_DIR}/${DESIGN_NAME}.incr.proc_qor
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DESIGN_NAME}.incr.ddc

################################################################################
# Remove the path groups generated by create_path_groups command. 
# This does not remove user created path groups
################################################################################
if { $OPTIMIZATION_FLOW == "hplp" } {
    remove_auto_path_groups
}
#################################################################################
# High-effort area optimization
#
# optimize_netlist -area command, was introduced in I-2013.12 release to improve
# area of gate-level netlists. The command performs monotonic gate-to-gate 
# optimization on mapped designs, thus improving area without degrading timing or
# leakage. 
#################################################################################

optimize_netlist -area
}
#################################################################################
# Check for MV Violations
#################################################################################

set current_scenario_saved [current_scenario]
foreach scenario [all_active_scenarios] {
  current_scenario ${scenario}
  check_mv_design > ${REPORTS_DIR}/[dcrm_mcmm_filename ${DCRM_MV_DRC_FINAL_SUMMARY_REPORT} ${scenario}]
  check_mv_design -verbose > ${REPORTS_DIR}/[dcrm_mcmm_filename ${DCRM_MV_DRC_FINAL_VERBOSE_REPORT} ${scenario}]
}
current_scenario ${current_scenario_saved}

#################################################################################
# Write Out Final Design and Reports
#
#        .ddc:   Recommended binary format used for subsequent Design Compiler sessions
#    Milkyway:   Recommended binary format for IC Compiler
#        .v  :   Verilog netlist for ASCII flow (Formality, PrimeTime, VCS)
#       .spef:   Topographical mode parasitics for PrimeTime
#        .sdf:   SDF backannotated topographical mode timing for PrimeTime
#        .sdc:   SDC constraints for ASCII flow
#        .upf:   UPF multivoltage setup information for mapped design
#
#################################################################################

change_names -rules verilog -hierarchy

#write_icc2_files -force  -output ${RESULTS_DIR}/${DCRM_FINAL_DESIGN_ICC2}

    #############################################################################
    # DFT Write out Test Protocols and Reports
    #############################################################################

    # write_scan_def adds SCANDEF information to the design database in memory, so 
    # this command must be performed prior to writing out the design database 
    # containing binary SCANDEF.

    write_scan_def -output ${RESULTS_DIR}/${DCRM_DFT_FINAL_SCANDEF_OUTPUT_FILE}
    check_scan_def > ${REPORTS_DIR}/${DCRM_DFT_FINAL_CHECK_SCAN_DEF_REPORT}
    write_test_model -format ctl -output ${RESULTS_DIR}/${DCRM_DFT_FINAL_CTL_OUTPUT_FILE}

    report_dft_signal > ${REPORTS_DIR}/${DCRM_DFT_FINAL_DFT_SIGNALS_REPORT}

    # DFT outputs for standard scan mode

    write_test_protocol -test_mode Internal_scan -output ${RESULTS_DIR}/${DCRM_DFT_FINAL_PROTOCOL_OUTPUT_FILE}
    current_test_mode Internal_scan
    report_scan_path > ${REPORTS_DIR}/${DCRM_DFT_FINAL_SCAN_PATH_REPORT}
    dft_drc
    dft_drc -verbose > ${REPORTS_DIR}/${DCRM_DFT_DRC_FINAL_REPORT}

    # DFT outputs for compressed scan mode
    # If you have defined you own test modes, change the name of the test mode from 
    # "ScanCompression_mode" to the one that you have specified using define_test_mode command.

    write_test_protocol -test_mode ScanCompression_mode -output ${RESULTS_DIR}/${DCRM_DFT_FINAL_SCAN_COMPR_PROTOCOL_OUTPUT_FILE}
    current_test_mode ScanCompression_mode
    report_scan_path > ${REPORTS_DIR}/${DCRM_DFT_FINAL_SCAN_COMPR_SCAN_PATH_REPORT}
    dft_drc 
    dft_drc -verbose > ${REPORTS_DIR}/${DCRM_DFT_DRC_FINAL_SCAN_COMPR_REPORT}

#################################################################################
# Write out Design
#################################################################################

write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}

write -format ddc     -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_DDC_OUTPUT_FILE}


save_upf ${RESULTS_DIR}/${DCRM_MV_FINAL_UPF_OUTPUT_FILE}

# Write and close SVF file and make it available for immediate use
set_svf -off

#################################################################################
# Write out Design Data
#################################################################################

if {[shell_is_in_topographical_mode]} {

  # Note: A secondary floorplan file ${DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE}.objects
  #       might also be written to capture physical-only objects in the design.
  #       This file should be read in before reading the main floorplan file.

  #write_floorplan -all ${RESULTS_DIR}/${DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE}

  # If the DCRM_DCT_SPG_PLACEMENT_OUTPUT_FILE variable has been set in dc_setup_filenames.tcl
  # file then the standard cell physical guidance is being created to support SPG ASCII hand-off
  # to IC Compiler by the write_def command.
  # Invoking write_def commands requires a Design Compiler Graphical license or an IC Compiler
  # Design Planning license.

  if {[info exists DCRM_DCT_SPG_PLACEMENT_OUTPUT_FILE]} {
    write_def -components -output ${RESULTS_DIR}/${DCRM_DCT_SPG_PLACEMENT_OUTPUT_FILE}
  }

  # Do not write out net RC info into SDC
  set_app_var write_sdc_output_lumped_net_capacitance false
  set_app_var write_sdc_output_net_resistance false

  set all_active_scenario_saved [all_active_scenarios]
  set current_scenario_saved [current_scenario]
  set_active_scenarios -all
  foreach scenario [all_active_scenarios] {
      current_scenario ${scenario}

    # Write parasitics data from Design Compiler Topographical placement for static timing analysis
    # write_parasitics -output ${RESULTS_DIR}/[dcrm_mcmm_filename ${DCRM_DCT_FINAL_SPEF_OUTPUT_FILE} ${scenario}]

    # Write SDF backannotation data from Design Compiler Topographical placement for static timing analysis
    # write_sdf ${RESULTS_DIR}/[dcrm_mcmm_filename ${DCRM_DCT_FINAL_SDF_OUTPUT_FILE} ${scenario}]

    write_sdc -nosplit ${RESULTS_DIR}/[dcrm_mcmm_filename ${DCRM_FINAL_SDC_OUTPUT_FILE} ${scenario}]
  }
  current_scenario ${current_scenario_saved}
  set_active_scenarios ${all_active_scenario_saved}
}

## transfer sdc to icc2
set targetSce     [lindex [all_scenario] 0]
set srcSdcName    "${RESULTS_DIR}/[dcrm_mcmm_filename ${DCRM_FINAL_SDC_OUTPUT_FILE} ${targetSce}]"
set targetSdcName "${RESULTS_DIR}/${DESIGN_NAME}.mapped.sdc"
set rfp [open ${srcSdcName} r]
set ofp [open ${targetSdcName} w]

while { [gets $rfp line] >= 0} {
    if      { [regexp -- {^set_operating_conditions} $line match ] } { 
        puts $ofp "## ${line}" 
    } elseif { [regexp -- {^set_clock_gating_check} $line match ] } { 
        puts $ofp "## ${line}" 
    } elseif { [regexp -- {^set_timing_derate} $line match ] } { 
        puts $ofp "## ${line}" 
    } elseif { [regexp -- {^set_voltage} $line match ] } { 
        puts $ofp "## ${line}" 
    } else { 
        puts $ofp ${line} 
    }
}

close $rfp
close $ofp
## ---

# Write out link library information for PrimeTime when using instance-based target library settings
write_link_library -out ${RESULTS_DIR}/${DCRM_MV_FINAL_LINK_LIBRARY_OUTPUT_FILE}

# If SAIF is used, write out SAIF name mapping file for PrimeTime-PX
# saif_map -type ptpx -write_map ${RESULTS_DIR}/${DESIGN_NAME}.mapped.SAIF.namemap

#################################################################################
# Generate MV Reports
#################################################################################

# For MCMM, some MV reports could have different voltages for different scenarios
set current_scenario_saved [current_scenario]
foreach scenario [all_active_scenarios] {
  current_scenario ${scenario}

  # Report all power domains in the design
  report_power_domain [get_power_domains * -hierarchical] > \
  ${REPORTS_DIR}/[dcrm_mcmm_filename ${DCRM_MV_FINAL_POWER_DOMAIN_REPORT} ${scenario}]

  # Report the top level supply nets
  report_supply_net [get_supply_nets *] > \
  ${REPORTS_DIR}/[dcrm_mcmm_filename ${DCRM_MV_FINAL_SUPPLY_NET_REPORT} ${scenario}]

  # Report the level shifters in the design
  report_level_shifter -domain [get_power_domains * -hierarchical] > \
  ${REPORTS_DIR}/[dcrm_mcmm_filename ${DCRM_MV_FINAL_LEVEL_SHIFTER_REPORT} ${scenario}]
}
current_scenario ${current_scenario_saved}

# Report the isolation cells in the design
report_isolation_cell -domain [get_power_domains * -hierarchical]  > ${REPORTS_DIR}/${DCRM_MV_FINAL_ISOLATION_CELL_REPORT}

# Report the retention registers in the design
report_retention_cell -domain [get_power_domains * -hierarchical] > ${REPORTS_DIR}/${DCRM_MV_FINAL_RETENTION_CELL_REPORT}

# Report the power switches in the design
report_power_switch [get_power_switches * -hierarchical] > ${REPORTS_DIR}/${DCRM_MV_FINAL_POWER_SWITCH_REPORT}

# Report the power state table
report_pst > ${REPORTS_DIR}/${DCRM_MV_FINAL_PST_REPORT}

#################################################################################
# Generate Final Reports
#################################################################################

if { $OPTIMIZATION_FLOW  == "rtm_exp"} {
  ## set_host_options -max_cores 8
  update_timing

  parallel_execute [list \
  "report_qor > ${REPORTS_DIR}/${DCRM_FINAL_QOR_REPORT}" \
  "report_timing -transition_time -nets -attributes -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_TIMING_REPORT}" \
  "report_area -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_AREA_REPORT}" \
  "report_clock_gating -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_CLOCK_GATING_REPORT}" \
  ]

} else {
    report_qor > ${REPORTS_DIR}/${DCRM_FINAL_QOR_REPORT}
    proc_qor   > ${REPORTS_DIR}/${DESIGN_NAME}.mapped.proc_qor
    sh perl ./scripts_block/rm_dc_user_scripts/gen_report.pl -type wns ${REPORTS_DIR}/${DCRM_FINAL_QOR_REPORT} >> ${REPORTS_DIR}/${DCRM_FINAL_QOR_REPORT}
    
    report_timing -scenarios [all_active_scenarios] -attributes -max_paths 20 -sort_by group > ${REPORTS_DIR}/${DCRM_FINAL_TIMING_REPORT_GROUP}
    report_timing -scenarios [all_active_scenarios] -attributes -max_paths 1000 -sort_by slack > ${REPORTS_DIR}/${DCRM_FINAL_TIMING_REPORT_SLACK}
    
    sh perl ./scripts_block/rm_dc_user_scripts/report_path_point.pl -type end ${REPORTS_DIR}/${DCRM_FINAL_TIMING_REPORT_SLACK} >> ${REPORTS_DIR}/${DCRM_FINAL_QOR_REPORT}
    
    
    if {[shell_is_in_topographical_mode]} {
      report_area -physical -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_AREA_REPORT}
    } else {
      report_area -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_AREA_REPORT}
    }
    report_area -designware  > ${REPORTS_DIR}/${DCRM_FINAL_DESIGNWARE_AREA_REPORT}
    report_resources -hierarchy > ${REPORTS_DIR}/${DCRM_FINAL_RESOURCES_REPORT}
    report_clock_gating -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_CLOCK_GATING_REPORT}
}

# Create a QoR snapshot of timing, physical, constraints, clock, power data, and routing on 
# active scenarios and stores it in the location  specified  by  the icc_snapshot_storage_location 
# variable. 

if {[shell_is_in_topographical_mode]} {
  set icc_snapshot_storage_location ${REPORTS_DIR}/${DCRM_DCT_FINAL_QOR_SNAPSHOT_FOLDER}
  create_qor_snapshot -name ${DCRM_DCT_FINAL_QOR_SNAPSHOT_REPORT} > ${REPORTS_DIR}/${DCRM_DCT_FINAL_QOR_SNAPSHOT_REPORT}
}


# Uncomment the next line to report all the multibit registers and the banking ratio in the design
# redirect ${REPORTS_DIR}/${DCRM_MULTIBIT_BANKING_REPORT} {report_multibit_banking -nosplit }

# Use SAIF file for power analysis
# set current_scenario_saved [current_scenario]
# foreach scenario [all_active_scenarios] {
#   current_scenario ${scenario}
#   read_saif -auto_map_names -input ${DESIGN_NAME}.${scenario}.saif -instance < DESIGN_INSTANCE > -verbose
# }
# current_scenario ${current_scenario_saved}


report_power -scenarios [all_active_scenarios] -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_POWER_REPORT}
report_clock_gating -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_CLOCK_GATING_REPORT}

# Uncomment the next line if you include the -self_gating to the compile_ultra command
# to report the XOR Self Gating information.
# report_self_gating  -nosplit > ${REPORTS_DIR}/${DCRM_FINAL_SELF_GATING_REPORT}

# Uncomment the next line to reports the number, area, and  percentage  of cells 
# for each threshold voltage group in the design.
report_threshold_voltage_group -nosplit > ${REPORTS_DIR}/${DCRM_THRESHOLD_VOLTAGE_GROUP_REPORT}

report_app_var -only_changed_vars > ${REPORTS_DIR}/${DCRM_NON_DEFAULT_SETTING_REPORT}

# if {[shell_is_in_topographical_mode]} {
#   # report_congestion (topographical mode only) uses zroute for estimating and reporting 
#   # routing related congestion which improves the congestion correlation with IC Compiler.
#   # Design Compiler Topographical supports create_route_guide command to be consistent with IC
#   # Compiler after topographical mode synthesis.
#   # Those commands require a license for Design Compiler Graphical.
# 
#   set_message_info -id ZRT-110 -limit 1000
#   set_message_info -id ZRT-127 -limit 1000
# 
#   report_congestion > ${REPORTS_DIR}/${DCRM_DCT_FINAL_CONGESTION_REPORT}
# 
#   # Use the following to generate and write out a congestion map from batch mode
#   # This requires a GUI session to be temporarily opened and closed so a valid DISPLAY
#   # must be set in your UNIX environment.
# 
#   if {[info exists env(DISPLAY)]} {
#     gui_start
# 
#     # Create a layout window
#     set MyLayout [gui_create_window -type LayoutWindow]
# 
#     # Build congestion map in case report_congestion was not previously run
#     report_congestion -build_map
# 
#     # Display congestion map in layout window
#     gui_show_map -map "Global Route Congestion" -show true
# 
#     # Zoom full to display complete floorplan
#     gui_zoom -window [gui_get_current_window -view] -full
# 
#     # Write the congestion map out to an image file
#     # You can specify the output image type with -format png | xpm | jpg | bmp
# 
#     # The following saves only the congestion map without the legends
#     gui_write_window_image -format png -file ${REPORTS_DIR}/${DCRM_DCT_FINAL_CONGESTION_MAP_OUTPUT_FILE}
# 
#     # The following saves the entire congestion map layout window with the legends
#     gui_write_window_image -window ${MyLayout} -format png -file ${REPORTS_DIR}/${DCRM_DCT_FINAL_CONGESTION_MAP_WINDOW_OUTPUT_FILE}
# 
#     gui_stop
#   } else {
#     puts "Information: The DISPLAY environment variable is not set. Congestion map generation has been skipped."
#   }
# }


#################################################################################
# Write out Milkyway Design for Top-Down Flow
#
# This should be the last step in the script
#################################################################################

#if {[shell_is_in_topographical_mode]} {
#  # write_milkyway uses mw_design_library variable from dc_setup.tcl
#  write_milkyway -overwrite -output ${DCRM_FINAL_MW_CEL_NAME}
#}

echo "Synthesis End!" >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}
cputime -verbose >> ${REPORTS_DIR}/${DCRM_CPU_RUNTIME_REPORT}

echo [date] > syn

exit
