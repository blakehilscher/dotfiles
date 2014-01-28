function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function g()
{
  case $1 in
  c)
    cd ~/chef/chef-repo/;;
  cm)
    cd ~/chef/11/;;
  g)
    cd ~/www/gems;;
  gq)
    cd ~/www/gems/quandl;;

  qc)
    cd ~/www/gems/quandl_cassandra;;
  qcm)
    cd ~/www/gems/quandl_cassandra_models;;
  h)
    cd ~/www/hilscher/;;
  n)
    cd /opt/nginx/;;
  q)
    cd ~/www/quandl/;;
  w)
    cd ~/www/quandl/wikiposit/;;
  wu)
    cd ~/www/quandl/wikiposit-utilities/;;
  wc)
    cd ~/www/quandl/wikiposit_cassandra/;;
  s)
    cd ~/user_settings/;;
  esac
  if [ $2 ];then
    cd $2
  fi
}
function bg_exec() {
  LOG="$HOME/logs/bg_exec.log"
  eval "$1 >> $LOG &"
}

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
# File & string-related functions:
#-------------------------------------------------------------


# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#-------------------------------------------------------------
# Process/system related functions:
#-------------------------------------------------------------

function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function gkill () {
  local pid=$(ps aux | grep $1 | awk '{print $2}')
  echo "killing $(ps aux | grep $1 | awk '{print $2, $11}')"
  kill -9 $pid
}

function pbcat () {
  cat $1 | pbcopy
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

