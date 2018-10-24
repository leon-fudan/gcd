puts "RM-info : Running script [info script]\n"
##########################################################################################
# Tool: IC Compiler II
# Script: icc2_flat_setup.tcl
# Version: M-2016.12-SP4 (July 17, 2017)
# Copyright (C) 2014-2017 Synopsys, Inc. All rights reserved.
##########################################################################################

source -echo ./scripts_block/rm_setup/icc2_common_setup.tcl 

########################################################################################## 
## Variables for design inputs (used by init_design.tcl)
##########################################################################################
set INIT_DESIGN_INPUT "ASCII"	;# Specify one of the 3 available options: ASCII | DC_ASCII | DP_RM_NDM; default is ASCII.
				;# 1.ASCII: assumes all design input files are ASCII and will read them in individually.
				;# 2.DC_ASCII: should be used when transferring a design from DC using the write_icc2_files command;
				;#   sources ${DCRM_RESULTS_DIR}/${DCRM_FINAL_DESIGN_ICC2}/${DESIGN_NAME}.icc2_script.tcl;
			      	;#   you can change the default of DC_RESULTS_DIR and DCRM_FINAL_DESIGN_ICC2 below.  
			      	;# 3.DP_RM_NDM: if ICC2-DP-RM is completed, you can take its NDM outputs and skip the design creation steps;
				;#   for PNR flat (DESIGN_STYLE set to flat), script copies the design library from ICC2-DP-RM release 
				;#   area (specified by RELEASE_DIR_DP) and opens design;    
				;#   for PNR hier flow (DESIGN_STYLE set to hier), script will either copy design library 
				;#   from ICC2-DP-RM release area or in addition to that, copy design library of the child blocks from PNR
				;#   release area (specified by RELEASE_DIR_PNR), and then open design.    

set DCRM_RESULTS_DIR  "./ouptputs/dc/" 	;# Used by DC_ASCII to specify DC-RM output directory. Default is results.   
set DCRM_FINAL_DESIGN_ICC2 "ICC2_files" ;# Used by DC_ASCII to specify the output directory generated from DC-RM's write_icc2_files command.
                                        ;# The directory contains verilog, floorplan, scenario settings, and constraints from DC
                                        ;# in a format that IC Compiler II can source.

set POCV_CORNER_FILE_MAPPING_LIST ""	;# Specify a list of corner and its associated POCV file in pairs, as POCV is corner dependant;
					;# same corner can have multiple corresponding files;
					;# example: set POCV_CORNER_FILE_MAPPING_LIST "{corner1 file1a} {corner1 file1b} {corner2 file2}";
					;# in the example, file1a and file1b will be loaded for corner1, file2 will be loaded for corner2.
					;# Note: POCV_CORNER_FILE_MAPPING_LIST will take precedence if AOCV_CORNER_TABLE_MAPPING_LIST is also specified

set AOCV_CORNER_TABLE_MAPPING_LIST [list \
                    {rcworst_T_ssgnp0p72v125c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdh090f_ssgnp0p72vn40c.aocv } \
                    {rcworst_T_ssgnp0p72v125c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdl090f_ssgnp0p72vn40c.aocv } \
                    {rcworst_T_ssgnp0p72v125c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdh090f_ssgnp0p72vn40c.aocv } \
                    {rcworst_T_ssgnp0p72v125c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdl090f_ssgnp0p72vn40c.aocv } \
                    {ccworst_ssgnp0p72vm40c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdh090f_ssgnp0p72vn40c.aocv } \
                    {ccworst_ssgnp0p72vm40c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdl090f_ssgnp0p72vn40c.aocv } \
                    {ccworst_ssgnp0p72vm40c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdh090f_ssgnp0p72vn40c.aocv } \
                    {ccworst_ssgnp0p72vm40c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdl090f_ssgnp0p72vn40c.aocv } \
                    {typical_tt0p8v85c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdh090f_tt0p8v85c.aocv } \
                    {typical_tt0p8v85c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfllogl20hdl090f_tt0p8v85c.aocv } \
                    {typical_tt0p8v85c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdh090f_tt0p8v85c.aocv } \
                    {typical_tt0p8v85c /u/stars/testcases/9001320134/library/std/aocv/ts16ncfslogl20hdl090f_tt0p8v85c.aocv } \
];# Specify a list of corner and its associated AOCV table in pairs, as AOCV is corner dependant;
					;# same corner can have multiple corresponding tables;
					;# example: set AOCV_CORNER_TABLE_MAPPING_LIST "{corner1 table1a} {corner1 table1b} {corner2 table2}";
					;# in the example, table1a and table1b will be loaded for corner1, table2 will be loaded for corner2.

set TCL_PAD_CONSTRAINTS_FILE	""	;# A Tcl script for your pad constraint commands used by place_io of 
					;# init_design_flat_design_planning_example.tcl sourced by init_design.tcl

set TCL_MV_SETUP_FILE		""	;# A Tcl script placeholder for your MV setup commands,such as create_voltage_area, 
					;# placement bound, power switch creation and level shifter insertion, etc   

set TCL_PG_CREATION_FILE	""	;# A Tcl script placeholder for your power ground network creation commands,
					;# such as create_pg*, set_pg_strategy, compile_pg, etc;
set CREATE_IO_PATH_GROUPS	true	;# Set enable_io_path_groups to true to create input to reg, reg to output, and input to output path groups 

set TCL_FLOORPLAN_FILE		""	;# Specify the Tcl floorplan file written by the write_floorplan; for example, floorplan/floorplan.tcl;
					;# TCL_FLOORPLAN_FILE and DEF_FLOORPLAN_FILES are mutually exclusive; please specify only one of them;
					;# Not effective if INIT_DESIGN_INPUT = DC_ASCII or DP_RM_NDM.
					;# The write_floorplan command writes a floorplan.tcl Tcl script and a floorplan.def DEF file;
					;# reading floorplan.tcl alone can restore the entire floorplan - refer to write_floorplan man for more details  
set TCL_ADDITIONAL_FLOORPLAN_FILE ""	;# A supplementary Tcl constraint file; sourced after DEF_FLOORPLAN_FILE or TCL_FLOORPLAN_FILE is read, 
					;# or initialize_floorplan is done; can be used to cover additional floorplan constructs, 
					;# such as bounds, pin guides, or route guides, etc;
					;# Not effective if INIT_DESIGN_INPUT = DC_ASCII or DP_RM_NDM.
					  
set TCL_USER_INIT_DESIGN_POST_SCRIPT "./scripts_block/rm_icc2_user_scripts/post_init_design.tcl" 	;# An optional Tcl file to be sourced at the very end of init_design.tcl before save_block.

########################################################################################## 
## Variables for ICC2 settings used across stages (such as but not limited to settings.common.opt.tcl)
##########################################################################################
set OPTIMIZATION_FLOW 			"hc" ;# ttr|qor|hplp|arlp|hc (lower case); default is qor; choose among the 5 flows and specify only one;
					;# ttr - for early netlist pipe-cleaning with minimum high effort settings; 
					;# qor - starting point when your netlist is more finalized;
					;#       with more QoR-oriented but run time intensive settings enabled;  
					;# hplp - for high-performance low power design styles;
					;# arlp - for area-reduction focused low power design styles;
					;# hc - for high-connectivity design styles 


set PREROUTE_TIMING_OPTIMIZATION_EFFORT_HIGH $OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true
					;# sets opt.timing.effort to high to enable higher effort timing optimization in preroute;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:true|hplp:true|arlp:true|hc:true

set PREROUTE_TNS_DRIVEN_PLACEMENT 	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true
					;# sets place.coarse.tns_driven_placement to true to make timing-driven placer to optimize TNS instead of WNS;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true

set PREROUTE_LAYER_OPTIMIZATION 	false ;# $OPTIMIZATION_FLOW|false|true
					;# sets place_opt/refine_opt/clock_opt.flow.optimize_layers to true to enable layer optimization;
 					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:true|hplp:false|arlp:false|hc:false
set PREROUTE_LAYER_OPTIMIZATION_CRITICAL_RANGE	"" ;# Specify a float between 0 and 1; default is not specified and tool default remains;
						   ;# sets place_opt.flow.optimize_layers_critical_range to the specified value
