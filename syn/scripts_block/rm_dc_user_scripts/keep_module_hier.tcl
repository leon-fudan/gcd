set keep_hier ""
set modules " \
            u_partition_a \
            u_partition_a/u_NV_NVDLA_RT_cmac_b2cacc \
            u_partition_a/u_NV_NVDLA_cacc \
            u_partition_a/u_NV_NVDLA_cacc/u_assembly_buffer \
            u_partition_a/u_NV_NVDLA_cacc/u_assembly_ctrl \
            u_partition_a/u_NV_NVDLA_cacc/u_calculator \
            u_partition_a/u_NV_NVDLA_cacc/u_delivery_buffer \
            u_partition_a/u_NV_NVDLA_cacc/u_delivery_ctrl \
            u_partition_a/u_NV_NVDLA_cacc/u_regfile \
            u_partition_a/u_partition_a_reset \
            u_partition_c \
            u_partition_c/u_NV_NVDLA_RT_cacc2glb \
            u_partition_c/u_NV_NVDLA_RT_csb2cacc \
            u_partition_c/u_NV_NVDLA_RT_csb2cmac \
            u_partition_c/u_NV_NVDLA_RT_csc2cmac_b \
            u_partition_c/u_NV_NVDLA_cbuf \
            u_partition_c/u_NV_NVDLA_cdma \
            u_partition_c/u_NV_NVDLA_csc \
            u_partition_c/u_partition_c_reset \
            u_partition_ma \
            u_partition_ma/u_NV_NVDLA_cmac \
            u_partition_ma/u_NV_NVDLA_cmac/u_core \
            u_partition_ma/u_NV_NVDLA_cmac/u_core/u_rt_in \
            u_partition_ma/u_NV_NVDLA_cmac/u_core/u_rt_out \
            u_partition_ma/u_NV_NVDLA_cmac/u_reg \
            u_partition_ma/u_partition_m_reset \
            u_partition_mb \
            u_partition_mb/u_NV_NVDLA_cmac \
            u_partition_mb/u_NV_NVDLA_cmac/u_core \
            u_partition_mb/u_NV_NVDLA_cmac/u_core/u_rt_in \
            u_partition_mb/u_NV_NVDLA_cmac/u_core/u_rt_out \
            u_partition_mb/u_NV_NVDLA_cmac/u_reg \
            u_partition_mb/u_partition_m_reset \
            u_partition_o \
            u_partition_o/u_NV_NVDLA_RT_csb2cmac \
            u_partition_o/u_NV_NVDLA_RT_csc2cmac_a \
            u_partition_o/u_NV_NVDLA_cdp \
            u_partition_o/u_NV_NVDLA_cdp/u_rdma \
            u_partition_o/u_NV_NVDLA_cdp/u_reg \
            u_partition_o/u_NV_NVDLA_cdp/u_wdma \
            u_partition_o/u_NV_NVDLA_csb_master \
            u_partition_o/u_NV_NVDLA_cvif \
            u_partition_o/u_NV_NVDLA_glb \
            u_partition_o/u_NV_NVDLA_mcif \
            u_partition_o/u_NV_NVDLA_pdp \
            u_partition_o/u_NV_NVDLA_pdp/u_rdma \
            u_partition_o/u_NV_NVDLA_pdp/u_reg \
            u_partition_o/u_NV_NVDLA_pdp/u_wdma \
            u_partition_o/u_sync_core_reset \
            u_partition_o/u_sync_falcon_reset \
            u_partition_p \
            u_partition_p/u_NV_NVDLA_RT_cmac_a2cacc \
            u_partition_p/u_NV_NVDLA_sdp \
            u_partition_p/u_NV_NVDLA_sdp/u_core \
            u_partition_p/u_NV_NVDLA_sdp/u_rdma \
            u_partition_p/u_NV_NVDLA_sdp/u_reg \
            u_partition_p/u_NV_NVDLA_sdp/u_wdma \
            u_partition_p/u_partition_p_reset \
	     "

foreach module $modules {
    while {1} {
        lappend keep_hier $module
        set par_hier [file dirname $module]
        if { $par_hier == "." } {
            break
        } else {
            set module $par_hier
        }
    }
}

set keep_hier [lsort -unique $keep_hier]
echo "Keep hier $keep_hier"
set_ungroup [get_cells $keep_hier] false

source -e -v ./scripts_block/rm_dc_user_scripts/keep_macro_hier.tcl

set compile_auto_ungroup_area_num_cells     100
set compile_auto_ungroup_count_leaf_cells   true
