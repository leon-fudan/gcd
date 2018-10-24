#################################################################################
# VC-LP Verification Script for
# Design Compiler Reference Methodology Script for Top-Down Flow
# Script: vc_lp.tcl
# Version: N-2017.09 (October 2, 2017)
# Copyright (C) 2011-2017 Synopsys, Inc. All rights reserved.
#################################################################################

# Enable the default behavior of sh_continue_on_error to be same as DC 
# Change variable settings to improve QoR of VC LP and to better match
# results of check_mv_design 
set_app_var sh_continue_on_error true
set_app_var handle_hanging_crossover true
set_app_var enable_local_policy_match true
set_app_var upf_iso_filter_elements_with_applies_to ENABLE
set_app_var enable_multi_driver_analysis true
set_app_var enable_verdi_debug true

source -echo -verbose ./rm_setup/dc_setup.tcl

#################################################################################
# Read in the Design and UPF
#
# Read in the RTL/NETLIST and UPF files.
#################################################################################

if {$VCLP_RUN=="RTL"} {
  # Load the RTL design 
  analyze -format verilog -work work ${RTL_SOURCE_FILES}
  elaborate ${DESIGN_NAME}

  # Load the UPF files
  read_upf ${DCRM_MV_UPF_INPUT_FILE}

# Use Netlist as the default mode to run VCLP checks
} else {
  # Load the design netlist
  read_file -netlist -format verilog -top ${DESIGN_NAME} ${DCRM_FINAL_VERILOG_OUTPUT_FILE} 

  # Load the UPF files
  read_upf ${DESIGN_NAME}.mapped.upf 
}

#################################################################################
# Check the Design
#################################################################################

# Validated the UPF completeness and consistence
check_lp -stage upf 

# Check design consistency with UPF
if {$VCLP_RUN =="NETLIST"} {
  check_lp -stage design
}

#################################################################################
# Generate Final Reports
#################################################################################

report_lp -file          ${REPORTS_DIR}/${DESIGN_NAME}.vclp_report_violations.${VCLP_RUN}.rpt
report_lp -verbose -file ${REPORTS_DIR}/${DESIGN_NAME}.vclp_report_violations.${VCLP_RUN}.verbose.rpt

puts "RM-Info: End script [info script]\n"
exit

