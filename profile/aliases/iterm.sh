split_horizontal(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate
    tell (current terminal)
        tell application "System Events" to keystroke "d" using {command down, shift down}
        tell the last session
            write text "cd ${CURRENT_DIR}"
            write text "${1}"
        end tell
        
    end tell
end tell
EOF
}

split_vertical(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate
    tell (current terminal)
        tell application "System Events" to keystroke "d" using command down
        tell the last session
            write text "cd ${CURRENT_DIR}"
            write text "${1}"
        end tell
        
    end tell
end tell
EOF
}

newtab(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    make new terminal
    tell the current terminal
        activate current session
        launch session "Default Session"
        tell the last session
            write text "cd ${CURRENT_DIR}"
            write text "${1}"
        end tell
    end tell
end tell
EOF
}