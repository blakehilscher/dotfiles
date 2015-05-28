alias g='goto'

alias flushhosts='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias mate='sublime'

alias reload='source ~/.bash_profile'

alias z='zoho'

alias gallerize='gallerize_cli; rsync_photos -o'

function boot_cp (){
  goto -cc
  bundle
  migrate
  sleep 0.5
  new_window "bundle exec rails server"
  newtab "bundle exec rails console"
  newtab "bundle exec sidekiq -C config/sidekiq.yml"
  newtab "bin/number_pool_recycler"
  newtab "bundle exec rake sunspot:solr:start; clear; git status"
}

function ssh_cp(){
  aws-tools ssh -e sips staging debug bot solr
}

function encrypt(){
  tar -cz $1 | gpg -c -o $1.tgz.gpg
}

function decrypt(){
  gpg -d $1 | tar xz
}