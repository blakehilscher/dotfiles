newtab(){
/usr/bin/osascript <<-EOF
tell application "iTerm"
    make new terminal
    tell the current terminal
        activate current session
        launch session "Default Session"
        tell the last session
            write text "${1}"
        end tell
    end tell
end tell
EOF
}