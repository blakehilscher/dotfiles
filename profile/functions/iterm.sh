select_pane_above(){ tell_iterm 'tell application "System Events" to keystroke (ASCII character 30) using {command down, option down}' }
select_pane_below(){ tell_iterm 'tell application "System Events" to keystroke (ASCII character 31) using {command down, option down}' }
select_pane_left(){ tell_iterm 'tell application "System Events" to keystroke (ASCII character 28) using {command down, option down}' }
select_pane_right(){ tell_iterm 'tell application "System Events" to keystroke (ASCII character 29) using {command down, option down}' }

split_pane_horizontal(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate current session
    tell (current terminal)
        tell application "System Events" to keystroke "d" using {command down, shift down}
        tell the current session
            write text "cd ${CURRENT_DIR}"
            write text "${1}"
        end tell
        
    end tell
end tell
EOF
}

split_pane_vertical(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate current session
    tell (current terminal)
        tell application "System Events" to keystroke "d" using command down
        tell the current session
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

tell_iterm(){
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate
    tell (current terminal)
        $1
    end tell
end tell
EOF
}