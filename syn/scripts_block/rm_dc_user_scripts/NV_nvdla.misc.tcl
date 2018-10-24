# change collection to list
proc c2l {collection} {
   set my_list {}
   foreach_in_collection coll_element $collection {
     set element [get_object_name $coll_element]
     lappend my_list $element
   }
   return $my_list
}

set_cost_priority -delay

set_critical_range 0.25 [current_design]

set_max_fanout 32 [current_design]