set PREROUTE_NDR_OPTIMIZATION false	;# Default false; enables NDR optimization
					;# if true, sets place_opt/clock_opt/refine_opt.flow.optimize_ndrs to true

set PREROUTE_POWER_OPTIMIZATION_MODE	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|leakage|total|none; 
					;# sets opt.power.mode to the specified type; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:leakage|qor:total|hplp:total|arlp:total|hc:total  
set PREROUTE_POWER_OPTIMIZATION_EFFORT	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|low|medium|high;
					;# sets opt.power.effort to the specified effort; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:low|qor:medium|hplp:high|arlp:high|hc:high
set PREROUTE_LOW_POWER_PLACEMENT 	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;
					;# sets place.coarse.low_power_placement to true to make placement power-aware and driven by nets switching activity;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:false

set PREROUTE_AREA_RECOVERY_EFFORT 	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|low|medium|high|ultra;
					;# sets app option opt.area.effort to trade off between TNS and area; higher effort degrades TNS more; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:low|qor:medium|hplp:high|arlp:ultra|hc:high
set PREROUTE_BUFFER_AREA_EFFORT 	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|low|medium|high|ultra;
					;# sets app option opt.common.buffer_area_effort to reduce buffer area usage in data path optimization; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:low|qor:low|hplp:ultra|arlp:ultra|hc:ultra
set PREROUTE_ROUTE_AWARE_ESTIMATION	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets opt.common.use_route_aware_estimation to true to use layer-aware parasitics in preroute extraction; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true

set PREROUTE_PLACEMENT_DETECT_CHANNEL	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place.coarse.channel_detect_mode to true to enable channel detect mode in coarse placement;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true
set PREROUTE_PLACEMENT_DETECT_DETOUR	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place.coarse.detect_detours to true to enable detour detection during coarse placement; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true

set PREROUTE_PLACEMENT_AUTO_DENSITY	true ;# Default true; true|false;	
					;# sets place.coarse.auto_density_control to enable automatic density control for the coarse placement
					;# if $PREROUTE_PLACEMENT_MAX_DENSITY is left unspecified (which means place.coarse.max_density is 0),
					;# this feature selects an appropriate value for the maximum cell density
set PREROUTE_PLACEMENT_MAX_DENSITY	"" ;# Default unspecified; specify a float value between 0 and 1; 	
					;# If specified, sets place.coarse.max_density to limit local density to be less than the value.
					;# if left unspecified, place.coarse.max_density remains at tool default 0; 
					;# now if $PREROUTE_PLACEMENT_AUTO_DENSITY is also true, tool will auto determine a appropriate value; 
					;# while if $PREROUTE_PLACEMENT_AUTO_DENSITY is false, tool will try to spread cells evenly
set PREROUTE_PLACEMENT_TARGET_ROUTING_DENSITY "" ;# Default unspecified; specify a float value between 0 and 1;	
					;# sets place.coarse.target_routing_density to control target routing density for congestion-driven placement; 
					;# if left unspecified, place.coarse.target_routing_density remains at tool default 0 
set PREROUTE_PLACEMENT_MAX_UTIL		"" ;# Default unspecified; specify a float value between 0 and 1;
					;# sets place.coarse.congestion_driven_max_util to control how densely the tool can pack cells in uncongested 
					;# regions, in order to remove congestion in congested regions
					;# if left unspecified, place.coarse.congestion_driven_max_util remains at tool default 0.93 
set PREROUTE_PLACEMENT_PRECLUSTER	true ;# Default true; true|false;
					;# sets app option place.coarse.precluster to enable the preclustering in coarse placement   
set PREROUTE_PLACEMENT_PIN_DENSITY_AWARE false ;# Default false; false|true;	
					;# sets app option place.coarse.pin_density_aware to control maximum local pin density; 
set PREROUTE_PLACEMENT_STREAM_LEGALIZER $OPTIMIZATION_FLOW  ;# $OPTIMIZATION_FLOW|false|true;
					;# sets app option place.legalize.stream_place to enable stream placement which is to replace a single very 
					;# large displacement by a stream of small displacements;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true
set PREROUTE_PLACEMENT_ORIENTATION_OPTIMIZATION $OPTIMIZATION_FLOW  ;# $OPTIMIZATION_FLOW|false|true;
					;# sets app option place.legalize.optimize_orientations to enable legalizer to consider flipping the 
					;# orientations of cells in order to reduce displacements during legalization
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:true|hc:true

set TCL_PLACEMENT_SPACING_LABEL_RULE_FILE "" ;# A file to specify your placement spacing labels and rules.

set TCL_NON_CLOCK_NDR_RULES_FILE ""	;# Specify a NDR rules file for signal nets; sourced in settings.common.opt.tcl

set TCL_USER_CONNECT_PG_NET_SCRIPT ""	;# An optional Tcl file for customized connect_pg_net command and options, such as for bias pins of cells added by opto;
					;# sourced by all the main scripts prior to the save_block command

set TCL_LIB_CELL_PURPOSE_FILE 		"set_lib_cell_purpose.tcl" ;# A Tcl file which applies lib cell purpose related restrictions;
					;# by default RM sources set_lib_cell_purpose.tcl which includes the following restrictions, each controlled by
					;# an individual variable :
					;# dont use cells (TCL_LIB_CELL_DONT_USE_FILE), tie cells (TIE_LIB_CELL_PATTERN_LIST), 
					;# hold fixing (HOLD_FIX_LIB_CELL_PATTERN_LIST), CTS (CTS_LIB_CELL_PATTERN_LIST) and 
					;# CTS-exclusive cells (CTS_ONLY_LIB_CELL_PATTERN_LIST). 
					;# You can also replace it with your own customized script instead of using the set_lib_cell_purpose.tcl.	

## Note : The following 5 variables are all specific to set_lib_cell_purpose.tcl which is the default script for handling lib cell purpose restrictions.
#  If you do not plan to use set_lib_cell_purpose.tcl, you don't have to specify them.
set TCL_LIB_CELL_DONT_USE_FILE "./scripts_block/rm_icc2_user_scripts/tsmc16ffc_dont_use.tcl"	;# A Tcl file for customized don't use ("set_lib_cell_purpose -exclude <purpose>" commands)
set TIE_LIB_CELL_PATTERN_LIST "*/*TIE0_1 */*TIE1_1"	;# A list of TIE lib cell patterns to be included for optimization;
					;# Example : set TIE_LIB_CELL_PATTERN_LIST "*/TIE* */ttt*"
set HOLD_FIX_LIB_CELL_PATTERN_LIST "*/HDB*VT20_BUF_D_* */HDB*VT20_DEL_L4_1"
set CTS_LIB_CELL_PATTERN_LIST 	"*/HDBLVT20_INV_S_6 */HDBLVT20_INV_S_8 */HDBLVT20_INV_S_10 */HDBLVT20_INV_S_14 */HDBLVT20_INV_S_16 */*FSD* */*CKG*" 	;# List of CTS lib cell patterns to be used by CTS; 
					;# please include repeaters, always-on repeaters (for MV-CTS), 
					;# and gates (for sizing pre-existing gates)/always-on buffers;
					;# Please also include flops as CCD can size flops to improve timing.
				   	;# example : set CTS_LIB_CELL_PATTERN_LIST "*/NBUF* */AOBUF* */AOINV* */SDFF*"
set CTS_ONLY_LIB_CELL_PATTERN_LIST "*/HDBLVT20_INV_S_6 */HDBLVT20_INV_S_8 */HDBLVT20_INV_S_10 */HDBLVT20_INV_S_14 */HDBLVT20_INV_S_16" 	      ;# List of CTS lib cell patterns to be used by CTS "exclusively", such as clock specific
					;# buffers and inverters. Please be aware that these cells will be applied with only cts 
					;# purpose and nothing else. If you want to use these lib cells for other purposes, 
					;# such as optimization and hold, specify them in CTS_LIB_CELL_PATTERN_LIST instead

