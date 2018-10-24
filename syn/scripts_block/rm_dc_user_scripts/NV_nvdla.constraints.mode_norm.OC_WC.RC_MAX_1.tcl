###create clocks
set DLA_CORE_CLK_period [format "%.3f" [expr (1000.0/1000)]]
set DLA_CORE_CLK_half_period [expr $DLA_CORE_CLK_period*0.5]
create_clock -name DLA_CORE_CLK -period $DLA_CORE_CLK_period -waveform [list 0 $DLA_CORE_CLK_half_period] [get_ports dla_core_clk]
create_clock -name DLA_CORE_CLK_VIRTUAL -period $DLA_CORE_CLK_period -waveform [list 0 $DLA_CORE_CLK_half_period]

set DLA_CSB_CLK_period [format "%.3f" [expr (1000.0/800)]]
set DLA_CSB_CLK_half_period [expr $DLA_CSB_CLK_period*0.5]
create_clock -name DLA_CSB_CLK -period $DLA_CSB_CLK_period -waveform [list 0 $DLA_CSB_CLK_half_period] [get_ports dla_csb_clk]
create_clock -name DLA_CSB_CLK_VIRTUAL -period $DLA_CSB_CLK_period -waveform [list 0 $DLA_CSB_CLK_half_period]

set_clock_uncertainty  -setup 0.08 [get_clocks *]
set_clock_uncertainty  -hold  0.03 [get_clocks *]

####clock groups
set_clock_groups -asynchronous -name NVDLA_CLKS \
                 -group {DLA_CORE_CLK DLA_CORE_CLK_VIRTUAL} \
                 -group {DLA_CSB_CLK DLA_CSB_CLK_VIRTUAL}


####io
set_load 0.05 [all_outputs]
set_input_transition 0.2 [remove_from_collection [all_inputs] [get_ports {dla_core_clk dla_csb_clk}]]

#glji
foreach_in_collection mem [get_cells -hier -filter "!is_hierarchical && ref_name =~ sadr*"] {
    set cell_name [get_object_name $mem]
    set_disable_timing $mem -from CLKA -to CLKB
    set_disable_timing $mem -from CLKB -to CLKA
}
#set_disable_timing [get_lib_cells sadr*/*] -from CLKA -to CLKB
#set_disable_timing [get_lib_cells sadr*/*] -from CLKB -to CLKA

set_max_transition 0.2 [current_design]

# In 16ff+ flow, we need to apply +/-7% net derates in all corners
# # Cell derates are not needed with AOCV tables 
set_timing_derate -max -net_delay -early 0.93
set_timing_derate -max -net_delay -late  1.07
set_timing_derate -min -net_delay -early 0.93
set_timing_derate -min -net_delay -late  1.07
set_timing_derate -max -cell_delay -late 1.03
