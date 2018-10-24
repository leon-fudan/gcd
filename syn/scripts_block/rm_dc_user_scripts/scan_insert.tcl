identify_clock_gating

set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 40

set_dft_configuration -fix_set enable -fix_reset enable

set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port {dla_core_clk dla_csb_clk}
set_dft_signal -view existing_dft -type Reset -active_state 0 -port {dla_reset_rstn direct_reset_}
set_dft_signal -view existing_dft -type Constant -active_state 1 -port test_mode
set_dft_signal -view spec -port scan_en -type ScanEnable -active_state 1
set_dft_signal -view spec -port com_mode -type TestMode

create_test_protocol

dft_drc  > ${REPORTS_DIR}/pre.dft_drc

# Scan synthesis and autofix settings
set_dft_insertion_configuration -synthesis none -preserve_design_name true

set_scan_configuration -chain_count 7 -add_lockup true -clock_mixing mix_clocks

# Specify all scan ports
for {set i 0} {$i < 7 } {incr i} {
    set_dft_signal -view spec -port scan_in_$i  -type ScanDataIn
    set_dft_signal -view spec -port scan_out_$i -type ScanDataOut
    set_scan_path chain$i -view spec -scan_data_in scan_in_$i -scan_data_out scan_out_$i
}

### Enable Adaptive scan HERE
set_dft_configuration -scan_compression enable

### Specify compression ratio HERE
set_scan_compression_configuration -chain_count 241

preview_dft

set compile_instance_name_prefix DFTC_
insert_dft
current_test_mode Internal_scan
dft_drc  > ${REPORTS_DIR}/post.internal_scan.dft_drc
current_test_mode ScanCompression_mode
dft_drc  > ${REPORTS_DIR}/post.scancom.dft_drc

change_names -rule verilog -hierarchy
report_dft > ${REPORTS_DIR}/dft
report_scan_configuration > ${REPORTS_DIR}/scan_config
report_dft_signal -view existing_dft > ${REPORTS_DIR}/dft_signals
report_scan_path -view existing_dft -chain all > ${REPORTS_DIR}/scan_chains
report_scan_path -view existing_dft -cell all > ${REPORTS_DIR}/scan_cells

# hand off
set test_stil_netlist_format verilog
write -hierarchy -format verilog -output ${RESULTS_DIR}/${DESIGN_NAME}_scan.v
write -hierarchy -format ddc     -output ${RESULTS_DIR}/${DESIGN_NAME}_scan.ddc

# Write Internal_scan protocol:
write_test_protocol -out ${RESULTS_DIR}/scan.spf \
  -test_mode Internal_scan

# Write ScanCompression_mode protocol:
write_test_protocol -out ${RESULTS_DIR}/scancompress.spf \
  -test_mode ScanCompression_mode