########################################################################################## 
## Variables for placement and place_opt related settings (used by place_opt.tcl and settings.step.place_opt.tcl)
##########################################################################################
set PLACE_OPT_ACTIVE_SCENARIO_LIST	"func:rcworst_T:ssgnp0p72v125c func:ccworst:ssgnp0p72vm40c func:typical:tt0p8v85c" ;# A subset of scenarios to be made active during place_opt step;
					   ;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					   ;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set TCL_USER_PLACE_OPT_PRE_SCRIPT 	"./scripts_block/rm_icc2_user_scripts/pre_place_opt.tcl" ;# An optional Tcl file for place_opt.tcl to be sourced before place_opt.
set TCL_USER_PLACE_OPT_SCRIPT 		"./scripts_block/rm_icc2_user_scripts/place_opt_user.tcl" ;# An optional Tcl file for place_opt.tcl to replace pre-existing place_opt commands.
					   ;# place_opt_example.hplp.tcl is provided as an example script which runs same steps as RM+ hplp and arlp flows
					   ;# place_opt_example.hc.tcl is provided as an example script which runs same steps as RM+ hc flow
set TCL_USER_PLACE_OPT_POST_SCRIPT 	"" ;# An optional Tcl file for place_opt.tcl to be sourced after place_opt.

set PLACE_OPT_SPG_FLOW                  false		;# Default false; enable SPG input handling in place_opt.tcl
set PLACE_OPT_REFINE_OPT 		"none" ;# Default none; set it to refine_opt to run refine_opt;
					;# set it to path_opt to run only "refine_opt -from final_path_opt";
					;# set it to power to run refine_opt with refine_opt.flow.exclusive set to power;
					;# set it to area to run refine_opt with refine_opt.flow.exclusive set to area;
set PLACE_OPT_REFINE_OPT_EFFORT_HIGH	false ;# Default false; set it to true to enable high effort placement during refine_opt

set PLACE_OPT_CONGESTION_EFFORT_HIGH	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place_opt.congestion.effort to high for high congestion alleviation effort in place_opt; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:false|hc:true
set PLACE_OPT_GR_BASED_HFSDRC		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place_opt.initial_drc.global_route_based to 1 to enable GR-based buffering (GRopto) in HFSDRC phase; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:false|hc:true

set PLACE_OPT_DO_PATH_OPT		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place_opt.flow.do_path_opt to true to enable path_opt during place_opt; 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:true|arlp:false|hc:false
set PLACE_OPT_FINAL_PLACE_EFFORT_HIGH	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# true sets place_opt.final_place.effort to high for high effort final coarse placement in place_opt; 
					;# false sets place_opt.final_place.effort to medium; value of $OPTIMIZATION_FLOW will be converted:
					;# ttr:false(medium)|qor:false(medium)|hplp:true(high)|arlp:true(high)|hc:true(high), where the app option
					;# value being set is in parenthesis

set PLACE_OPT_CCD			$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets place_opt.flow.enable_ccd to true to enable place_opt CCD;
					;# if PLACE_OPT_OPTIMIZE_ICGS or PLACE_OPT_TRIAL_CTS is also enabled, useful skew computation is based on propagated clocks;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:false|arlp:false|hc:false
set PLACE_OPT_OPTIMIZE_ICGS 		false ;# false|true; default false; sets place_opt.flow.optimize_icgs to true; 
					;# place_opt will run automatic ICG optimization that performs trial CTS, timing-aware ICG splitting 
					;# and clock-aware placement for critical enable paths.
					;# settings.common.cts.tcl will be sourced before place_opt, instead of clock_opt, in order to
					;# benefit most from trial CTS with as much CTS-related settings applied as possible. 
					;# The aggressiveness of splitting can be controlled by the PLACE_OPT_OPTIMIZE_ICGS_CRITICAL_RANGE variable. 
set PLACE_OPT_OPTIMIZE_ICGS_CRITICAL_RANGE ""   ;# Default empty; specify a value between 0 and 1; 
					;# sets place_opt.flow.optimize_icgs_critical_range to the value specified; tool default is 0.75.
					;# When set to X, only ICGs enable slack within {EN_WNS, EN_WNS*(1-X)} will be considered for splitting;
					;# for example, 0.75 means only ICG with enable pin violations between 1*EN_WNS and 0.25*EN_WNS will be split,
					;# while the ICG enable slack below 0.25*EN_WNS will be skipped. Larger value means more splitting. 
set PLACE_OPT_ICG_AUTO_BOUND		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;								
					;# sets place.coarse.icg_auto_bound to enable use of automatically created group bounds during placement for ICGs and flops; 
					;# This is an optional feature to be enabled in addition to PLACE_OPT_OPTIMIZE_ICGS.
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:false|arlp:false|hc:false
set PLACE_OPT_TRIAL_CTS 		false ;# false|true; default false; enables early clock tree synthesis; sets place_opt.flow.trial_clock_tree to true.
					;# useful for low power placement (PREROUTE_LOW_POWER_PLACEMENT) and ICG optimization flow (PLACE_OPT_OPTIMIZE_ICGS). 
					;# Propagated clocks will be used through-out place_opt flow.
					;# settings.common.cts.tcl will be sourced before place_opt, instead of clock_opt, in order to
					;# benefit most from trial CTS with as much CTS-related settings applied as possible.
					;# Note: when PLACE_OPT_OPTIMIZE_ICGS is set to true, trial CTS will be automatically enabled, 
					;# regardless of the setting of PLACE_OPT_TRIAL_CTS. So you don't have to manually enable it.
set PLACE_OPT_CLOCK_AWARE_PLACEMENT	false ;# false|true; default false; enables placement guided by ICG's enable timing criticality; 
					;# sets place_opt.flow.clock_aware_placement to true. place_opt will try to improve ICG enable timing by placing the 
					;# timing critical ICGs and their fanout cells at better locations for ICG enable paths.
					;# Note: when PLACE_OPT_OPTIMIZE_ICGS is set to true, clock-aware placement will be automatically enabled, 
					;# regardless of the setting of PLACE_OPT_CLOCK_AWARE_PLACEMENT. So you don't have to manually enable it.

set PLACE_OPT_MULTIBIT_BANKING false	;# Default false; enables identify_multibit during place_opt
set PLACE_OPT_MULTIBIT_BANKING_CELL_INSTANCE_LIST "" ;# Specify a list of cell instances only which is considered for grouping;
						     ;# by default identify_multibit considers all cells 
set PLACE_OPT_MULTIBIT_BANKING_EXCLUDED_INSTANCE_LIST "" ;# Specify a list of cell instances to be ignored for grouping
set PLACE_OPT_MULTIBIT_DEBANKING false  ;# Default false; enables split_multibit during place_opt
set PLACE_OPT_MULTIBIT_DEBANKING_CELL_INSTANCE_LIST "" ;# Specify a list of cell instances only which is considered for splitting;
						       ;# by default split_multibit considers all cells 
set PLACE_OPT_MULTIBIT_DEBANKING_EXCLUDED_INSTANCE_LIST "" ;# Specify a list of cell instances to be ignored for splitting

set PLACE_OPT_CLOCK_NDR_RULE_NAME "" 	;# Clock NDR rule name for place_opt congestion modeling.
					;# If you specify your own rule name, rule needs to be created in a prior step, or specify a script to create it,
					;# through variable TCL_PLACE_OPT_CLOCK_NDR_RULE_FILE. The file will be sourced, and rule gets associated.
					;# If you specify an RM predefined rule, rule will be auto created and then associated.
					;# Below are the 3 predefined rules which you can use:  
					;# icc2rm_2w2s : double width double spacing 
					;# icc2rm_2w2s_shield_default : double width double spacing + shielding with default width and spacing
					;# icc2rm_2w2s_shield_list : double width double spacing + shielding with customized per layer width and 
					;# spacing which requires PLACE_OPT_CLOCK_NDR_SHIELDING_LAYER_WIDTH_LIST or PLACE_OPT_CLOCK_NDR_SHIELDING_LAYER_SPACING_LIST
set PLACE_OPT_CLOCK_NDR_SHIELDING_LAYER_WIDTH_LIST ""
					;# A list of {layer_name shield_width ...} for $PLACE_OPT_CLOCK_NDR_RULE_NAME; 
					;# required if you specify icc2rm_2w2s_shield_list for for $PLACE_OPT_CLOCK_NDR_RULE_NAME.
