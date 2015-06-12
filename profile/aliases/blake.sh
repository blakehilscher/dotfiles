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