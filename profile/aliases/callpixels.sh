
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

function cp_production_console()
{
  aws-tools ssh -m api -f "/bin/bash -l -c 'cd /srv/callpixels.com/current && bundle exec rails console production'"
}