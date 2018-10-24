#################################################################################
# Design Compiler MCMM Scenarios Setup File Reference
# Script: dc.mcmm.scenarios.tcl
# Version: N-2017.09 (October 2, 2017)
# Copyright (C) 2011-2017 Synopsys, Inc. All rights reserved.
#################################################################################

#################################################################################
# This is an example of the MCMM scenarios setup file for Design Compiler.
# Please note that this file will not work as given and must be edited for your
# design.
#
# Create this file for each design in your MCMM flow and configure the filename
# with the value of the ${DCRM_MCMM_SCENARIOS_SETUP_FILE} in
# rm_setup/dc_setup_filenames.tcl
#
# It is recommended to use a minimum set of worst case setup scenarios
# and a worst case leakage scenario in Design Compiler.
# Further refinement to optimize across all possible scenarios is recommended
# to be done in IC Compiler.
#################################################################################

#################################################################################
# Additional Notes
#################################################################################
#
# In MCMM, good leakage and dynamic power optimization results can be obtained by
# using a worst case leakage scenario along with scenario-independent clock gating
# (compile_ultra -gate_clock).
#
# A recommended scenario naming convention (used by Lynx) is the following:
#
# <MM_TYPE>.<OC_TYPE>.<RC_TYPE>
#
# MM_TYPE - Label that identifies the operating mode or set of timing constraints
#           Example values: mode_norm, mode_slow, mode_test
#
# OC_TYPE - Label that identifies the library operating conditions or PVT corner
#           Example values: OC_WC, OC_BC, OC_TYP, OC_LEAK, OC_TEMPINV
#
# RC_TYPE - Label that identifies an extraction corner (TLUPlus files)
#           Example values: RC_MAX_1, RC_MIN_1, RC_TYP
#################################################################################

#################################################################################
# Worst Case Setup Scenario
#################################################################################

set scenario mode_norm.OC_WC.RC_MAX_1

create_scenario ${scenario}

# Read in scenario-specific constraints file

puts "RM-Info: Sourcing script file [which [dcrm_mcmm_filename ${DCRM_CONSTRAINTS_INPUT_FILE} ${scenario}]]\n"
source [dcrm_mcmm_filename ${DCRM_CONSTRAINTS_INPUT_FILE} ${scenario}]

# puts "RM-Info: Reading SDC file [which [dcrm_mcmm_filename ${DCRM_SDC_INPUT_FILE} ${scenario}]]\n"
# read_sdc [dcrm_mcmm_filename ${DCRM_SDC_INPUT_FILE} ${scenario}]

set_operating_conditions -max_library ts16ncfslogl20hdl090f_ssgnp0p72vn40c -max SSGNP0P72VN40C

set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
                   -min_tluplus $TLUPLUS_MIN_FILE \
                   -tech2itf_map $MAP_FILE

check_tlu_plus_files

# For a MV flow, apply set_voltage settings for each scenario if these settings
# are not already a part of the input SDC file.

set MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE [dcrm_mcmm_filename ${DCRM_MV_SET_VOLTAGE_INPUT_FILE} ${scenario}]

if {[file exists [which ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}]]} {
  puts "RM-Info: Sourcing script file [which ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}]\n"
  source -echo -verbose ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}
}

# Include scenario specific SAIF file, if possible, for power analysis.
# Otherwise, the default toggle rate of 0.1 will be used for propagating
# switching activity.

# read_saif -auto_map_names -input ${DESIGN_NAME}.${scenario}.saif -instance < DESIGN_INSTANCE > -verbose

# Set options for worst case setup scenario
set_scenario_options -setup true -hold false -leakage_power false -dynamic_power false

report_scenario_options

# Define additional setup scenarios here as needed, using the same format.

##################################################################################
## Worst Case Leakage Scenario
##################################################################################
#
#set scenario mode_norm.OC_LEAK.RC_MAX_1
#
#create_scenario ${scenario}
#
## Read in scenario-specific constraints file
#
#puts "RM-Info: Sourcing script file [which [dcrm_mcmm_filename ${DCRM_CONSTRAINTS_INPUT_FILE} ${scenario}]]\n"
#source [dcrm_mcmm_filename ${DCRM_CONSTRAINTS_INPUT_FILE} ${scenario}]
#
## puts "RM-Info: Reading SDC file [which [dcrm_mcmm_filename ${DCRM_SDC_INPUT_FILE} ${scenario}]]\n"
## read_sdc [dcrm_mcmm_filename ${DCRM_SDC_INPUT_FILE} ${scenario}]
#
#set_operating_conditions -max_library tcbn12ffcllbwp6t16p96cpdssgnp0p72v125c_ccs -max ssgnp0p72v125c
#
#set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
#                   -min_tluplus $TLUPLUS_MIN_FILE \
#                   -tech2itf_map $MAP_FILE
#
#check_tlu_plus_files
#
## For a MV flow, apply set_voltage settings for each scenario if these settings
## are not already a part of the input SDC file.
#set_voltage 0.72 -object_list {VDD}
#set_voltage 0 -object_list {VSS}
#
#set MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE [dcrm_mcmm_filename ${DCRM_MV_SET_VOLTAGE_INPUT_FILE} ${scenario}]
#
#if {[file exists [which ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}]]} {
#  puts "RM-Info: Sourcing script file [which ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}]\n"
#  source -echo -verbose ${MCMM_DCRM_MV_SET_VOLTAGE_INPUT_FILE}
#}
#
## Include scenario specific SAIF file, if possible, for power optimization and analysis.
## Otherwise, the default toggle rate of 0.1 will be used for propagating
## switching activity.
#
## read_saif -auto_map_names -input ${DESIGN_NAME}.${scenario}.saif -instance < DESIGN_INSTANCE > -verbose
#
## Set options for worst case leakage scenario
#set_scenario_options -setup false -hold false -leakage_power true

report_scenario_options
