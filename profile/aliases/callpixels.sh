function brc (){
  goto -cc
  bundle exec rails console
}

function boot_cp (){
  kill_cp
  prepare_cp
  start_cp
}

function restart_cp(){
  kill_cp
  start_cp
}

function kill_cp(){
  goto -cc

  gkill rails
  gkill sidekiq
  gkill number_pool_recycler
  gkill yard

}

function prepare_cp(){
  gplb
  bundle
  migrate
  sleep 0.5
}

function start_cp(){
  goto -cc

  newtab "bundle exec rails server"
  newtab "bundle exec rails console"

  nohup bundle exec sidekiq -C config/sidekiq.yml &
  nohup bundle exec RAILS_ENV=development bin/number_pool_recycler &
  nohup yard server --reload &
  nohup bundle exec rake sunspot:solr:start &

}

function ssh_cp(){
  aws-tools ssh -e sips staging debug bot solr
}

function cp_production_console()
{
  aws-tools ssh -m api -f "/bin/bash -l -c 'cd /srv/callpixels.com/current && bundle exec rails console production'"
}
