#################################################################################
# Script:   pt_setup.tcl
# Version:  $Revision: 1.2 $
# Copyright (C) 2007-2017 Synopsys, Inc. All rights reserved.
#################################################################################
echo "SCRIPT-Info: Start: [info script]"

suppress_message DBR-020
suppress_message LNK-040
suppress_message PTE-084
suppress_message RC-004
suppress_message RC-009
suppress_message RC-011
suppress_message PSW-211
suppress_message UITE-216

if {![info exists TOP_DIR]} {
    set TOP_DIR [file dirname [file dirname [file dirname [info script]]]]
}
set NUM_CORES 4
## source -e ${TOP_DIR}/scripts_block/rm_setup/common_setup.tcl

######################################
# Library and Design Setup
######################################

### Mode : DMSA

#set search_path ". $ADDITIONAL_SEARCH_PATH $search_path"
set search_path ". /slowfs/ceva/user/ian/XM6/lib/std/db /slowfs/ceva/user/ian/XM6/lib/sram/db /slowfs/ceva/user/ian/XM6/lib/std/aocv"

# Provide input files
if {[info exists env(BLOCK_NAME)]} {
  set BLOCK_NAME     $env(BLOCK_NAME)
} else {
  set BLOCK_NAME     route_opt
}

# DESIGN_NAME is checked for existence from common_setup.tcl
if {![string length $DESIGN_NAME] > 0} {
  set DESIGN_NAME                   "cevaxm6"  ;#  The name of the top-level design
}

set NETLIST_FILES  "${TOP_DIR}/outputs/icc2/${BLOCK_NAME}.v.gz"
set UPF_FILE       "${TOP_DIR}/outputs/icc2/${BLOCK_NAME}.upf"
set SAIF_FILE      ""
set DEF_FILE       "${TOP_DIR}/outputs/icc2/${BLOCK_NAME}.def.gz"
set PT_RULE_FILE   "${TOP_DIR}/outputs/icc2/${BLOCK_NAME}.rules.tcl.gz"
## set SAIF_NAME_MAP_FILE "${TOP_DIR}/work/dc/${DESIGN_NAME}.mapped.SAIF.namemap"


######################################
# DMSA File Section
######################################

source -c ${TOP_DIR}/scripts_block/rm_pt_scripts/scenario_settings.tcl

set dmsa_modes ""; set dmsa_cell_corners ""; set dmsa_wire_corners ""; set dmsa_corners ""; set dmsa_scenarios ""

foreach sce [array names scenario_constraints] {
    regexp -- {(\S+):(\S+):(\S+)} ${sce} match mode wire_corner cell_corner
    lappend dmsa_modes        ${mode}
    lappend dmsa_cell_corners ${cell_corner}
    lappend dmsa_wire_corners ${wire_corner}
    lappend dmsa_corners      "${wire_corner}:${cell_corner}"
    lappend dmsa_scenarios    "${mode}:${wire_corner}:${cell_corner}"
    puts "Building resources for scenario ${mode}:${wire_corner}:${cell_corner}"

}

#puts "INFO: ADDITIONAL_LINK_LIBRARY_FILES: $ADDITIONAL_LINK_LIBRARY_FILES"
set ssgnp0p72vm40c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdmbssgnp0p72vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdssgnp0p72vm40c_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db " 
set ssgnp0p72v125c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdmbssgnp0p72v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdssgnp0p72v125c_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db " 
set tt0p8v85c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdlvttt0p8v85c_ccs.db  tcbn12ffcllbwp6t16p96cpdmblvttt0p8v85c_ccs.db  tcbn12ffcllbwp6t16p96cpdmbtt0p8v85c_ccs.db  tcbn12ffcllbwp6t16p96cpdtt0p8v85c_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_tt0p8v85c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db "
set ffgnp0p88v125c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdmbffgnp0p88v125c_ccs.db  tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88v125c_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ffgnp_ccbt0p88v125c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db"
set ffgnp0p88vm40c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdmbffgnp0p88vm40c_ccs.db  tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88vm40c_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ffgnp_ccbt0p88vn40c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db"
## set ssgnp0p72vm40c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmbssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdlvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmblvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmbssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdlvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmblvtssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmbssgnp0p72vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdssgnp0p72vm40c_hm_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72vn40c.db " 
## set ssgnp0p72v125c_LINK_LIBRARY_FILES " tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmbssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdlvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmblvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmbssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdlvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmblvtssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmbssgnp0p72v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdssgnp0p72v125c_hm_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ssgnp_ccwt0p72v125c.db " 
## set tt0p8v85c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdlvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmblvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmbtt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdtt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdlvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmblvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmbtt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdtt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdlvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmblvttt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmbtt0p8v85c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdtt0p8v85c_hm_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_tt0p8v85c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_tt0p8v85c.db "
## set ffgnp0p88v125c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmbffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdlvtffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmbffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmblvtffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdlvtffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmbffgnp0p88v125c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmblvtffgnp0p88v125c_hm_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ffgnp_ccbt0p88v125c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88v125c.db"
## set ffgnp0p88vm40c_LINK_LIBRARY_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmbffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdlvtffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmbffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t20p96cpdmblvtffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdlvtffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmbffgnp0p88vm40c_hm_ccs.db tcbn12ffcllbwp6t24p96cpdmblvtffgnp0p88vm40c_hm_ccs.db sadels0c4l1p4096x32m8b2w0c0p0d0t0s2sdz1rw01_ffgnp_ccbt0p88vn40c.db  sarels0c4l1p2048x32m8b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p256x20m2b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p512x32m4b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db  sarels0c4l1p64x56m1b1w0c0p0d0t0s2z1rw01_ffgnp_bc0p88vn40c.db"

