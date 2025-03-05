# Open the file and read its entire content into a variable
set fileName "tempus.logv11"
set fileId [open $fileName r]
set fileContent [read $fileId]
close $fileId

# Define the regex pattern
set pattern ".*Ending \"Tempus Timing Solution\" \(totcpu=(.*), real=(.*), mem=(.*M).*"


foreach line [split $fileContent "\n"] {
    if {[regexp -all $pattern $fileContent matches]} {
        puts "#######"
        puts $line
        return
    }
}
# Use regex to extract all matches from the file content
