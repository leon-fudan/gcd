
set DESIGN_NAME                   "gcd"  ;#  The name of the top-level design
set DESIGN_REF_DATA_PATH           "/remote/ailab1/weihang/course/dsp_vsli/gcd"
set link_library        "
        ${DESIGN_REF_DATA_PATH}/syn/library/std/db/ts16ncfslogl20hdh090f_ssgnp0p72vn40c.db
        ${DESIGN_REF_DATA_PATH}/syn/library/std/db/ts16ncfslogl20hdl090f_ssgnp0p72vn40c.db
        "
set target_library          "
        ${DESIGN_REF_DATA_PATH}/syn/library/std/db/ts16ncfslogl20hdh090f_ssgnp0p72vn40c.db
        ${DESIGN_REF_DATA_PATH}/syn/library/std/db/ts16ncfslogl20hdl090f_ssgnp0p72vn40c.db
        "
read_verilog  "${DESIGN_REF_DATA_PATH}/rtl/gcd.v "
current_design ${DESIGN_NAME}
create_clock -name clk -period 0.5 clk
set_ideal_network resetn
check_design
compile
report_area > rpts/area.rpt
report_qor > rpts/qor.rpt