set PLACE_OPT_CLOCK_NDR_SHIELDING_LAYER_SPACING_LIST ""
					;# A list of {layer_name shield_spacing ...} for $PLACE_OPT_CLOCK_NDR_RULE_NAME; 
					;# required if you specify icc2rm_2w2s_shield_list for $PLACE_OPT_CLOCK_NDR_RULE_NAME.
set PLACE_OPT_CLOCK_NDR_NET_LIST ""	;# A list of nets for set_routing_rule command which $PLACE_OPT_CLOCK_NDR_RULE_NAME will be applied to.
					;# If not specified, by default, all clock nets will be specified. 
set TCL_PLACE_OPT_CLOCK_NDR_RULE_FILE ""	;# Optionally provide a script for NDR creation if you specify your own NDR rule name for PLACE_OPT_CLOCK_NDR_RULE_NAME
set PLACE_OPT_CLOCK_NDR_MIN_ROUTING_LAYER ""	;# Min clock routing layer for set_routing_rule command which $PLACE_OPT_CLOCK_NDR_RULE_NAME will be applied to. 
set PLACE_OPT_CLOCK_NDR_MAX_ROUTING_LAYER ""	;# Max clock routing layer for set_routing_rule command which $PLACE_OPT_CLOCK_NDR_RULE_NAME will be applied to.

set PLACE_OPT_CONTINUE_ON_MISSING_SCANDEF false ;# false|true, specify whether to allow coarse placement to continue,
					;# if there are SCAN FFs in the netlist but without SCANDEF loaded in the design;
					;# sets place.coarse.continue_on_missing_scandef to false|true; tool default is false.
						 

set SAIF_FILE			""      ;# Specify a SAIF file for accurate power computation for features such as
					;# PREROUTE_POWER_OPTIMIZATION_MODE total and PREROUTE_LOW_POWER_PLACEMENT.
set SAIF_FILE_POWER_SCENARIO	""	;# SAIF_FILE related; specify a power scenario where the SAIF is to be applied
set SAIF_FILE_SOURCE_INSTANCE	""	;# SAIF_FILE related; name of the instance of the current design as it appears in SAIF file.
set SAIF_FILE_TARGET_INSTANCE	""	;# SAIF_FILE related; name of the target instance on which activity is to be annotated.


########################################################################################## 
## Variables for common CTS related settings (used by settings.common.cts.tcl)
##########################################################################################
## Note : CTS_LIB_CELL_PATTERN_LIST and CTS_ONLY_LIB_CELL_PATTERN_LIST are defined in the "Variables for ICC2 settings used across stages" section above
set CTS_DONT_TOUCH_CELL_LIST	""	;# List of clock cell instances that should not be optimized by CTS.
                                  	;# example : set CTS_DONT_TOUCH_CELL_LIST "cellx celly ..."
set CTS_DONT_BUFFER_NET_LIST	""	;# List of clock nets that should not be buffered by CTS.
                                  	;# example : set CTS_DONT_BUFFER_NET_LIST "net1 net2 net3 ..."
set CTS_SIZE_ONLY_CELL_LIST	""	;# List of clock cell instances to be set as size_only for CTS (sizing only).
                                	;# example : set CTS_SIZE_ONLY_CELL_LIST "cellx celly ..."

## The following *CTS_NDR* variables are related to CTS_NDR_RULE_NAME to be applied on root/internal nets
#  They are only effective if CTS_NDR_RULE_NAME is specified
set CTS_NDR_RULE_NAME		"icc2rm_2w2s"	;# Clock NDR rule name for root and internal nets. Specify your own rule name, or the RM predefined rules.
					;# If you specify your own rule name, rule needs to be created in a prior step, or specify a script to create it,
					;# through variable TCL_CTS_NDR_RULE_FILE. The file will be sourced, and rule applied to root and internal nets.
					;# If you specify an RM predefined rule, rule will be auto created and then applied to root and internal nets.
					;# Below are the 3 predefined rules which you can use:  
					;# icc2rm_2w2s : double width double spacing 
					;# icc2rm_2w2s_shield_default : double width double spacing + shielding with default width and spacing
					;# icc2rm_2w2s_shield_list : double width double spacing + shielding with customized per layer width and 
					;# 			     spacing which requires CTS_NDR_SHIELDING_LAYER_WIDTH_LIST
 
set CTS_NDR_SHIELDING_LAYER_WIDTH_LIST "" ;# A list of {layer_name shield_width ...} for $CTS_NDR_RULE_NAME; 
					;# required if you specify icc2rm_2w2s_shield_list for for $CTS_NDR_RULE_NAME.
set CTS_NDR_SHIELDING_LAYER_SPACING_LIST "" ;# A list of {layer_name shield_spacing ...} for $CTS_NDR_RULE_NAME; 
					;# required if you specify icc2rm_2w2s_shield_list for $CTS_NDR_RULE_NAME.

set TCL_CTS_NDR_RULE_FILE 	""	;# Optionally provide a script for NDR creation if you specify your own NDR rule name for CTS_NDR_RULE_NAME
set CTS_NDR_MIN_ROUTING_LAYER	"M5"	;# Min clock routing layer for set_clock_routing_rules command which $CTS_NDR_RULE_NAME will be applied to. 
set CTS_NDR_MAX_ROUTING_LAYER	"M7"	;# Max clock routing layer for set_clock_routing_rules command which $CTS_NDR_RULE_NAME will be applied to.

## The following *CTS_LEAF_NDR* variables are related to CTS_LEAF_NDR_RULE_NAME to be applied to sink nets 
#  They are only effective if CTS_LEAF_NDR_RULE_NAME is specified

set CTS_LEAF_NDR_RULE_NAME 	""	;# Clock NDR rule name for leaf nets.
					;# If you specify your own rule name, rule needs to be created in a prior step, or specify a script to create it,
					;# through variable TCL_CTS_LEAF_NDR_RULE_FILE. The file will be sourced, and rule applied to leaf nets.
					;# If you specify an RM predefined rule, rule will be auto created and then applied to leaf nets. 
					;# icc2rm_leaf is the predefined rule with default reference rule
set TCL_CTS_LEAF_NDR_RULE_FILE "" 	;# Optionally specify a script for NDR creation if you specify your own NDR rule name for CTS_LEAF_NDR_RULE_NAME
set CTS_LEAF_NDR_MIN_ROUTING_LAYER 	$CTS_NDR_MIN_ROUTING_LAYER 
					;# Min routing layer for set_clock_routing_rules command which icc2rm_leaf will be applied to.
set CTS_LEAF_NDR_MAX_ROUTING_LAYER 	$CTS_NDR_MAX_ROUTING_LAYER 
					;# Max routing layer for set_clock_routing_rules command which icc2rm_leaf will be applied to.

########################################################################################## 
## Variables for clock_opt related settings (used by settings.step.clock_opt_cts.tcl, clock_opt_cts.tcl, and clock_opt_opto.tcl)
##########################################################################################
set CLOCK_OPT_CTS_ACTIVE_SCENARIO_LIST  "func:rcworst_T:ssgnp0p72v125c func:ccworst:ssgnp0p72vm40c func:typical:tt0p8v85c" ;# A subset of scenarios to be made active during clock_opt_cts step;
					   ;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					   ;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set TCL_USER_CLOCK_OPT_CTS_PRE_SCRIPT 	"./scripts_block/rm_icc2_user_scripts/pre_clock_opt_cts.tcl" ;# An optional Tcl file for clock_opt_cts.tcl to be sourced before clock_opt.
set TCL_USER_CLOCK_OPT_CTS_SCRIPT 	"" ;# An optional Tcl file for clock_opt_cts.tcl to replace pre-existing clock_opt commands.
set TCL_USER_CLOCK_OPT_CTS_POST_SCRIPT 	"" ;# An optional Tcl file for clock_opt_cts.tcl to be sourced after clock_opt.
set TCL_MSCTS_SETUP_FILE		"" ;# Specify a Tcl script for multisource clock tree synthesis (MSCTS) setup and creation,
					   ;# which will be sourced prior to the "clock_opt -from build_clock -to route_clock" command
					   ;# in clock_opt_cts.tcl;
					   ;# two examples are provided in the rm_icc2_pnr_scripts directory : 
					   ;# mscts_example.regular.tcl - regular MSCTS 
					   ;# mscts_example.structural.tcl - structural MSCTS 

