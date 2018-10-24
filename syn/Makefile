##########################################################################################
# Tool: IC Compiler II
# Script: Makefile_pnr
# Version: M-2016.12-SP4 (July 17, 2017)
# Copyright (C) 2014-2017 Synopsys, Inc. All rights reserved.
##########################################################################################

DC_EXEC      = /global/apps/syn_2017.09-SP4/bin/dc_shell
ICC2_EXEC    = /global/apps/icc2_2017.09-SP5/bin/icc2_shell
STARRC_EXEC  = /global/apps/starrc_2017.12-SP1/bin/StarXtract
PT_EXEC      = /global/apps/pt_2017.12-SP2/bin/pt_shell
FM_EXEC      = /global/apps/fm_2017.09-SP4/bin/fm_shell
DC_OPTIONS   = -64 -topo
FM_OPTIONS   = -64
OPTIONS      =

NDM_DIR      = icc2_nlib
LOGS_DIR     = logs/icc2
ICC2_RPTS_DIR= rpts/icc2
ICC2_OUT_DIR = outputs/icc2
DC_LOGS_DIR  = logs/dc
DC_RPTS_DIR  = rpts/dc
DC_OUT_DIR   = outputs/dc
SIGN_LOGS_DIR= logs/signoff
SIGN_RPTS_DIR= rpts/signoff
SIGN_OUT_DIR = outputs/signoff
SIGN_WORK_DIR= work/signoff

ABS_TOP_DIR_PATH = `pwd`

## Optional: Specify design library if you want backup step and clean step to use it
## CAUTION: if added, the clean step will delete it
DESIGN_LIB =

setup:
	test -d $(DC_LOGS_DIR)  || mkdir -p $(DC_LOGS_DIR)
	test -d $(DC_RPTS_DIR)  || mkdir -p $(DC_RPTS_DIR)
	test -d $(DC_OUT_DIR)   || mkdir -p $(DC_OUT_DIR)
	test -d $(LOGS_DIR)	|| mkdir -p $(LOGS_DIR)
	test -d $(ICC2_RPTS_DIR)|| mkdir -p $(ICC2_RPTS_DIR)
	test -d $(ICC2_OUT_DIR)	|| mkdir -p $(ICC2_OUT_DIR)
	test -d $(NDM_DIR)	|| mkdir -p $(NDM_DIR)
	date > setup

console:
	$(ICC2_EXEC)

icc2:
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/icc2_shell.tcl | tee -i $(LOGS_DIR)/icc2_shell.log

isdc: setup
	$(DC_EXEC) $(DC_OPTIONS) -f ./scripts_block/rm_setup/dc_setup.tcl | tee -i $(DC_LOGS_DIR)/debug.log

syn: setup
	$(DC_EXEC) $(DC_OPTIONS) -f ./scripts_block/rm_dc_scripts/dc.tcl | tee -i $(DC_LOGS_DIR)/synthesis.log
	mail -s "${PWD} - syn" `whoami`@synopsys.com < rpts/dc/nvdla.mapped.qor.rpt.proc

init_design: setup
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/init_design.tcl | tee -i $(LOGS_DIR)/init_design.log

place_opt: setup init_design
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/place_opt.tcl | tee -i $(LOGS_DIR)/place_opt.log
	$(shell ~/check_full_qor.pl -dir . > full_qor)
	mail -s "${PWD}" `whoami`@synopsys.com < full_qor

clock_opt_cts: setup place_opt
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/clock_opt_cts.tcl | tee -i $(LOGS_DIR)/clock_opt_cts.log
	$(shell ~/check_full_qor.pl -dir . > full_qor)
	mail -s "${PWD}" `whoami`@synopsys.com < full_qor

clock_opt_opto: setup clock_opt_cts
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/clock_opt_opto.tcl | tee -i $(LOGS_DIR)/clock_opt_opto.log
	$(shell ~/check_full_qor.pl -dir . > full_qor)
	mail -s "${PWD}" `whoami`@synopsys.com < full_qor

