alias gits='git status'
alias gita='git add .'
alias gitc='git commit -m'
alias gitcam='gita; gitc'
alias gitb='git branch'
alias gitco='git checkout'
alias gitm='git merge --no-ff'
alias gitd='git diff --color --color-words'
alias grhh='git reset HEAD --hard'
alias gitsma='git submodule add'

# Functions
alias gitrm='git status | grep deleted | cut -c 15- | xargs git rm'
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitfiles='git show --pretty="format:" --name-only '
alias gitexport='git archive --format zip --output source-tree-master.zip master '

# Push / Pull
alias gpso='git push origin '
alias gpl='git pull --rebase'
alias gplo='gpl origin '
alias gpsom='gpso master'
alias gplom='gplo master'
alias gplos='gplo staging'
alias gpsod='gpso develop'
alias gpsos='gpso staging'
alias gplod='gplo develop'
alias gpsor='gpso release'
alias gplor='gplo release'
alias gpshm='git push heroku master'

alias gpsb='git_push_branch'
alias gplb='git_pull_branch'


# Merge
alias gcp='git cherry-pick'
alias gcpm='git cherry-pick -m1'

# Checkout
alias gitcod='gitco develop'
alias gitcos='gitco staging'
alias gitcor='gitco release'
alias gitcom='gitco master'
alias gitcob='gitco -b '
alias pbgitl='git log --abbrev-commit --pretty=oneline | head -2 | pbcopy'
# Git Flow
alias gitfs='git flow feature start '
alias gitff='git flow feature finish '
alias giths='git flow hotfix start '
alias githf='git flow hotfix finish '
alias gitrs='git flow release start '
alias gitrf='git flow release finish '

alias gcl='git_clone'
alias grco='git_regex_checkout'

alias git_prune_master_branches="git branch --merged master | grep -v 'master$' | xargs git branch -d"

alias gco='git_regex_checkout'