alias r='ruby'
alias b='bundle exec'
alias lb='BUNDLE_LOCAL_GEMS=true bundle exec'
alias br='bundle exec ruby'

alias bspec='b rspec --color -f d'
alias lbspec='lb rspec --color -f d'

alias bundle!='gem install bundler;bundle;'
alias lbundle='BUNDLE_LOCAL_GEMS=true bundle'
alias gem_push='rm *.gem; gem build *.gemspec; gem push *.gem'

alias vmizuno='APP_ENV=vagrant mizuno'
alias vrails='RAILS_ENV=vagrant rails'
alias vrake='RAILS_ENV=vagrant rake'
alias trake='RAILS_ENV=test rake'

alias rebuild_test_db='rake db:drop RAILS_ENV=test; rake db:create RAILS_ENV=test; rake db:migrate RAILS_ENV=test; rake db:seed RAILS_ENV=test;'

# Server

alias startnginx='sudo /opt/nginx/sbin/nginx' 
alias stopnginx='sudo kill `cat /opt/nginx/logs/nginx.pid `' 
alias restartnginx='stopnginx; startnginx'

alias restart_unicorn_rails='test -s "/var/run/unicorn/master.pid" && kill `cat /var/run/unicorn/master.pid`
bundle exec unicorn -c /etc/unicorn.cfg -D'