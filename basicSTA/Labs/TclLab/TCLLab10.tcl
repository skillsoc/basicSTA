
proc getBufInvNumber {} {
set bufPats {BUF_*}
set invPats {INV_*}

set bufList ""
foreach bufPat [list $bufPats] {
    set cells [get_object_name [get_cells * -filter "ref_name =~ $bufPat"]]
    foreach cell $cells {
        lappend bufList $cell
    }
}


set invList ""
foreach bufPat [list $invPats] {
    set cells [get_object_name [get_cells * -filter "ref_name =~ $bufPat"]]
    foreach cell $cells {
        lappend invList $cell
    }
}

puts "Numberr of buffers : [llength $bufList]"
puts "Numberr of inverters : [llength $invList]"
}




proc getSPEP {numberOfPaths} {
redirect  -variable rpts {report_timing -max_path $numberOfPaths}
foreach lines [split $rpts "\n"] {
    if {[regexp "Startpoint: .*" $lines]} {
        regexp "Startpoint: (.*)" $lines match startpoint
    } elseif {[regexp "Endpoint: .*" $lines]} {
        regexp "Endpoint: (.*)" $lines match endpoint
    } elseif {[regexp "Slack:=.*" $lines ]} {
        regexp "Slack:=(.*)" $lines match slack
        puts "Startpoint: $startpoint :: Endpoint: $endpoint :: slack : $slack"
    }
}
}



proc vtPercentage {} {
    set total_cells [sizeof_collection [get_cells *  -hierarchical -filter "is_hierarchical == false"]]
    set lvtCells [sizeof_collection [get_cells * -filter "ref_name =~ *_L"]]
    set lvtPercentage [expr [expr $lvtCells / $total_cells ] * 100]
    puts "the LVT percentage is $lvtPercentage"
}