set CLOCK_OPT_OPTO_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c func:rcworst_T:ssgnp0p72v125c func:typical:tt0p8v85c func:rcworst:ffgnp0p88v125c" ;# A subset of scenarios to be made active during clock_opt_opto step;
					   ;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					   ;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set CLOCK_OPT_OPTO_USER_INSTANCE_NAME_PREFIX "" ;# Specify the prefix for new cells created by clock_opt final_opto; default "" which means no user prefix
set TCL_USER_CLOCK_OPT_OPTO_PRE_SCRIPT 	"./scripts_block/rm_icc2_user_scripts/pre_clock_opt_opto.tcl" ;# An optional Tcl file for clock_opt_opto.tcl to be sourced before clock_opt.
set TCL_USER_CLOCK_OPT_OPTO_SCRIPT 	"" ;# An optional Tcl file for clock_opt_opto.tcl to replace pre-existing clock_opt commands.
set TCL_USER_CLOCK_OPT_OPTO_POST_SCRIPT "" ;# An optional Tcl file for clock_opt_opto.tcl to be sourced after clock_opt.

set CLOCK_OPT_CCD			false ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets clock_opt.flow.enable_ccd to true to enable clock_opt CCD;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:true|hplp:true|arlp:true|hc:true
set CLOCK_OPT_POWER_RECOVERY		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|auto|power|area|none;
					;# sets clock_opt.flow.enable_clock_power_recovery to auto, power, area, or none, while if set to $OPTIMIZATION_FLOW,
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:auto|qor:auto|hplp:auto|arlp:auto|hc:auto
set CTS_ENABLE_GLOBAL_ROUTE		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets cts.compile.enable_global_route to true to enable global router in CTS to avoid congestion;  
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:false|arlp:false|hc:true
set CLOCK_OPT_OPTO_PLACE_EFFORT_HIGH	$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets clock_opt.place.effort to high to enable high coarse placement effort during clock_opt's final_opto phase;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:false|arlp:false|hc:true
set CLOCK_OPT_OPTO_CONGESTION_EFFORT_HIGH $OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets clock_opt.congestion.effort to high to enable high congestion effort during clock_opt's final_opto phase 
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:false|hplp:false|arlp:false|hc:true
set CLOCK_OPT_GLOBAL_ROUTE_OPT		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|false|true; 
					;# enables Global Route Based Optimization by setting clock_opt.flow.enable_global_route_opt 
					;# and route_opt.flow.enable_power to true, sources routing settings, and runs clock_opt -from global_route_opt;
					;# this feature is added to route_auto.tcl; if enabled, it replaces route_global command;
					;# enabled when CLOCK_OPT_GLOBAL_ROUTE_OPT is set to true, or if OPTIMIZATION_FLOW is set to hplp, or arlp 

set CLOCK_OPT_OPTO_CTO 			false ;# Default false; enables post-route clock tree optimization in clock_opt_opto.tcl
set CLOCK_OPT_OPTO_CTO_USER_INSTANCE_NAME_PREFIX "" ;# Specify the prefix for new cells created by CTO; default "" which means no user prefix

########################################################################################## 
## Variables for route_auto and route_opt related settings (used by settings.step.route_opt.tcl, route_auto.tcl, and route_opt.tcl)
##########################################################################################
set ROUTE_AUTO_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c func:rcworst_T:ssgnp0p72v125c func:typical:tt0p8v85c" 	;# A subset of scenarios to be made active during route_auto step;
					;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
## set ROUTE_OPT_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c func:rcworst_T:ssgnp0p72v125c func:rcworst:ffgnp0p72v125c func:typical:tt0p8v85c"	;# A subset of scenarios to be made active during route_opt step;
set ROUTE_OPT_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c func:rcworst_T:ssgnp0p72v125c func:typical:tt0p8v85c func:rcworst:ffgnp0p88v125c"	;# A subset of scenarios to be made active during route_opt step;
					;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set ROUTE_OPT_USER_INSTANCE_NAME_PREFIX "" ;# Specify the prefix for new cells created by route_opt; default "" which means no user prefix
set TCL_USER_ROUTE_AUTO_PRE_SCRIPT "./scripts_block/rm_icc2_user_scripts/preroute.tcl"	;# An optional Tcl file for route_auto.tcl to be sourced before route_auto.
set TCL_USER_ROUTE_AUTO_SCRIPT "" 	;# An optional Tcl file for route_auto.tcl to replace pre-existing routing commands.
set TCL_USER_ROUTE_AUTO_POST_SCRIPT ""	;# An optional Tcl file for route_auto.tcl to be sourced after route_auto.
set TCL_USER_ROUTE_OPT_PRE_SCRIPT ""	;# An optional Tcl file for route_opt.tcl to be sourced before route_opt.
set TCL_USER_ROUTE_OPT_SCRIPT "" 	;# An optional Tcl file for route_opt.tcl to replace pre-existing route_opt commands.
set TCL_USER_ROUTE_OPT_POST_SCRIPT "./scripts_block/rm_icc2_user_scripts/postroute.tcl"	;# An optional Tcl file for route_opt.tcl to be sourced after route_opt.

set ROUTE_OPT_CCD			false ;# $OPTIMIZATION_FLOW|false|true;	
					;# sets route_opt.flow.enable_ccd to true to enable route_opt CCD;
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:false|qor:true|hplp:true|arlp:true|hc:true
set ROUTE_AUTO_ANTENNA_FIXING	false	;# Default false; set true to enable route.detail.hop_layers_to_fix_antenna
					;# and to source TCL_ANTENNA_RULE_FILE in route_auto.tcl to fix Antenna violations.
set TCL_ANTENNA_RULE_FILE	""	;# Antenna rule file; required if ROUTE_AUTO_ANTENNA_FIXING is set to true.

set REDUNDANT_VIA_INSERTION	false	;# Default false; enables redundant via insertion for post-route;
					;# if you choose ESTABLISHED for TECHNOLOGY_NODE on RMgen download page,
					;# the scripts are set up to run concurrent redundant via insertion during route_auto and route_opt
					;# otherwise, the scripts are set up to reserve space and run standalone add_redundant_vias command 
					;# after route_auto and route_opt  
set TCL_USER_REDUNDANT_VIA_MAPPING_FILE "" ;# ICC-II via mapping file required for redundant via insertion; 
					;# the file should include add_via_mapping commands.   
set TCL_USER_ICC_REDUNDANT_VIA_MAPPING_FILE "" ;# ICC style via mapping file required for redundant via insertion; 
					;# the file should include define_zrt_redundant_vias commands.
					;# This variable is mutually exclusive with TCL_USER_REDUNDANT_VIA_MAPPING_FILE
set ROUTE_AUTO_CREATE_SHIELDS		NONE ;# NONE | before_route_auto | after_route_auto: Default is NONE; you can choose to create shields before
					;# or after route_auto; all nets with shielding rules will be shielded	
set ROUTE_OPT_RESHIELD			NONE ;# NONE | after_route_opt | incremental; default is after_route_opt; 
					;# set after_route_opt to reshield nets after route_opt is done with create_shield command; 
					;# set incremental to trigger reshield during all route_opt eco route sessions with an app option; 
					;# note that ROUTE_OPT_RESHIELD only works if ROUTE_AUTO_CREATE_SHIELDS is set to a value other than NONE  

set ROUTE_OPT_LEAKAGE_POWER_OPTIMIZATION true
					;# Default true; enables leakage optimization during route_opt;
					;# sets route_opt.flow.enable_power to true.
set ROUTE_OPT_POWER_RECOVERY		$OPTIMIZATION_FLOW ;# $OPTIMIZATION_FLOW|none|power|area;
					;# sets route_opt.flow.enable_clock_power_recovery to none, power, or area, while if set to $OPTIMIZATION_FLOW,
					;# value of $OPTIMIZATION_FLOW will be converted: ttr:none|qor:none|hplp:power|arlp:power|hc:power

