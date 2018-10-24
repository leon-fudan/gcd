#  Create default groups
set ports_clock_root [filter_collection [get_attribute [get_clocks] sources] object_class==port]
set myRealClocks [remove_from_collection [all_clocks ] [get_clocks *VIRTUAL*]]

group_path -name REGOUT -to [all_outputs] -weight 0.1
group_path -name REGIN -from [remove_from_collection [all_inputs] ${ports_clock_root}] -weight 0.1
group_path -name FEEDTHROUGH -from [remove_from_collection [all_inputs] ${ports_clock_root}] -to [all_outputs] -weight 0.1
group_path -name CLOCK_GATER -to [get_pins -of_objects [get_cells -hierarchical -filter "ref_name =~ *CKG*"] -filter "name == E || name == EN"]

set MEMS [get_cells -hier * -filter "is_hierarchical == false && (ref_name =~ sa*)"]
set MEMS [remove_from_collection $MEMS [set SDP_MEM  [filter_collection $MEMS {@full_name =~ .*NVDLA_sdp.*}      -regexp]]]
set MEMS [remove_from_collection $MEMS [set PDP_MEM  [filter_collection $MEMS {@full_name =~ .*NVDLA_pdp.*}      -regexp]]]
set MEMS [remove_from_collection $MEMS [set CDP_MEM  [filter_collection $MEMS {@full_name =~ .*NVDLA_cdp.*}      -regexp]]]
set MEMS [remove_from_collection $MEMS [set CBUF_MEM [filter_collection $MEMS {@full_name =~ .*NVDLA_cbuf.*}     -regexp]]]
set MEMS [remove_from_collection $MEMS [set CDMA_MEM [filter_collection $MEMS {@full_name =~ .*NVDLA_cdma.*}     -regexp]]]
set MEMS [remove_from_collection $MEMS [set CVIF_MEM [filter_collection $MEMS {@full_name =~ .*NVDLA_cvif.*}     -regexp]]]
set MEMS [remove_from_collection $MEMS [set MCIF_MEM [filter_collection $MEMS {@full_name =~ .*NVDLA_mcif.*}     -regexp]]]
set MEMS [remove_from_collection $MEMS [set ASS_MEM  [filter_collection $MEMS {@full_name =~ .*assembly_buffer.*}     -regexp]]]
set MEMS [remove_from_collection $MEMS [set DEL_MEM  [filter_collection $MEMS {@full_name =~ .*delivery_buffer.*}     -regexp]]]

foreach mem {SDP_MEM PDP_MEM CDP_MEM CBUF_MEM CDMA_MEM CVIF_MEM MCIF_MEM ASS_MEM DEL_MEM} {
    if {[sizeof_collection [set $mem]]} {
        group_path -name TO_$mem   -to   [set $mem]
        group_path -name FROM_$mem -from [set $mem]
    }
}

foreach_in_collection ck $myRealClocks {
    set ck_name [get_object_name $ck]
    group_path -name $ck_name
}

set groups_list [list \
]

set group_data(e5_write_data.cell)	    *vst*_reg*
set group_data(e5_write_data.weight)	1	    


foreach group_name $groups_list {
	set cells [get_flat_pins $group_data(${group_name}.cell)/* -filter "name == D || name == d"]
	if {[sizeof_collection $cells]} {
		group_path -name $group_name -to $cells -weight $group_data(${group_name}.weight)
		puts "Created group_path: $group_name, with [sizeof_collection $cells] 'to' cells added found"
	} else {
		puts "!!! No group_path created - name requested: $group_name; search: $group_data(${group_name}.cell)"
	}
}


set all_regs   [get_cells [all_registers] -filter "ref_name !~ sa* && ref_name !~ *CKG*"]
set cacc   [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_cacc.*}     ]
set cbuf   [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_cbuf.*}     ]
set cdma   [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_cdma.*}     ]
set csc    [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_csc.*}      ]
set cdp    [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_cdp.*}      ]
set cvif   [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_cvif.*}     ]
set glb    [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_glb.*}      ]
set mcif   [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_mcif.*}     ]
set pdp    [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_pdp.*}      ]
set sdp    [filter_collection $all_regs -regexp {@full_name =~ .*NVDLA_sdp.*}      ]
set cmac_a [filter_collection $all_regs -regexp {@full_name =~ .*ma.*NVDLA_cmac.*} ]
set cmac_b [filter_collection $all_regs -regexp {@full_name =~ .*mb.*NVDLA_cmac.*} ]

## Define path groups
group_path -name cacc   -to $cacc
group_path -name cbuf   -to $cbuf  
group_path -name cdma   -to $cdma  
group_path -name csc    -to $csc   
group_path -name cdp    -to $cdp   
group_path -name cvif   -to $cvif  
group_path -name glb    -to $glb   
group_path -name mcif   -to $mcif  
group_path -name pdp    -to $pdp   
group_path -name sdp    -to $sdp   
group_path -name cmac_a -to $cmac_a
group_path -name cmac_b -to $cmac_b
