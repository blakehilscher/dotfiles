alias g='goto'

alias flushhosts='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias mate='sublime'

alias reload='source ~/.bash_profile'

alias z='zoho'

alias fd2='displayplacer "id:92C57C59-8F64-B15D-024B-D7C7751D136B res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:B37C636E-0682-6AA5-84C9-8306EA3621AE res:2560x1440 hz:60 color_depth:8 scaling:off origin:(-2560,0) degree:0"'
alias fd3='displayplacer "id:92C57C59-8F64-B15D-024B-D7C7751D136B res:2560x1440 hz:60 color_depth:8 scaling:off origin:(0,0) degree:0" "id:EC20DEFC-CCEB-F248-F09A-F2974161C28D res:1792x1120 hz:59 color_depth:4 scaling:on origin:(2560,73) degree:0" "id:B37C636E-0682-6AA5-84C9-8306EA3621AE res:2560x1440 hz:60 color_depth:8 scaling:off origin:(-2560,-108) degree:0"'

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


alias asshall='aws-tools ssh -m "portal|tel|sms|rpc"'

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