set ROUTE_OPT_CTO false			;# Default false; enables non-CCD flow post-route clock tree optimization in route_opt.tcl
set ROUTE_OPT_CTO_USER_INSTANCE_NAME_PREFIX "" ;# Specify the prefix for new cells created by CTO

set ROUTE_OPT_WITH_STARRC_PT false	;# Default false; enables additional route_opt based on in-design StarRC extraction and PT delay calculation 
					;# in route_opt.tcl; requires ROUTE_OPT_STARRC_CONFIG_FILE (see below)
set ROUTE_OPT_STARRC_CONFIG_FILE ""	;# Specify the configuration file for StarRC in-design extraction for route_opt in route.tcl;
					;# required; refer to route_opt.starrc_in_design_config_example.txt as an example
set ROUTE_OPT_PT_DELAY_CALC_DB_LOCATION "" ;# Specify the paths to .db files of the reference libraries; required by the PT delay calculation setup
					;# if they are in different locations than where NDM libraries are
########################################################################################## 
## Variables for eco_fusion related settings (used by eco_fusion.tcl)
##########################################################################################
set ECO_FUSION_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c func:rcworst_T:ssgnp0p72v125c func:typical:tt0p8v85c"	;# A subset of scenarios to be made active during eco_fusion step;
					;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set ECO_FUSION_USER_INSTANCE_NAME_PREFIX "" ;# Specify the prefix for new cells created by eco_fusion; default "" which means no user prefix
set TCL_USER_ECO_FUSION_PRE_SCRIPT ""	;# An optional Tcl file for eco_fusion.tcl to be sourced before eco_fusion.
set TCL_USER_ECO_FUSION_SCRIPT "" 	;# An optional Tcl file for eco_fusion.tcl to replace pre-existing eco_fusion commands.
set TCL_USER_ECO_FUSION_POST_SCRIPT "./scripts_block/rm_icc2_user_scripts/postroute.tcl"	;# An optional Tcl file for eco_fusion.tcl to be sourced after eco_fusion.
set ECO_FUSION_WITH_STARRC_PT false	;# Default false; enables additional eco_fusion based on in-design StarRC extraction and PT delay calculation 
set ECO_FUSION_STARRC_CONFIG_FILE ""	;# Specify the configuration file for StarRC in-design extraction for eco_fusion in eco_fusion.tcl;

########################################################################################## 
## Variables for signoff DRC related settings (used by signoff_drc.tcl and settings.step.signoff_drc.tcl)
##########################################################################################
set SIGNOFF_DRC_ACTIVE_SCENARIO_LIST ""	;# A subset of scenarios to be made active during chip_finish step;
					;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set TCL_USER_SIGNOFF_DRC_PRE_SCRIPT ""	;# An optional Tcl file for chip_finish.tcl to be sourced before signoff_check_drc.
set TCL_USER_SIGNOFF_DRC_POST_SCRIPT ""	;# An optional Tcl file for chip_finish.tcl to be sourced after second signoff_check_drc.

set SIGNOFF_DRC_RUNSET ""		;# The foundry runset for ICV used by signoff_check_drc and signoff_fix_drc.
set SIGNOFF_DRC_ADR true		;# true|false; true enables signoff_fix_drc in addition to signoff_check_drc; default is true
set SIGNOFF_DRC_DPT_RULES ""		;# Specify your DPT rules for signoff_fix_drc fixing; only takes effect if SIGNOFF_DRC_ADR is true
					;# if specified, signoff_fix_drc -select_rules $SIGNOFF_DRC_DPT_RULES is used instead of signoff_fix_drc 

## Working directories for signoff_check_drc and signoff_fix_drc
set SIGNOFF_DRC_RUNDIR_BEFORE_ADR "z_ADR_before" 
					;# The working directory for signoff_check_drc before signoff_fix_drc;
					;# The directory that contains the initial DRC error database for signoff_fix_drc. 
set SIGNOFF_DRC_RUNDIR_ADR "z_ADR"	;# The working directory for signoff_fix_drc; only takes effect if SIGNOFF_DRC_ADR is true
set SIGNOFF_DRC_RUNDIR_AFTER_ADR "z_ADR_after"	
					;# The working directory for signoff_check_drc after signoff_fix_drc is done; 
					;# only takes effect if SIGNOFF_DRC_ADR is true 

########################################################################################## 
## Variables for chip finishing related settings (used by chip_finish.tcl and settings.step.chip_finish.tcl)
##########################################################################################
set CHIP_FINISH_ACTIVE_SCENARIO_LIST ""	;# A subset of scenarios to be made active during chip_finish step.
					;# once set, the list of active scenarios is saved and carried over to subsequent steps.
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set TCL_USER_CHIP_FINISH_PRE_SCRIPT ""	;# An optional Tcl file for chip_finish.tcl to be sourced before filler cell insertion.
set TCL_USER_CHIP_FINISH_POST_SCRIPT ""	;# An optional Tcl file for chip_finish.tcl to be sourced after metal fill insertion.

## Std cell filler and decap cells used by chip_finish step and post PT-ECO refill in pt_eco step
set CHIP_FINISH_METAL_FILLER_LIB_CELL_LIST ""	;# A list of metal filler (decap) lib cells, including the library name, for ex, 
						;# Example: "hvt/DCAP_HVT lvt/DCAP_LVT". Recommended to specify decaps from large to small.
set CHIP_FINISH_METAL_FILLER_PREFIX ""		;# A string to specify the prefix for metal filler (decap) cells.

set CHIP_FINISH_NON_METAL_FILLER_LIB_CELL_LIST "" ;# A list of non-metal filler lib cells, including the library name, for ex,
                                                ;# Example: hvt/FILL_HVT lvt/FILL_LVT
						;# Recommended to specify them from the largest to smallest especially with advanced rules
set CHIP_FINISH_NON_METAL_FILLER_PREFIX $CHIP_FINISH_METAL_FILLER_PREFIX ;# A string to specify the prefix for non-metal fillers.

## Metal fill
set CHIP_FINISH_CREATE_METAL_FILL false		;# Default false; set it to true to enable the metal fill creation feature.
set CHIP_FINISH_CREATE_METAL_FILL_RUNDIR "z_icvFill" ;# The working directory for signoff_create_metal_fill. Optional. Default is z_icvFill.
set CHIP_FINISH_CREATE_METAL_FILL_TIMING_DRIVEN_THRESHOLD "" ;# Specify the threshold for timing-driven metal fill.
						;# If not specified, timing-driven is not enabled.
						;# If specified, "-timing_preserve_setup_slack_threshold" option is added.

set CHIP_FINISH_CREATE_METAL_FILL_TRACK_BASED "off" ;# off | <a technology node> | generic; used for -track_fill option of signoff_create_metal_fill
						;# for non-track-based : specify off 
						;# for track-based : specify either a node (refer to man page) or generic 
set CHIP_FINISH_CREATE_METAL_FILL_TRACK_BASED_PARAMETER_FILE "auto" ;# auto | <a parameter file>; default is auto;
						;# this variable is only for track-based metal fill;
						;# specify auto to use ICC-II auto generated track_fill_params.rh file or your own paramter file.
set CHIP_FINISH_CREATE_METAL_FILL_RUNSET ""	;# Specify the foundry runset for signoff_create_metal_fill command.
						;# required only for non-track-based (CHIP_FINISH_CREATE_METAL_FILL_TRACK_BASED set to off).
set CHIP_FINISH_SIGNOFF_DRC_RUNDIR_AFTER_METAL_FILL "z_MFILL_after" 
						;# The working directory for signoff_check_drc after signoff_create_metal_fill is completed;
						;# only takes effect if CHIP_FINISH_CREATE_METAL_FILL is true
## Signal EM
set CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FORMAT "ITF" ;# Specify signal EM constraint format: ITF | ALF; string is uppercase and ITF is default
set CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FILE "" 	;# A constraint file which contains signal electromigration constraints;
						;# specify an ITF file if CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FORMAT is set to ITF, and specify an
						;# ALF file if CHIP_FINISH_SIGNAL_EM_CONSTRAINT_FORMAT is set to ALF;
						;# required for signal EM analysis and fixing to be enabled
