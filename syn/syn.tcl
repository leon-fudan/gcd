
set_host_options -max_cores 8
set DESIGN_NAME                   "gcd"  ;#  The name of the top-level design
set link_library        "
        ./library/std/db/ts28nphslogl35hdh140f_ssgwc0p81v125c.db
        ./library/std/db/ts28nphslogl35hdl140f_ssgwc0p81v125c.db
        "
set target_library          "
        ./library/std/db/ts28nphslogl35hdh140f_ssgwc0p81v125c.db
        ./library/std/db/ts28nphslogl35hdl140f_ssgwc0p81v125c.db
        "
read_verilog  "../rtl/gcd.v ../rtl/mod.v"
current_design ${DESIGN_NAME}
create_clock -name clk -period 0.5 clk
set_ideal_network resetn
check_design > rpts/check_design.rpt
compile_ultra
report_area > rpts/area.rpt
report_qor > rpts/qor.rpt
report_power > rpts/power.rpt
write -hierarchy -format ddc -output out.ddc
