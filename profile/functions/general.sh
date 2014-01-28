# Execute in the background
# bg_exec rspec

function bg_exec() {
  LOG="$HOME/logs/bg_exec.log"
  eval "$1 >> $LOG &"
}

# Run a command against every matched arg
# each "git log | head -2" ~/path/to/repositories/*

function each()
{
  SRC_DIR=$(pwd)
  COMMAND=$1

  args=("$@")
  for ((i=1; i < $#; i++)) {
    DIR="$SRC_DIR/${args[$i]}"
    result=$(eval "cd $DIR; $COMMAND")
    echo -e "\n${COLOR_LIGHT_GRAY}---- $DIR $COLOR_GREEN\n $result"
  }
  cd $SRC_DIR
}

#-------------------------------------------------------------
# Misc utilities:
#-------------------------------------------------------------

function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}

#-------------------------------------------------------------
# Greeting, motd etc...
#-------------------------------------------------------------

# --> Nice. Has the same effect as using "ansi.sys" in DOS.

function _exit()        # Function to run upon exit of shell.
{
    echo -e "Hasta la vista"
}
trap _exit EXIT

