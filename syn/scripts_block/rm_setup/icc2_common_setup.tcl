puts "RM-info : Running script [info script]\n"

##########################################################################################
# Tool: IC Compiler II
# Script: icc2_common_setup.tcl
# Version: M-2016.12-SP4 (July 17, 2017)
# Copyright (C) 2014-2017 Synopsys, Inc. All rights reserved.
##########################################################################################

##########################################################################################
## Required variables
## These variables must be correctly filled in for the flow to run properly
##########################################################################################
set DESIGN_NAME 		"nvdla"	;# Name of the design to be worked on
set DESIGN_LIBRARY 		"${DESIGN_NAME}.nlib" ;# Name of the design library, default is ${DESIGN_NAME}.nlib

set COMPRESS_LIBS       "true" ;# Save libs as compressed NDM

set LIB_PATH     /u/stars/testcases/9001320134/library
set REFERENCE_LIBRARY 	[list \
                 $LIB_PATH/std/ndm/ts16ncfslogl20hdl090f.ndm \
                 $LIB_PATH/std/ndm/ts16ncfllogl20hdl090f.ndm \
                 $LIB_PATH/std/ndm/ts16ncfslogl20hdh090f.ndm \
                 $LIB_PATH/std/ndm/ts16ncfllogl20hdh090f.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p128x12m4b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p128x64m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p128x66m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p128x6m4b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p256x16m4b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p256x4m4b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p256x64m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p256x66m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p256x8m4b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p512x128m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/saculs0c4l2p80x18m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p128x60m2b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p16x64m1b1w0c1p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p20x16m1b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p60x84m1b1w0c0p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p64x128m1b1w0c1p0d0t0s2z1rw00.ndm \
                 /u/stars/testcases/9001351755/work/rtl/nv_medium_1024_full/mc/ndm/sadrls0c4l2p64x64m1b1w0c1p0d0t0s2z1rw00.ndm \
                             ]	;# A list of reference libraries for the design library.	
				       	;# For hierarchical designs using bottom-up flows, include subblock design libraries in the list;
					;# for hierarchical designs using ETMs, include the ETM library in the list.
					;# If unpack_rm_dirs.pl is used to create dir structures for hierarchical designs, in order to transition between
					;# hierarchical DP and hierarchical PNR flows properly, absolute paths are a requirement.

set VERILOG_NETLIST_FILES	"./outputs/dc/nvdla.mapped.v"	;# Verilog netlist files;
					;# 	for DP: required
					;# 	for PNR: required if INIT_DESIGN_INPUT is ASCII in icc2_pnr_setup.tcl; not required for DC_ASCII or DP_RM_NDM

set UPF_FILE 			"./inputs/nvdla.upf"	;# A UPF file
					;# 	for DP: required
					;# 	for PNR: required if INIT_DESIGN_INPUT is ASCII in icc2_pnr_setup.tcl; not required for DC_ASCII or DP_RM_NDM

set TCL_PARASITIC_SETUP_FILE	""	;# Specify a Tcl script to read in your TLU+ files by using the read_parasitic_tech command;
					;# refer to the example in read_parasitic_tech_example.tcl 

set TCL_MCMM_SETUP_FILE		"./scripts_block/rm_icc2_user_scripts/create_scenario.tcl"	;# Specify a Tcl script to create your corners, modes, scenarios and load respective constraints;
					;# two examples are provided in rm_icc2_pnr_scripts: 
					;# mcmm_example.explicit.tcl: provide mode, corner, and scenario constraints; create modes, corners, 
					;# and scenarios; source mode, corner, and scenario constraints, respectively 
					;# mcmm_example.auto_expanded.tcl: provide constraints for the scenarios; create modes, corners, 
					;# and scenarios; source scenario constraints which are then expanded to associated modes and corners
					;# 	for DP: required
					;# 	for PNR: required if INIT_DESIGN_INPUT is ASCII in icc2_pnr_setup.tcl; not required for DC_ASCII or DP_RM_NDM

