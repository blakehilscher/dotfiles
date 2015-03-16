alias g='goto'

alias flushhosts='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias mate='sublime'

alias reload='source ~/.bash_profile'

alias ssh-cp-api='nw "aws-ssh api 1a"; nt "aws-ssh api 1e";'
alias ssh-cp-apps='nw "aws-ssh app 1a"; nt "aws-ssh app 1e";'
alias ssh-cp-jobs='nw "aws-ssh jobs exp 1a"; nt "aws-ssh jobs exp 1e"; nt "aws-ssh jobs rec 1a"; nt "aws-ssh jobs rec 1e";'
alias ssh-cp-all='nw "aws-ssh jobs exp 1a"; nt "aws-ssh jobs exp 1e"; nt "aws-ssh jobs rec 1a"; nt "aws-ssh jobs rec 1e"; nt "aws-ssh api 1a"; nt "aws-ssh api 1e"; nt "aws-ssh app 1a"; nt "aws-ssh app 1e"; nt "aws-ssh twilio 1a"; nt "aws-ssh twilio 1e";'


alias z='zeus'

alias zt='zoho time'

function boot_cp (){
  goto -cc
  bundle
  migrate
  sleep 0.5
  new_window "bundle exec rails server"
  newtab "bundle exec rails console"
  newtab "bundle exec zeus start"
  newtab "bundle exec sidekiq -C config/sidekiq.yml"
  newtab "bundle exec rake sunspot:solr:start; git status"
}