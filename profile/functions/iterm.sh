broadcast_input_to_panes(){
  tell_iterm 'tell application "System Events" to keystroke "i" using {command down, option down}'
  tell_iterm 'tell application "System Events" to keystroke return'
  write_iterm "echo 'WARNING: BROADCASTING INPUT TO ALL PANES'"
}

select_pane_above(){
  tell_iterm 'tell application "System Events" to keystroke (ASCII character 30) using {command down, option down}'
  write_iterm "$@"
}
select_pane_below(){
  tell_iterm 'tell application "System Events" to keystroke (ASCII character 31) using {command down, option down}'
  write_iterm "$@"
}
select_pane_left(){
  tell_iterm 'tell application "System Events" to keystroke (ASCII character 28) using {command down, option down}'
  write_iterm "$@"
}
select_pane_right(){
  tell_iterm 'tell application "System Events" to keystroke (ASCII character 29) using {command down, option down}'
  write_iterm "$@"
}

split_pane_horizontal(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm2"
    activate current session
    tell (current terminal)
        tell application "System Events" to keystroke "d" using {command down, shift down}
        tell the current session
            write text "cd ${CURRENT_DIR}"
        end tell
        
    end tell
end tell
EOF
write_iterm "$@"
}

split_pane_vertical(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm2"
    activate current session
    tell (current terminal)
        tell application "System Events" to keystroke "d" using command down
        tell the current session
            write text "cd ${CURRENT_DIR}"
        end tell
        
    end tell
end tell
EOF
write_iterm "$@"
}

new_window(){
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm2"
     activate
     set myterm to (make new terminal)
     tell myterm
         launch session "Tomorrow Night"
         tell the current session
             write text "cd ${CURRENT_DIR}"
         end tell
     end tell
end tell
EOF
write_iterm "$@"
}

newtab(){
  ttab eval "${1}"
}

write_iterm(){
if [ -n "$1" ]; then
CURRENT_DIR=$(pwd)
/usr/bin/osascript <<-EOF
tell application "iTerm"
    activate current session
    tell (current terminal)
        tell the current session
            write text "${1}"
        end tell
    end tell
end tell
EOF
fi
}

tell_iterm(){
/usr/bin/osascript <<-EOF
tell application "iTerm2"
    activate
    tell (current terminal)
        $1
    end tell
end tell
EOF
}