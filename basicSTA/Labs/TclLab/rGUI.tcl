# Create the main window
wm title . "Simple Grid-based GUI"

# Add a label to the grid
label .lbl -text "Enter your name:"
grid .lbl -row 0 -column 0 -padx 10 -pady 10

# Add an entry widget to accept user input
entry .entry -width 30
grid .entry -row 0 -column 1 -padx 10 -pady 10

# Add a button to submit the input
button .btn_submit -text "Submit" -command {
    set name [.entry get]
    tk_messageBox -message "Hello, $name!"
}
grid .btn_submit -row 1 -column 0 -padx 10 -pady 10

# Add a button to quit the application
button .btn_quit -text "Quit" -command { exit }
grid .btn_quit -row 1 -column 1 -padx 10 -pady 10

# Run the application