route_auto: setup clock_opt_opto
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/route_auto.tcl | tee -i $(LOGS_DIR)/route_auto.log
	$(shell ~/check_full_qor.pl -dir . > full_qor)
	mail -s "${PWD}" `whoami`@synopsys.com < full_qor

route_opt: setup route_auto
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/route_opt.tcl | tee -i $(LOGS_DIR)/route_opt.log
	$(shell ~/check_full_qor.pl -dir . > full_qor)
	mail -s "${PWD}" `whoami`@synopsys.com < full_qor

signoff_drc: setup route_opt
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/signoff_drc.tcl | tee -i $(LOGS_DIR)/signoff_drc.log

chip_finish: setup signoff_drc
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/chip_finish.tcl | tee -i $(LOGS_DIR)/chip_finish.log

all: route_opt
	date > all

write_data: setup 
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/write_data.tcl | tee -i $(LOGS_DIR)/write_data.log

################################################################################################################
## RCX/STA flow
################################################################################################################
setup_signoff: write_data
	mkdir -p $(SIGN_RPTS_DIR)
	mkdir -p $(SIGN_LOGS_DIR)
	mkdir -p $(SIGN_OUT_DIR)
	mkdir -p $(SIGN_WORK_DIR)
	date > setup_signoff

rcx: setup_signoff
	$(STARRC_EXEC) ./scripts_block/rm_starrc_scripts/star_cmd | tee -i $(SIGN_LOGS_DIR)/StarRC_extraction.log
	date >> rcx

sta: rcx
	BLOCK_NAME=write_data SIGNOFF_LOCAL_MACHINE=true $(PT_EXEC) -multi -file $(ABS_TOP_DIR_PATH)/scripts_block/rm_pt_scripts/pt_dmsa.tcl | tee -i $(SIGN_LOGS_DIR)/PT_DMSA_STA.write_data.log
	date >> sta

eco: sta
	BLOCK_NAME=write_data SIGNOFF_LOCAL_MACHINE=true $(PT_EXEC) -multi -file $(ABS_TOP_DIR_PATH)/scripts_block/rm_pt_scripts/pt_dmsa.restore.fix_eco_timing.fix_eco_power.physical.tcl | tee -i $(SIGN_LOGS_DIR)/PT_DMSA_TimingECO_PwrECO.log
	

################################################################################################################
## Optional for Flat P&R (DESIGN_STYLE set to flat in icc2_common_setup.tcl)
################################################################################################################
eco_fusion: route_opt setup_signoff
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/eco_fusion.tcl | tee -i $(LOGS_DIR)/eco_fusion.log

eco_fusion_rcx: eco_fusion
	$(STARRC_EXEC) ./scripts_block/rm_starrc_scripts/star_cmd.eco_fusion | tee -i $(SIGN_LOGS_DIR)/StarRC_extration.eco_fusion.log
	date >> eco_fusion_rcx

eco_fusion_sta: eco_fusion_rcx
	BLOCK_NAME=eco_fusion SIGNOFF_LOCAL_MACHINE=true $(PT_EXEC) -multi -file $(ABS_TOP_DIR_PATH)/scripts_block/rm_pt_scripts/pt_dmsa.tcl | tee -i $(SIGN_LOGS_DIR)/PT_DMSA_STA.eco_fusion.log
	date >> eco_fusion_sta


