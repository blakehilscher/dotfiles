function goto () {
  cd "$(ruby $DOTFILES_DIR/profile/bin/goto.rb $@)"
}

function current_ip {
  wget -q -O - checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'
}
