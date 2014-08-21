function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


function gi() {
  curl http://www.gitignore.io/api/$@ > .gitignore
}