################################################################################################################
## Optional for Flat P&R (DESIGN_STYLE set to flat in icc2_common_setup.tcl)
################################################################################################################
# For classic PT-ECO flow
pt_eco: setup eco
	$(ICC2_EXEC) $(OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/pt_eco.eco_timing_power_phy.tcl | tee -i $(LOGS_DIR)/pt_eco.eco_timing_power_phy.log

pt_eco_rcx: pt_eco
	$(STARRC_EXEC) ./scripts_block/rm_starrc_scripts/star_cmd.eco_timing_power_phy | tee -i $(SIGN_LOGS_DIR)/StarRC_extraction.eco_timing_power_phy.log
	date >> pt_eco_rcx

pt_eco_sta: pt_eco_rcx
	BLOCK_NAME=pt_eco SIGNOFF_LOCAL_MACHINE=true $(PT_EXEC) -multi -file $(ABS_TOP_DIR_PATH)/scripts_block/rm_pt_scripts/pt_dmsa.tcl | tee -i $(SIGN_LOGS_DIR)/PT_DMSA_STA.eco_timing_power_phy.log
	date >> pt_eco_sta

## # For Galaxy incremental ECO flow (two steps)
## pt_eco_incremental_1: setup
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/pt_eco_incremental_1.tcl | tee -i $(LOGS_DIR)/pt_eco_incremental_1.log
## 	# After the above is done in ICC-II, follow the in-script guidance to proceed to StarRC for extraction and PrimeTime for ECO.
## 
## pt_eco_incremental_2: setup pt_eco_incremental_1
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/pt_eco_incremental_2.tcl | tee -i $(LOGS_DIR)/pt_eco_incremental_2.log
## 	# After the above is done in ICC-II, follow the in-script guidance to proceed to StarRC for extraction and PrimeTime
## 	# to assess timing and determine if further ECO iteration is required. 

# For formality
syn_fm: setup syn
	$(FM_EXEC) $(FM_OPTIONS) -f ./scripts_block/rm_dc_scripts/fm.tcl | tee -i $(DC_LOGS_DIR)/fm.log
fm: setup write_data
	$(FM_EXEC) $(FM_OPTIONS) -f ./scripts_block/rm_icc2_pnr_scripts/fm.tcl | tee -i $(LOGS_DIR)/fm.log

## # For PrimeRail In-design Analysis
## in_design_pnr_rail_analysis: setup
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/in_design_pnr_rail_analysis.tcl | tee -i $(LOGS_DIR)/in_design_pnr_rail_analysis.log

################################################################################################################
## Optional for Hierarchical P&R (DESIGN_STYLE set to hier in icc2_common_setup.tcl)
################################################################################################################
## # For bottom and intermediate levels of hierarchical designs (PHYSICAL_HIERARCHY_LEVEL set to bottom or intermediate)
## export: setup
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/export.tcl | tee -i $(LOGS_DIR)/export.log
## 
## write_data_for_etm: setup
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/write_data_for_etm.tcl | tee -i $(LOGS_DIR)/write_data_for_etm.log

################################################################################################################
# Utilities
################################################################################################################
## summary: setup all 
## 	$(ICC2_EXEC) $(OPTIONS) -f ./rm_icc2_pnr_scripts/summary.tcl | tee -i $(LOGS_DIR)/summary.log

##Backup
BACKUP  = BACKUP.`date "+%m_%d_%H_%M"`
backup:
	rm -rf $(BACKUP)
	mkdir -p $(BACKUP)
	cp -rf $(DESIGN_LIB) $(LOGS_DIR) $(BACKUP)

##Clean
clean:
	rm  -f setup syn init_design place_opt clock_opt_cts clock_opt_opto route_auto route_opt signoff_drc chip_finish write_data all setup_signoff sta rcx eco pt_eco pt_eco_rcx pt_eco_sta pt_eco_incremental_1 pt_eco_incremental_2 fm in_design_pnr_rail_analysis summary *.log *.ems clock_auto_exceptions* logs/*/* *.rpt *.dat clog* icc2_output.txt rpts/*/* qor.csv
	rm -rf outputs/*/*.gpd alib* *_LIB WORK *.starrc work/*/*

clean_from_init:
	rm  -f place_opt clock_opt_cts clock_opt_opto route_auto route_opt signoff_drc chip_finish write_data all setup_signoff rcx sta eco pt_eco pt_eco_rcx pt_eco_sta pt_eco_incremental_1 pt_eco_incremental_2 fm in_design_pnr_rail_analysis summary *.log *.ems clock_auto_exceptions* logs/*/* *.rpt *.dat clog* icc2_output.txt rpts/*/* qor.csv
	rm -rf outputs/*/*.gpd *.starrc work/*/*

clean_all: clean
	rm -rf $(LOGS_DIR) $(DESIGN_LIB)

