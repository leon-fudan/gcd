# High Performance
set_dont_use [get_lib_cells ts*/*_FSD*]
set_dont_use [get_lib_cells ts*/*_FD*]
remove_attribute [get_lib_cells ts*/*_FSDPQO_F4_*] dont_use
remove_attribute [get_lib_cells ts*/*_FSDPQO_V2_*] dont_use
remove_attribute [get_lib_cells ts*/*_FSDPRBQO_F4_*] dont_use
remove_attribute [get_lib_cells ts*/*_FSDPRBQO_V2_*] dont_use
remove_attribute [get_lib_cells ts*/*_FSDPQO_V3_*] dont_use
remove_attribute [get_lib_cells ts*/*_FSDPRBQO_V3_*] dont_use
set_dont_use [get_lib_cells ts*/*CKGT*0P*] -power
set dont_use_list [list *_0P* *_16 *_20 *_24 *_32 *_DEL* *_TIE* *ECO* *MMCK* *_CK_* *LP* *_MM_* *_S_*]
foreach dont_use ${dont_use_list} {
echo "[get_attribute [get_lib_cells ts*/${dont_use}] full_name]"
set_dont_use [get_lib_cells ts*/${dont_use} ]
}
set flop_list [list *_FSDPQO *_FSDPRBQO ]
foreach dont_use ${flop_list} {
echo "[get_attribute [get_lib_cells ts*/${dont_use}_*] full_name]"
remove_attribute [get_lib_cells ts*/${dont_use}_1 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_2 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_3 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_4 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_6 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_8 ] dont_use
}

set flop_list [list *_FSDPQ_D *_FSDPQ_V2 *_FSDPQB_V2 *_FDPQ *_FDPQ_V2]
foreach dont_use ${flop_list} {
echo "[get_attribute [get_lib_cells ts*/${dont_use}_*] full_name]"
remove_attribute [get_lib_cells ts*/${dont_use}_1 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_2 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_3 ] dont_use
remove_attribute [get_lib_cells ts*/${dont_use}_4 ] dont_use
}

# add 1230
set_dont_use [get_lib_cells ts*/*AOI2222*]
set_dont_use [get_lib_cells ts*/*AO2222*]

# added by glji
#set_dont_use [get_lib_cells ts*/HDP*]

set_dont_use [get_lib_cells ts*/*SKR*]
set_dont_use [get_lib_cells ts*/*BUF*MS*]
set_dont_use [get_lib_cells ts*/*BUF*MN*]
set_dont_use [get_lib_cells ts*/*V2MM*]
set_dont_use [get_lib_cells ts*/*EN2_F*]
set_dont_use [get_lib_cells ts*/*EO2_F*]

