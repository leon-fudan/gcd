set keep_hier ""
set macro_cells [get_flat_cells -filter "ref_name =~ sa*"]

foreach_in_collection m $macro_cells {
    set name [get_object_name $m]
    while {1} {
        lappend keep_hier $name
        set par_hier [file dirname $name]
        if { $par_hier == "." } {
            break
        } else {
            set name $par_hier
        }
    }
}

set keep_hier [lsort -unique $keep_hier]
echo "Keep hier $keep_hier"
set_ungroup [get_cells $keep_hier] false