set TECH_FILE 			"/u/stars/testcases/9001320134/library/std/techfile/ts16ncfslogl20hdl090f_m09f2f1f3f0f2f0_UTRDL.tf"
					;# TECH_FILE is recommended, although TECH_LIB is also supported in ICC2 RM. 
set TECH_LIB			""	;# Specify the reference library to be used as a dedicated technology library;
                        		;# as a best practice, please list it as the first library in the REFERENCE_LIBRARY list 
set TECH_LIB_INCLUDES_TECH_SETUP_INFO true 
					;# Indicate whether TECH_LIB contains technology setup information such as routing layer direction, offset, 
					;# site default, and site symmetry, etc. TECH_LIB may contain this information if loaded during library prep.
					;# true|false; this variable is associated with TECH_LIB. 
set TCL_TECH_SETUP_FILE		"./scripts_block/rm_icc2_pnr_scripts/tech_setup.tcl"
					;# Specify a TCL script for setting routing layer direction, offset, site default, and site symmetry list, etc.
					;# tech_setup.tcl is the default. Use it as a template or provide your own script.
					;# This script will only get sourced if the following conditions are met: 
					;# (1) TECH_FILE is specified (2) TECH_LIB is specified && TECH_LIB_INCLUDES_TECH_SETUP_INFO is false 
set ROUTING_LAYER_DIRECTION_OFFSET_LIST "{M0 horizontal 0} {M1 vertical 0} {M2 horizontal 0} {M3 vertical 0} {M4 horizontal 0} {M5 vertical 0} {M6 horizontal 0} {M7 vertical 0} {M8 horizontal 0} {M9 vertical 0} {AP horizontal 0}" 
					;# Specify the routing layers as well as their direction and offset in a list of space delimited pairs;
					;# This variable should be defined for all metal routing layers in technology file;
					;# Syntax is "{metal_layer_1 direction offset} {metal_layer_2 direction offset} ...";
					;# It is required to at least specify metal layers and directions. Offsets are optional. 
					;# Example1 is with offsets specified: "{M1 vertical 0.2} {M2 horizontal 0.0} {M3 vertical 0.2}"
					;# Example2 is without offsets specified: "{M1 vertical} {M2 horizontal} {M3 vertical}"

##########################################################################################
## Optional variables
## Specify these variables if the corresponding functions are desired 
##########################################################################################
set DESIGN_LIBRARY_SCALE_FACTOR	""	;# Specify the length precision for the library. Length precision for the design
					;# library and its ref libraries must be identical. Tool default is 10000, which
					;# implies one unit is one Angstrom or 0.1nm.

set UPF_UPDATE_SUPPLY_SET_FILE	""	;# A UPF file to resolve UPF supply sets

set DEF_FLOORPLAN_FILES		"../fp/nvdla.0820.def"	;# DEF files which contain the floorplan information;
					;# 	for DP: not required
					;# 	for PNR: required if INIT_DESIGN_INPUT = ASCII in icc2_pnr_setup.tcl and neither TCL_FLOORPLAN_FILE or 
					;#		 initialize_floorplan is used; DEF_FLOORPLAN_FILES and TCL_FLOORPLAN_FILE are mutually exclusive;
					;# 	         not required if INIT_DESIGN_INPUT = DC_ASCII or DP_RM_NDM

set DCG_SPG_DEF_FILE    "./outputs/dc/nvdla.mapped.std_cell.def"
set DEF_SCAN_FILE		"./outputs/dc/nvdla.mapped.scandef"	;# A scan DEF file for scan chain information;
					;# 	for PNR: not required if INIT_DESIGN_INPUT = DC_ASCII or DP_RM_NDM, as SCANDEF is expected to be loaded already

set DEF_SITE_NAME_PAIRS		{}	;# A list of site name pairs for read_def -convert; 
					;# specify site name pairs with from_site first followed by to_site;
					;# Example: set DEF_SITE_NAME_PAIRS {{from_site_1 to_site_1} {from_site_2 to_site_2}} 	

set SITE_DEFAULT	"unit"		;# Specify the default site name if there are multiple site defs in the technology file;
					;# this is to be used by initialize_floorplan command; example: set SITE_DEFAULT "unit";
					;# this is applied in the tech_setup.tcl script 
