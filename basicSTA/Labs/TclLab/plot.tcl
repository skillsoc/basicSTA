proc displayPlot {x y s} {
    toplevel .plotWin${s}
    wm title .plotWin${s} "Line Graph Example"

    # Create a main frame for layout
    frame .plotWin${s}.mainFrame
    grid .plotWin${s}.mainFrame -row 0 -column 0 -sticky news

    # Create a canvas for the plot
    canvas .plotWin${s}.mainFrame.canvas -width 800 -height 500 -bg white
    grid .plotWin${s}.mainFrame.canvas -row 0 -column 0 -padx 10 -pady 10 -sticky news

    # Create a Close button
    button .plotWin${s}.mainFrame.btnClose -text "Close" -command {destroy .plotWin${s}}
    grid .plotWin${s}.mainFrame.btnClose -row 1 -column 0 -padx 10 -pady 10 -sticky e

    # Define plot dimensions
    set canvasWidth 800
    set canvasHeight 500
    set margin 50
    #set x {
    #    0.00 0.06 0.125 0.17 0.27 0.39 0.53 0.68
    #    0.86 10.7 13.0 15.6 17.0 17.8 18.4
    #}
    #set y {
    #    0.00000 0.01600 0.04000 0.08000 0.16000 0.24000 0.32000
    #    0.40000 0.48000 0.56000 0.64000 0.72000 0.76000 0.78400 0.80000
    #}

    # Get the min and max values of x and y
    set xMin [lindex [lsort -real $x] 0]
    set xMax [lindex [lsort -real $x] end]
    set yMin [lindex [lsort -real $y] 0]
    set yMax [lindex [lsort -real $y] end]

    # Draw axes
    .plotWin${s}.mainFrame.canvas create line $margin [expr $canvasHeight - $margin] [expr $canvasWidth - $margin] [expr $canvasHeight - $margin] -width 2
    .plotWin${s}.mainFrame.canvas create line $margin [expr $canvasHeight - $margin] $margin $margin -width 2

    # Add X and Y axis labels
    .plotWin${s}.mainFrame.canvas create text [expr $canvasWidth - $margin + 20] [expr $canvasHeight - $margin + 10] -text "X- Time" -anchor nw
    .plotWin${s}.mainFrame.canvas create text [expr $margin - 20] $margin -text "Y- Voltage" -anchor ne

    # Scaling factors
    set scaleX [expr ($canvasWidth - 2 * $margin) / double($xMax - $xMin)]
    set scaleY [expr ($canvasHeight - 2 * $margin) / double($yMax - $yMin)]

    # Add 10 X-axis ticks and values
    for {set i 0} {$i <= 10} {incr i} {
        set xValue [expr $xMin + ($xMax - $xMin) * $i / 10.0]
        set xPos [expr $margin + ($xValue - $xMin) * $scaleX]
        .plotWin${s}.mainFrame.canvas create line $xPos [expr $canvasHeight - $margin - 5] $xPos [expr $canvasHeight - $margin + 5] -width 1
        .plotWin${s}.mainFrame.canvas create text $xPos [expr $canvasHeight - $margin + 15] -text [format "%.2f" $xValue] -anchor n
    }

    # Add 10 Y-axis ticks and values
    for {set i 0} {$i <= 10} {incr i} {
        set yValue [expr $yMin + ($yMax - $yMin) * $i / 10.0]
        set yPos [expr $canvasHeight - $margin - ($yValue - $yMin) * $scaleY]
        .plotWin${s}.mainFrame.canvas create line [expr $margin - 5] $yPos [expr $margin + 5] $yPos -width 1
        .plotWin${s}.mainFrame.canvas create text [expr $margin - 15] $yPos -text [format "%.3f" $yValue] -anchor e
    }

    # Plot points and lines
    for {set i 0} {$i < [llength $x] - 1} {incr i} {
        set x1 [expr $margin + ([lindex $x $i] - $xMin) * $scaleX]
        set y1 [expr $canvasHeight - $margin - ([lindex $y $i] - $yMin) * $scaleY]
        set x2 [expr $margin + ([lindex $x [expr $i + 1]] - $xMin) * $scaleX]
        set y2 [expr $canvasHeight - $margin - ([lindex $y [expr $i + 1]] - $yMin) * $scaleY]

        .plotWin${s}.mainFrame.canvas create line $x1 $y1 $x2 $y2 -fill blue -width 2
        .plotWin${s}.mainFrame.canvas create oval [expr $x1 - 3] [expr $y1 - 3] [expr $x1 + 3] [expr $y1 + 3] -fill red
    }
}

# Main application entry
#


proc processWaveformDataToNS {data} {
    # Initialize X and Y variables
    set x {}
    set y {}

    # Loop through the data and separate odd indices (X) and even indices (Y)
    set i 0
    foreach value $data {
        # Convert scientific notation to nanoseconds (uniformly)
        if {[string match *e-* $value]} {
            set exponentIndex [string first "e" $value]
            set base [string range $value 0 [expr $exponentIndex - 1]]
            set exponent [string range $value [expr $exponentIndex + 1] end]
            set value [expr $base * pow(10, $exponent) * 1e9] ;# Convert to nanoseconds
        } else {
            set value [expr $value * 1e9] ;# If already in seconds, convert to nanoseconds
        }

        # Alternate between X and Y
        if {$i % 2 == 0} {
            lappend x $value
        } else {
            lappend y [expr $value / 1000000000]
        }
        incr i
    }

    # Output the processed X and Y variables
    return [list $x $y]
}

# Input "Rise Waveform" data
#

proc plotDleayCalc {from to {p "in"} {t "Rise"}} {
redirect -variab delayCalc {report_delay_calculation -from $from -to $to -waveform }

if {$p == "in"} {
set flag 1
} else {
set flag 2
}

foreach line [split $delayCalc "\n"] {
    if {[regexp "${t} Waveform.*{(.*)}" $line -> rawData]} {
    # Process the data
    set result [processWaveformDataToNS $rawData]
    set x [lindex $result 0]
    set y [lindex $result 1]

    # Print the results
    puts "X Values (in nanoseconds): $x"
    puts "Y Values (in nanoseconds): $y"
        if {$flag == 1} {
            displayPlot $x $y $p
        } else {
            set flag [expr $flag - 1]
        }
    }
}
}


