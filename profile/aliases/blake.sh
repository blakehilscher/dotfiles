alias g='goto'

alias flushhosts='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias mate='sublime'

alias reload='source ~/.bash_profile'

alias z='zoho'

alias gallerize='gallerize_cli; rsync_photos -o'

function encrypt(){
  tar -cz $1 | gpg -c -o $1.tgz.gpg
}

function decrypt(){
  gpg -d $1 | tar xz
}

alias gh='github'

alias gpge='gpg --encrypt --recipient blake@hilscher.ca '
alias gpgd='gpg --decrypt '

alias le='less -R'

alias find_ips="grep -R -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'"


alias rmds_store="find . -name '*.DS_Store' -type f -delete"


function restart_rails(){
  goto -rails
  utility/restart.sh
}

function brc (){
  bundle exec rails console
}


function fix_permissions(){
	find . -type d -exec chmod 755 {} \;
	find . -type f -exec chmod 644 {} \;
}

function replace_hash_rockets(){
	find . -name \*.rb -exec perl -p -i -e 's/([^:]):(\w+)\s*=>/\1\2:/g' {} \;
	find . -name \*.haml -exec perl -p -i -e 's/([^:]):(\w+)\s*=>/\1\2:/g' {} \;
}

function install_js()
{
	goto -rails
	echo "//= require $2" | cat - app/assets/javascripts/application.js > temp && mv temp app/assets/javascripts/application.js
	wget $1 -O "app/assets/plugins/$2"
}

function random_hex()
{
	printf "%04x" $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM $RANDOM
}

function html2haml_recursive()
{
	find . -name \*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml
}