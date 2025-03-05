## run this after opening a design
set cellHigPins ""
foreach_in_collection cell [get_cells * -hier] {
    if {[get_property [get_cells $cell] pin_count] > 4} {
        lappend cellHigPins [get_object_name $cell]
    }
}

puts "the cells that used where the pins are greated than 4 : [lsort [get_property [get_lib_cells -of $cellHigPins] name]]"

