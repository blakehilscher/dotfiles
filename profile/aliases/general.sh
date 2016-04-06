alias tf='tail -f'
alias tfd='tail -f log/* | grep DEBUG'

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

alias m='sublime .'
alias o='open .'

alias psg='ps aux | grep '
alias pgrep='ps -ef | grep irssi | grep -v grep | awk ‘{print $2}’'
alias break2comma='while read line; do echo -n "$line,"; done'

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

alias bge="bg_exec"

alias pb='pushbullet'