set CHIP_FINISH_SIGNAL_EM_SAIF ""		;# An optional SAIF file for the signal EM analysis.
set CHIP_FINISH_SIGNAL_EM_SCENARIO ""		;# Specify an active scenario which is enabled for setup and hold analysis;
						;# Required for signal EM analysis and fixing to proceed.
set CHIP_FINISH_SIGNAL_EM_FIXING false		;# Enable signal EM fixing; false | true; false is default 

########################################################################################## 
## Variables for settings related to write data (used by write_data.tcl)
##########################################################################################
set WRITE_GDS_LAYER_MAP_FILE ""				;# A layer map file provides a mapping between the tool and GDS layers;

########################################################################################## 
## Variables for PT ECO related settings (used by pt_eco.tcl/pt_eco_incremental.tcl)
##########################################################################################
## The following variables apply to both pt_eco.tcl (classic PT-ECO flow) and pt_eco_incremental.tcl (Galaxy incremental ECO flow)
set PT_ECO_ACTIVE_SCENARIO_LIST "func:ccworst:ssgnp0p72vm40c" 	;# A subset of scenarios to be made active during the step;
					;# once set, the list of active scenarios is saved and carried over to subsequent steps;
					;# if set to rm_activate_all_scenarios, all scenarios created will be made active
set TCL_USER_PT_ECO_PRE_SCRIPT ""  	;# An optional Tcl file to be sourced before ECO operations.
set TCL_USER_PT_ECO_POST_SCRIPT "./scripts_block/rm_icc2_user_scripts/postroute.tcl" 	;# An optional Tcl file to be sourced after route_eco.
set PT_ECO_DISPLACEMENT_THRESHOLD "10"	;# A float to specify the maximum displacement threshold value for 
					;# place_eco_cells -eco_changed_cells -legalize_mode minimum_physical_impact -displacement_threshold;

## The following variables only apply to pt_eco.tcl (classic PT-ECO flow)
set PT_ECO_CHANGE_FILE "./work/signoff/dmsa_eco_timing_power_physical_TimingECO/func:ccworst:ssgnp0p72vm40c/pt_eco_change_power.tcl"		;# An ECO guidance file generated by the PT-SI write_changes command,
					;# as an input to the pt_eco.tcl
set PT_ECO_MODE	"default"		;# Specify the preferred flow for the PT-ECO run; default|freeze_silicon
					;# default: sources $PT_ECO_CHANGE_FILE and place_eco_cells in MPI mode
					;# freeze_silicon: add_spare_cells, place_eco_cells, sources $PT_ECO_CHANGE_FILE, and place_freeze_silicon
set PT_ECO_SPARE_CELL_PREFIX ""		;# A string to specify the prefix for the spare cells used by add_spare_cells -cell_name option; 
					;# only effective when PT_ECO_MODE is set to freeze_silicon 
set PT_ECO_SPARE_CELL_REF_NUM_LIST ""	;# Specify a list of pairs of space cell library cell name and the number of instances,
					;# which is used by the add_spare_cells -num_cells option;
					;# the valid format is "ref1 num1 ref2 num2 ..."; for example, "andx1 10 norx1 5";
					;# only effective when PT_ECO_MODE is set to freeze_silicon

########################################################################################## 
## Variables for In-design PrimeRail related settings (used by in_design_pnr_rail_analysis.tcl)
##########################################################################################
set PRIMERAIL_DIR ""			;# path to PrimeRail executable.  Required if PrimeRail path is not defined in Unix
set PRIMERAIL_PAD_FILE ""		;# Only for top level design with power pads. Default is empty, and tap points will be used.
set PRIMERAIL_ANALYSIS_NETS "${PRIMERAIL_POWER_NET1} ${PRIMERAIL_GROUND_NET1} ${PRIMERAIL_POWER_NET2} ${PRIMERAIL_GROUND_NET2} ${PRIMERAIL_POWER_NET3} ${PRIMERAIL_GROUND_NET3}" 
					;# target PG net names
set PRIMERAIL_HOST_MACHINE ""		;# hostname for remote run

##########################################################################################
## Miscellaneous Variables
##########################################################################################
set search_path [list ./scripts_block ./scripts_block/n12_side_files ./scripts_block/rm_icc2_pnr_scripts scripts_block/rm_icc2_user_scripts ./scripts_block/rm_setup $PRIMERAIL_SEARCH_PATH ]
lappend search_path .

set_host_options -max_cores 16
## The default number of significant digits used to display values in reports
set_app_options -name shell.common.report_default_significant_digits -value 4 ;# tool default is 2
set sh_continue_on_error true

##########################################################################################
## System Variables (there's no need to change the following)
##########################################################################################
set USE_RM_BLOCK_NAME_AS_LABEL true	;# Specify whether to use RM block name variable as label;
					;# If true, saved name for place_opt.tcl would be ${DESIGN_NAME}/${PLACE_OPT_BLOCK_NAME},
					;# where $PLACE_OPT_BLOCK_NAME becomes the label name of the design while $DESIGN_NAME is
					;# the block name; If false, block name is $PLACE_OPT_BLOCK_NAME without label name.
					;# Note: Hierarchical PNR implementation flow (DESIGN_STYLE set to hier in icc2_common_setup.tcl) 
					;# will not work without user labels being used.
## Block names used by save_block in each of the step
if {$USE_RM_BLOCK_NAME_AS_LABEL} {
# If label is used, the following will be used as label name while $DESIGN_NAME is the block name
set INIT_DESIGN_BLOCK_NAME init_design			;# Name of the block to be saved for init_design.tcl
set PLACE_OPT_BLOCK_NAME place_opt			;# Name of the block to be saved for place_opt.tcl
set CLOCK_OPT_CTS_BLOCK_NAME clock_opt_cts		;# Name of the block to be saved for clock_opt_cts.tcl
set CLOCK_OPT_OPTO_BLOCK_NAME clock_opt_opto		;# Name of the block to be saved for clock_opt_opto.tcl
set ROUTE_AUTO_BLOCK_NAME route_auto			;# Name of the block to be saved for route_auto.tcl
set ROUTE_OPT_BLOCK_NAME route_opt			;# Name of the block to be saved for route_opt.tcl
set ECO_FUSION_BLOCK_NAME eco_fusion                    ;# Name of the block to be saved for route_opt.tcl
set SIGNOFF_DRC_BLOCK_NAME signoff_drc 			;# Name of the block to be saved for signoff_drc.tcl
set CHIP_FINISH_BLOCK_NAME chip_finish			;# Name of the block to be saved for chip_finish.tcl

set WRITE_DATA_BLOCK_NAME write_data			;# Name of the block to be saved for write_data
set PT_ECO_BLOCK_NAME pt_eco				;# Name of the block to be saved for pt_eco.tcl
set PT_ECO_INCREMENTAL_1_BLOCK_NAME pt_eco_incremental_1 ;# Name of the block to be saved for pt_eco_incremental_1.tcl
set PT_ECO_INCREMENTAL_2_BLOCK_NAME pt_eco_incremental_2 ;# Name of the block to be saved for pt_eco_incremental_2.tcl

} else {
# If label is not used, $DESIGN_NAME is added as prefix of the block name; 
# this helps avoid duplicate names among different blocks   
set INIT_DESIGN_BLOCK_NAME ${DESIGN_NAME}_init_design	;# Name of the block to be saved for init_design.tcl
set PLACE_OPT_BLOCK_NAME ${DESIGN_NAME}_place_opt	;# Name of the block to be saved for place_opt.tcl
set CLOCK_OPT_CTS_BLOCK_NAME ${DESIGN_NAME}_clock_opt_cts ;# Name of the block to be saved for clock_opt_cts.tcl
set CLOCK_OPT_OPTO_BLOCK_NAME ${DESIGN_NAME}_clock_opt_opto ;# Name of the block to be saved for clock_opt_opto.tcl
set ROUTE_AUTO_BLOCK_NAME ${DESIGN_NAME}_route_auto	;# Name of the block to be saved for route_auto.tcl
set ROUTE_OPT_BLOCK_NAME ${DESIGN_NAME}_route_opt	;# Name of the block to be saved for route_opt.tcl
set ECO_FUSION_BLOCK_NAME ${DESIGN_NAME}_eco_fusion     ;# Name of the block to be saved for route_opt.tcl
set SIGNOFF_DRC_BLOCK_NAME ${DESIGN_NAME}_signoff_drc 	;# Name of the block to be saved for signoff_drc.tcl
set CHIP_FINISH_BLOCK_NAME ${DESIGN_NAME}_chip_finish	;# Name of the block to be saved for chip_finish.tcl

set WRITE_DATA_BLOCK_NAME ${DESIGN_NAME}_write_data	;# Name of the block to be saved for write_data
set PT_ECO_BLOCK_NAME ${DESIGN_NAME}_pt_eco		;# Name of the block to be saved for pt_eco.tcl
set PT_ECO_INCREMENTAL_1_BLOCK_NAME ${DESIGN_NAME}_pt_eco_incremental_1 ;# Name of the block to be saved for pt_eco_incremental_1.tcl
set PT_ECO_INCREMENTAL_2_BLOCK_NAME ${DESIGN_NAME}_pt_eco_incremental_2 ;# Name of the block to be saved for pt_eco_incremental_2.tcl
}

