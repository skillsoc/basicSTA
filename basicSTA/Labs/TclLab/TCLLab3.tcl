
proc getHighestDelayCell {} {
    set p [report_timing -collection]
    ## we are using 2 variables here please not foreach ele1 $list1 ele2 $list2 
    set delMax 0
    set instance ""
foreach name [get_property [get_property $p timing_points] hierarchical_name ] del [get_property [get_property $p timing_points] delay] {
    #puts "$del $name"
    if {$del > $delMax} {
        set delMax $del
        set instance $name
    }
}
puts "$instance $delMax"
}


