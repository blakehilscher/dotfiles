alias gem_push='rm *.gem; gem build *.gemspec; gem push *.gem'
function gem_publish (){
  gitcam "Release $1. $2"
  git tag -a $1 -m "$2"
  git push --tags
  git push origin master
  gem_push
}

migrate() {
  bundle exec rake db:migrate &
  RAILS_ENV=test bundle exec rake db:migrate 
}

rollback() { 
  local steps=$1;
  if [ -z "$1" ]
    then
    steps=1;
  fi
  echo "steps=$steps"
  bundle exec rake db:rollback STEPS=$steps &
  RAILS_ENV=test bundle exec rake db:rollback STEPS=$steps
}