## AOCV tables
set ssgnp0p72vm40c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72vm40c_setup_P_P_ccs.aocvm  tcbn12ffcllbwp6t16p96cpdssgnp0p72vm40c_setup_P_P_ccs.aocvm"
set ssgnp0p72v125c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72v125c_setup_P_P_ccs.aocvm  tcbn12ffcllbwp6t16p96cpdssgnp0p72v125c_setup_P_P_ccs.aocvm"
set ffgnp0p88vm40c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88vm40c_hold_P_P_ccs.aocvm  tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88vm40c_hold_P_P_ccs.aocvm"
set ffgnp0p88v125c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88v125c_hold_P_P_ccs.aocvm  tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88v125c_hold_P_P_ccs.aocvm"
set tt0p8v85c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvttt0p8v85c_setup_P_P_ccs.aocvm  tcbn12ffcllbwp6t16p96cpdtt0p8v85c_setup_P_P_ccs.aocvm"
## set ssgnp0p72vm40c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmbssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdlvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmblvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmbssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdlvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmblvtssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmbssgnp0p72vm40c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdssgnp0p72vm40c_setup_P_P_ccs.aocvm "
## set ssgnp0p72v125c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmblvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmbssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdlvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmblvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmbssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdlvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmblvtssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmbssgnp0p72v125c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdssgnp0p72v125c_setup_P_P_ccs.aocvm "
## set ffgnp0p88vm40c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmbffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdlvtffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmbffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmblvtffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdlvtffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmbffgnp0p88vm40c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmblvtffgnp0p88vm40c_hold_P_P_ccs.aocvm "
## set ffgnp0p88v125c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdlvtffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmbffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmblvtffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdlvtffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmbffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmblvtffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdlvtffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmbffgnp0p88v125c_hold_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmblvtffgnp0p88v125c_hold_P_P_ccs.aocvm "
## set tt0p8v85c_OCV_FILES "tcbn12ffcllbwp6t16p96cpdlvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmblvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdmbtt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t16p96cpdtt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdlvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmblvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdmbtt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t20p96cpdtt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdlvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmblvttt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdmbtt0p8v85c_setup_P_P_ccs.aocvm tcbn12ffcllbwp6t24p96cpdtt0p8v85c_setup_P_P_ccs.aocvm "

foreach dmsa_cell_corner $dmsa_cell_corners {
    set library_files($dmsa_cell_corner)   " [set ${dmsa_cell_corner}_LINK_LIBRARY_FILES]"
    puts "INFO: library_files($dmsa_cell_corner): $library_files($dmsa_cell_corner)"
}

foreach dmsa_scenario $dmsa_scenarios {
  set constraint_files($dmsa_scenario)   "${TOP_DIR}/$scenario_constraints($dmsa_scenario)"
}

# STAR GPD/SPEF or ICC2 SPEF
foreach dmsa_corner $dmsa_corners {
  regexp {(\S+):(\S+)} $dmsa_corner trash dmsa_wire_corner dmsa_cell_corner
  set star_spef "${TOP_DIR}/outputs/signoff/${DESIGN_NAME}.${BLOCK_NAME}.STAR.spef.${dmsa_wire_corner}"
  set star_gpd "${TOP_DIR}/outputs/signoff/${DESIGN_NAME}.${BLOCK_NAME}.STAR.gpd"
    puts "INFO: Using STAR extraction data: $star_spef" 
    set parasitic_files($dmsa_wire_corner)      $star_spef 
}


######################################
# Setting Number of Hosts and Licenses
######################################
# Set the number of hosts and licenses to number of dmsa_corners * number of dmsa_modes
set dmsa_num_of_hosts [expr [llength $dmsa_scenarios]]
set dmsa_num_of_licenses [expr [llength $dmsa_scenarios]]

# Generate reports with 0 significant digits
set_app_var report_default_significant_digits 6

######################################
# End
######################################

### End of PrimeTime Runtime Variables ###
echo "SCRIPT-Info: End: [info script]"