set SITE_SYMMETRY_LIST	"{unit Y}"		;# Specify a list of site def and its symmetry value; 
					;# this is to be used by read_def or initialize_floorplan command to control the site symmetry;
					;# example: set SITE_SYMMETRY_LIST "{unit Y} {unit1 Y}"; this is applied in the tech_setup.tcl script 

set MIN_ROUTING_LAYER		"M2"	;# Min routing layer name; normally should be specified; otherwise tool can use all metal layers  
set MAX_ROUTING_LAYER		"M7"	;# Max routing layer name; normally should be specified; otherwise tool can use all metal layers

set LINK_LIBRARY		""	;# Specify logical link libraries, ie, db files;
					;# required only if you run VC-LP (vc_lp.tcl) and Formality (fm.tcl)

set MEM_USEFUL_SKEW_FILE        ""      ;# Define the memory useful skew file for place_opt and CTS step use

##########################################################################################
## Variables related to flow controls of flat PNR, hierarchical PNR and transition with DP
##########################################################################################
set DESIGN_STYLE		"flat"	;# Specify the design style; flat|hier; default is flat; 
					;# specify flat for a totally flat flow (flat PNR for short) and 
					;# specify hier for a hierarchical flow (hier PNR for short);
					;# 	for hier PNR: required and auto set if unpack_rm_dirs.pl is used; (see README.unpack_rm_dirs.txt for details)
					;# 	for flat PNR: this should set to flat (default)
					;#	for DP: not used 

set PHYSICAL_HIERARCHY_LEVEL	"" 	;# Specify the current level of hierarchy for the hierarchical PNR flow; top|intermediate|bottom;
					;# 	for hier PNR: required and auto set if unpack_rm_dirs.pl is used; (see README.unpack_rm_dirs.txt for details)
					;# 	for flat PNR and for DP: not used.

set RELEASE_DIR_DP		"" 	;# Specify the release directory of DP RM; 
					;# this is where init_design.tcl of PNR flow gets DP RM released libraries; 
					;# 	for hier PNR: required and auto set if unpack_rm_dirs.pl is used; (see README.unpack_rm_dirs.txt for details)
					;# 	for flat PNR: required if INIT_DESIGN_INPUT = DP_RM_NDM, as init_design.tcl needs to know where DP RM libraries are
					;#	for DP: not used 
set RELEASE_LABEL_NAME_DP 	"for_pnr"	
					;# Specify the label name of the block in the DP RM released library;
					;# this is the label name which init_design.tcl of PNR flow will open. 

set RELEASE_DIR_PNR		"" 	;# Specify the release directory of PNR RM; 
					;# this is where the init_design.tcl of hierarchical PNR flow gets the sub-block libraries;	
					;# 	for hier PNR: required and auto set if unpack_rm_dirs.pl is used; (see README.unpack_rm_dirs.txt for details)
					;# 	for flat PNR and for DP: not used.

##########################################################################################
## Variables related to In-design PrimeRail
##########################################################################################
set PRIMERAIL_SEARCH_PATH	""  	;# Required.  Additional search path to be added to the default search path.

set PRIMERAIL_MAP_FILE		""  	;# Required.  Mapping file for TLUplus.
set PRIMERAIL_TLUPLUS_FILE	""  	;# Required. TLUplus file for extraction.

set PRIMERAIL_PARASITIC_CORNER	"current_corner"   ; # set corner for parasitic extraction. Default corner is "current_corner"
set PRIMERAIL_POWER_NET1	""	;# Required.  Power net 1
set PRIMERAIL_POWER_NET2	""	;# Power net 2
set PRIMERAIL_POWER_NET3	""	;# Power net 3
set PRIMERAIL_GROUND_NET1	""	;# Required.  Ground net 1
set PRIMERAIL_GROUND_NET2	""	;# Ground net 2
set PRIMERAIL_GROUND_NET3	""	;# Ground net 3

puts "RM-info : Completed script [info script]\n"

