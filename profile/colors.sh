export LS_COLORS=HxbxcxdxHxegedabagacad
export LSCOLORS=HxbxcxdxHxegedabagacad

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local      YELLOW="\[\033[0;33m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  
  # Color the Prompt
  LESS='\e[1;37m' #gray
  SOME='\e[0;32m' #green
  MORE='\e[1;33m' #yellow
  HIGH='\e[1;36m'
  ROOT='\e[1;31m'
  TEXT='\e[m'
  
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
  
  PS1="$LIGHT_GRAY\$(parse_git_branch)$GREEN\w$BLUE${TITLEBAR}$GREEN\$ \[\033[0m\]"
  PS2='> '
  PS4='+ '
}
proml
