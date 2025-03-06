
proc getMemoryLog {logFile} {
    puts "this proc helps in getting the peak memory from the log file"
    set fil [open $logFile r]
    set lines [read $fil]
    set pattern {.*Current mem =\s+(\d+.\d+)M, initial mem =\s+(\d+.\d+)M.*}
    set peakMem 0
    foreach line [split $lines "\n"] {
        if {[regexp $pattern $line -> cm im]} {
            if {$cm > $peakMem} {
                set peakMem $cm
            } elseif {$im > $peakMem} {
                set peakMem $im
            }
            puts $line
        }
    }
    puts "the peak memory used by the run is $peakMem MB"
}