set WRITE_DATA_FROM_BLOCK_NAME $CHIP_FINISH_BLOCK_NAME 	;# Name of the starting block for write_data.tcl;
							;# default is CHIP_FINISH_BLOCK_NAME; specify a different them if needed
set PT_ECO_FROM_BLOCK_NAME $WRITE_DATA_BLOCK_NAME 	;# Name of the starting block name for pt_eco.tcl;
							;# default is ROUTE_OPT_BLOCK_NAME; specify a different them if needed
set PT_ECO_INCREMENTAL_FROM_BLOCK_NAME $ROUTE_OPT_BLOCK_NAME ;# Name of the starting block for pt_eco_incremental_1.tcl;
							;# default is ROUTE_OPT_BLOCK_NAME; specify a different them if needed
set PRIMERAIL_ANALYSIS_FROM_BLOCK_NAME ""  		;# Name of the starting block for in_design_pnr_rail_analysis.tcl;
							;# required if you want to perform In-design rail analysis 

set REPORT_QOR				true ;# Default true; set to false to skip QoR reporting at end of each step
set REPORT_QOR_SCRIPT "report_qor.tcl" 	;# Default is report_qor.nosplit.tcl; report_qor.nosplit.tcl|report_qor.tcl;
					;# specify report_qor.tcl to use reporting commands without -nosplit options.
set REPORT_QOR_REPORT_POWER		"auto" ;# Default auto; report_power is enabled in report_qor.tcl if OPTIMIZATION_FLOW 
					;# is set to either hplp or arlp; set it to true to enable report_power, and set it
					;# to false to disable report_power
set REPORT_QOR_REPORT_CONGESTION	true ;# Default true; set to false to skip "route_global -congestion_map_only true"
					;# at the end of place_opt, clock_opt_cts, and clock_opt_opto steps.	

## Directories
set OUTPUTS_DIR	"./outputs/icc2"	;# Directory to write output data files; mainly used by write_data.tcl
set REPORTS_DIR	"./rpts/icc2"		;# Directory to write reports; mainly used by report_qor.tcl

if !{[file exists $OUTPUTS_DIR]} {file mkdir -p $OUTPUTS_DIR}
if !{[file exists $REPORTS_DIR]} {file mkdir -p $REPORTS_DIR}

##########################################################################################
## Hierarchical PNR Variables (used by hierarchical PNR implementation)
##########################################################################################
## For designs where the blocks are bound to abstracts
set SUB_BLOCK_REFS                   	[list ] ;# Design names of the physical blocks in all levels of physical hierarchy
                                                ;# Include the blocks that will be bound to abstracts
set USE_ABSTRACTS_FOR_BLOCKS        	[list ] ;# design names of the physical blocks in the next lower level that will be bound to abstracts

## By default, abstracts created after chip_finish step of lower-level are used to implement the current level
## Update the following variables if you want to use abstracts created after any other step 
set BLOCK_ABSTRACT_FOR_PLACE_OPT 	"$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_PLACE_OPT label for place_opt
set BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS    "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CLOCK_OPT_CTS label for clock_opt_cts
set BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO   "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CLOCK_OPT_OPTO label for clock_opt_opto
set BLOCK_ABSTRACT_FOR_ROUTE_AUTO       "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_ROUTE_AUTO label for route_auto
set BLOCK_ABSTRACT_FOR_ROUTE_OPT        "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_ROUTE_OPT label for route_opt
set BLOCK_ABSTRACT_FOR_SIGNOFF_DRC      "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_SIGNOFF_DRC label for signoff_drc
set BLOCK_ABSTRACT_FOR_CHIP_FINISH      "$CHIP_FINISH_BLOCK_NAME" ;# Use blocks with $BLOCK_ABSTRACT_FOR_CHIP_FINISH for chip_finish

set USE_ABSTRACTS_FOR_POWER_ANALYSIS 	false ;# Default false; false|true;
                                       	;# sets app option abstract.annotate_power that annotates power information in the abstracts
                                       	;# set this to true to perform power analysis inside subblocks modeled as abstracts

set USE_ABSTRACTS_FOR_SIGNAL_EM_ANALYSIS false ;# Default false; false|true;
					;# sets app option abstract.enable_signal_em_analysis 
					;# set this to true to perform signal em analysis inside abstracts

########################################################################################## 
## Hierarchical PNR Variables for clock_opt_cts related settings (used by clock_opt_cts.tcl)
##########################################################################################
set PROMOTE_CLOCK_BALANCE_POINTS	false ;# Default false. When implementing intermediate and top levels of physical hierarchy,
					;# set this variable to true to promote clock balance points from sub-blocks.
					;# Leave this variable to its default value, if the needed clock balance points for the pins
					;# inside sub-blocks are applied from the top-level itself.

########################################################################################## 
## Hierarchical PNR Variables for designs where some of the blocks are bound to ETMs
##########################################################################################
set USE_ETM_FOR_BLOCKS                  [list ] ;# design names for each physical block that will be bound to ETMs
set ETM_UPF_MAPPING_FILE "" 		;# Specify ETMs UPF mapping file
set WRITE_DATA_FOR_ETM_BLOCK_NAME       $CHIP_FINISH_BLOCK_NAME ;# Name of the starting block for the write_data_for_etm step


puts "RM-info: Completed script [info script]\n"

if {$DESIGN_STYLE == "hier" && $USE_RM_BLOCK_NAME_AS_LABEL == "false"} {
	puts "RM-error: DESIGN_STYLE is set to hier in icc2_common_setup.tcl but USE_RM_BLOCK_NAME_AS_LABEL is set to false. Pls correct it!"
	puts "RM-error: DESIGN_STYLE hier implies hierarchical PNR implementation is intended which requires user labels to be used."
	puts "RM-error: Hierarchical PNR implementation flow does not work without user labels."
}

set ICC2_DESIGN_LIB "./icc2_nlib"
if { ![file isdirectory $ICC2_DESIGN_LIB] } { file mkdir $ICC2_DESIGN_LIB }

## Source user define procs
source proc_qor.tcl
source utilites.tcl

## Jason add some flow configuration
set ENABLE_GRLB                     1
set ENABLE_2PASS_FLOW               1
set ENABLE_EXTRA_PLACE_FINAL_OPTO   0
set ENABLE_RDE                      0
set FLAT_HIER                       1
set REMOVE_KEEPOUT                  1
set ENABLE_POCV                     1 
set ENABLE_CTO_CCD                  1
set ENABLE_ROUTE_OPT_CCD            1
set MAIN_SCENARIO                   "func:rcworst_T:ssgnp0p72v125c"

## Setup & hold clock uncertainty value at flow different stage
set place_setup_uncert              0.060
set cts_setup_uncert                0.060
set route_setup_uncert              0.050 ; ## PT-PBA signoff = 50ps

set place_hold_uncert               0.000
set cts_hold_uncert                 0.015
set route_hold_uncert               0.017 ; ## PT-PBA signoff = 20ps

## Jason add compress DB mode for save disk space
set_app_options -name lib.setting.compress_design_lib -value true

set_app_options -as_user_default -list {shell.common.monitor_cpu_memory true}
