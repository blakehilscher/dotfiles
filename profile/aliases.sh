#-------------------
# Personnal Aliases
#-------------------

alias r='ruby'
alias b='bundle exec'
alias lb='BUNDLE_LOCAL_GEMS=true bundle exec'
alias br='bundle exec ruby'
alias tf='tail -f'

# -> Prevents accidentally clobbering files.
alias ssh='la ~/.ssh/id_rsa.pub; ssh '
alias mkdir='mkdir -p'

alias h='history'
alias j='jobs -l'
alias which='type -a'
alias ..='cd ..'
alias cd..='cd ..'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'

alias cw='compass watch'
alias m='mate .'
alias o='open .'

alias v='vagrant'
alias vs='ssh blake@192.168.33.10'

alias psg='ps aux | grep '
alias pgrep='ps -ef | grep irssi | grep -v grep | awk ‘{print $2}’'
alias break2comma='while read line; do echo -n "$line,"; done'

alias forward_staging_pg='ssh -i "/Users/blake/.ssh/quandl_3.pem" -L 5558:localhost:5432 ubuntu@54.234.46.46'

#--------------------------
# Version Control Aliases
#--------------------------


alias gits='git status'
alias gita='git add .'
alias gitc='git commit -m'
alias gitcam='git add .; git commit -m'
alias gitrm='git status | grep deleted | cut -c 15- | xargs git rm'
alias gitb='git branch'
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitco='git checkout'
alias gitm='git merge --no-ff'
alias gcl='git clone '
alias gpso='git push origin '
alias gplo='git pull origin '
alias gpsom='gpso master'
alias gplom='gplo master'
alias gplos='gplo staging'
alias gpsod='gpso develop'
alias gpsos='gpso staging'
alias gplod='gplo develop'
alias gpsor='gpso release'
alias gplor='gplo release'
alias gpshm='git push heroku master'
alias gcp='git cherry-pick'
alias gcpm='git cherry-pick -m1'
alias gitfiles='git show --pretty="format:" --name-only '
alias gitexport='git archive --format zip --output source-tree-master.zip master '
alias gitd='git diff --color --color-words'
alias grhh='git reset HEAD --hard'
alias gitcod='gitco develop'
alias gitcos='gitco staging'
alias gitcor='gitco release'
alias gitcom='gitco master'
alias gitsma='git submodule add'

alias bspec='b rspec --color -f d'
alias lbspec='lb rspec --color -f d'

# Git Flow
alias gitfs='git flow feature start '
alias gitff='git flow feature finish '
alias giths='git flow hotfix start '
alias githf='git flow hotfix finish '
alias gitrs='git flow release start '
alias gitrf='git flow release finish '

# SVN
alias svna='svn add . --force'
alias svnc='svn commit -m'
alias svnco='svn checkout'
alias svncf='svn commit -m "updated"'
alias svni='svn propedit svn:ignore'
alias svns='svn status'
alias svnu='svn up'
alias svnrmw='rm -rf `find . -type d -name .svn`'

alias kn='knife'

alias knssh='knife ssh -x ubuntu -a cloud.public_ipv4 -i ~/.ssh/quandl_3.pem'
alias knc='kn cookbook'
alias kne='kn environment'
alias knr='kn role'
alias knd='kn data bag'
alias knn='kn node'

alias kncu='knc upload'
alias kneu='kne from file'
alias knru='knr from file'
alias kndu='knd from file'


alias kncs='knc show'
alias knes='kne show'
alias knrs='knr show'
alias knds='knd show'
alias knns='knn show'

alias kncc='knc create'
alias knec='kne create'
alias knrc='knr create'
alias kndc='knd create'

alias kncd='knc delete'
alias kned='kne delete'
alias knrd='knr delete'
alias kndd='knd delete'

alias kndus='kndu --secret-file ~/.chef/data_bag_key'
alias kndss='knd show --secret-file ~/.chef/data_bag_key'

alias chef-client-staging='knssh "role:quandl_app_server AND chef_environment:staging" "sudo chef-client"'

# RVM
alias rvmrc='rvm --rvmrc --create'
alias bundle!='gem install bundler;bundle;'
alias lbundle='BUNDLE_LOCAL_GEMS=true bundle'
alias gem_push='rm *.gem; gem build *.gemspec; gem push *.gem'

alias vmizuno='APP_ENV=vagrant mizuno'
alias vrails='RAILS_ENV=vagrant rails'
alias vrake='RAILS_ENV=vagrant rake'
alias trake='RAILS_ENV=test rake'

alias rebuild_test_db='rake db:drop RAILS_ENV=test; rake db:create RAILS_ENV=test; rake db:migrate RAILS_ENV=test; rake db:seed RAILS_ENV=test;'

#-------------------------------------------------------------
# The 'ls' family (this assumes you use a recent GNU ls)
#-------------------------------------------------------------

alias l='ls'          # show hidden files
alias ll="ls -lU"
#alias ls='ls -hFC --color=auto'         # add colors for filetype recognition
alias ls='ls -hFC'         # add colors for filetype recognition
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lr='ls -lR'          # recursive ls
alias lrg='lr | grep -i'   # recursive ls, filtered by string
alias trg='tree -d | grep ' # nice alternative to 'recursive ls'
#alias tr='tree -d -L 2'    # tree but only a few levels deep
alias llg='ll | grep -i '  # filter list by string
alias lag='la | grep -i '  # filter list by string

#-------------------------------------------------------------
# spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias kk='ll'

alias startnginx='sudo /opt/nginx/sbin/nginx' 
alias stopnginx='sudo kill `cat /opt/nginx/logs/nginx.pid `' 
alias restartnginx='stopnginx; startnginx'

alias restart_unicorn_rails='test -s "/var/run/unicorn/master.pid" && kill `cat /var/run/unicorn/master.pid`
bundle exec unicorn -c /etc/unicorn.cfg -D'
