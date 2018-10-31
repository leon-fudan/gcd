puts "RM-Info: Running script [info script]\n"

##########################################################################################
# Variables common to all reference methodology scripts
# Script: common_setup.tcl
# Version: N-2017.09 (October 2, 2017)
# Copyright (C) 2007-2017 Synopsys, Inc. All rights reserved.
##########################################################################################

set DESIGN_NAME                   "gcd"  ;#  The name of the top-level design

set DESIGN_REF_DATA_PATH           "/remote/ailab1/weihang/course/dsp_vsli/"  ;#  Absolute path prefix variable for library/design data.
                                       #  Use this variable to prefix the common absolute path  
                                       #  to the common variables defined below.
                                       #  Absolute paths are mandatory for hierarchical 
                                       #  reference methodology flow.

##########################################################################################
# Hierarchical Flow Design Variables
##########################################################################################

set HIERARCHICAL_DESIGNS           "" ;# List of hierarchical block design names "DesignA DesignB" ...
set HIERARCHICAL_CELLS             "" ;# List of hierarchical block cell instance names "u_DesignA u_DesignB" ...

##########################################################################################
# Library Setup Variables
##########################################################################################

# For the following variables, use a blank space to separate multiple entries.
# Example: set TARGET_LIBRARY_FILES "lib1.db lib2.db lib3.db"

set ADDITIONAL_SEARCH_PATH        "./inputs ./scripts_block/rm_dc_user_scripts"  ;#  Additional search path to be added to the default search path

set TARGET_LIBRARY_FILES          "
${DESIGN_REF_DATA_PATH}/library/std/db/ts16ncfslogl20hdh090f_ssgnp0p72vn40c.db
"  ;#  Target technology logical libraries

set ADDITIONAL_LINK_LIB_FILES     []

set MIN_LIBRARY_FILES             ""  ;#  List of max min library pairs "max1 min1 max2 min2 max3 min3"...

set MW_REFERENCE_LIB_DIRS         "
${DESIGN_REF_DATA_PATH}/library/std/mw/ts16ncfslogl20hdl090f.mwdb
${DESIGN_REF_DATA_PATH}/library/std/mw/ts16ncfllogl20hdl090f.mwdb
${DESIGN_REF_DATA_PATH}/library/std/mw/ts16ncfslogl20hdh090f.mwdb
${DESIGN_REF_DATA_PATH}/library/std/mw/ts16ncfllogl20hdh090f.mwdb
${DESIGN_REF_DATA_PATH}/library/mc/mw/memory.mwdb
"  ;#  Milkyway reference libraries (include IC Compiler ILMs here)

set MW_REFERENCE_CONTROL_FILE     ""  ;#  Reference Control file to define the Milkyway reference libs

set TECH_FILE                     "${DESIGN_REF_DATA_PATH}/library/std/techfile/ts16ncfslogl20hdl090f_m09f2f1f3f0f2f0_UTRDL.tf"
set MAP_FILE                      "${DESIGN_REF_DATA_PATH}/library/std/tluplus/layers.map"
set TLUPLUS_MAX_FILE              "${DESIGN_REF_DATA_PATH}/library/std/tluplus/cln16ffc_1p9m_2xa1xd3xe2z_mim_ut-alrdl_rcworst_CCworst_T.tluplus"
set TLUPLUS_MIN_FILE              ""  ;#  Min TLUplus file

set VERTICAL_ROUTING_LAYER_LIST	   "M3 M5 M7 M9"	;# A list of vertical routing layers; optional; should be defined if missing in tech file
set HORIZONTAL_ROUTING_LAYER_LIST  "M1 M2 M4 M6 M8 AP"	;# A list of horizontal routing layers; optional; should be defined if missing in tech file

set MIN_ROUTING_LAYER            "M2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M7"   ;# Max routing layer

set LIBRARY_DONT_USE_FILE        "dont_use.tcl"   ;# Tcl file with library modifications for dont_use
set LIBRARY_DONT_USE_PRE_COMPILE_LIST ""; #Tcl file for customized don't use list before first compile
set LIBRARY_DONT_USE_PRE_INCR_COMPILE_LIST "";# Tcl file with library modifications for dont_use before incr compile
##########################################################################################
# Multivoltage Common Variables
#
# Define the following multivoltage common variables for the reference methodology scripts 
# for multivoltage flows. 
# Use as few or as many of the following definitions as needed by your design.
##########################################################################################

set PD1                          ""           ;# Name of power domain/voltage area  1
set VA1_COORDINATES              {}           ;# Coordinates for voltage area 1
set MW_POWER_NET1                "VDD1"       ;# Power net for voltage area 1

set PD2                          ""           ;# Name of power domain/voltage area  2
set VA2_COORDINATES              {}           ;# Coordinates for voltage area 2
set MW_POWER_NET2                "VDD2"       ;# Power net for voltage area 2

set PD3                          ""           ;# Name of power domain/voltage area  3
set VA3_COORDINATES              {}           ;# Coordinates for voltage area 3
set MW_POWER_NET3                "VDD3"       ;# Power net for voltage area 3

set PD4                          ""           ;# Name of power domain/voltage area  4
set VA4_COORDINATES              {}           ;# Coordinates for voltage area 4
set MW_POWER_NET4                "VDD4"       ;# Power net for voltage area 4

puts "RM-Info: Completed script [info script]\n"

