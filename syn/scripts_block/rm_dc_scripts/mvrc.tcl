#################################################################################
# MVRC Verification Script for
# Design Compiler Reference Methodology Script for Top-Down Flow
# Script: mvrc.tcl
# Version: N-2017.09 (October 2, 2017)
# Copyright (C) 2011-2017 Synopsys, Inc. All rights reserved.
#################################################################################

# The following procedure is used to search the all the directories in the search_path
# for a given file name
proc search_searchpath {SEARCH_PATH FILE_NAME} {
  # Check if we already have an absolute file reference
  if {[string index $FILE_NAME 0]== "/"} {
    return $FILE_NAME
  }
  foreach dir_path $SEARCH_PATH {
   if {![string compare [glob -nocomplain -directory $dir_path $FILE_NAME] ""] == 0} {
     set FILE_PATH [glob -nocomplain -directory $dir_path $FILE_NAME]
     return $FILE_PATH 
     break 
     }
   }
}
# Enable the default behavior of sh_continue_on_error to be same as Design Compiler 
set_app_var sh_continue_on_error true

source -echo -verbose ./rm_setup/dc_setup.tcl

if {$MVRC_RUN=="RTL"} {
   # Load the RTL design
   foreach rtl_file $RTL_SOURCE_FILES {
     set V_PATH [search_searchpath $search_path $rtl_file]
     puts "RM-Info: Executing command mvcmp -vlogan $V_PATH"	
     exec mvcmp -vlogan $V_PATH
   }

   # Load the UPF files
   read_power_intent -upf  $DCRM_MV_UPF_INPUT_FILE

# Use Netlist as the default mode to run MVRC checks
} else {
   # Load the design netlist
   read_verilog -file $DCRM_FINAL_VERILOG_OUTPUT_FILE

   # Load the UPF files
   read_power_intent -upf $DCRM_MV_FINAL_UPF_OUTPUT_FILE
}

# Create the Multi-voltage database for netlist
create_mv_db -top ${DESIGN_NAME}

# Create the physical database for the netlist
if {$MVRC_RUN =="NETLIST"} {
   create_physical_db -top ${DESIGN_NAME}
}

# Read the Multi-voltage database for netlist
read_db 

# Read the physical database for netlist
if {$MVRC_RUN =="NETLIST"} {
   read_phydb
}

# Reports violations in a design
check_design -[string tolower $MVRC_RUN] -log ${REPORTS_DIR}/${DESIGN_NAME}.mvrc_check_design.${MVRC_RUN}.rpt


puts "RM-Info: End script [info script]\n"
exit
