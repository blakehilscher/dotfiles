alias gem_push='rm *.gem; gem build *.gemspec; gem push *.gem'
function gem_publish (){
  gitcam "Release $1. $2"
  git tag -a $1 -m "$2"
  git push --tags
  git push origin master
  gem_push
}