function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

function gkill () {
  local pid=$(ps aux | grep $1 | awk '{print $2}')
  echo "killing $(ps aux | grep $1 | awk '{print $2, $11}')"
  kill -9 $pid
}

function pbcat () {
  cat $1 | pbcopy
}
