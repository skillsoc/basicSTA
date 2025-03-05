
set area ""
foreach_in_collection cell [all_registers] {
    set farea [get_property [get_cells $cell] area]
    set area [expr $farea + $area]
}

puts "the number of flops area [sizeof_collection [all_registers]] \n the total area occupied by the flops : $area"

