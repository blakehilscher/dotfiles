if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

set -o vi
set -o notify
set -o noclobber
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob        # Necessary for programmable completion.

# Disable options:
shopt -u mailwarn
unset MAILCHECK         # Don't want my shell to warn me of incoming mail.

export SVN_EDITOR=vi
export CLICOLOR=1

export GREP_OPTIONS='--color=auto'

#Git Repositories
export GHIL=gitolite@hilscher.ca
export GHUB=git@github.com:blakehilscher
export GQ=git@github.com:quandl/

source "$DOTFILES_DIR/profile/aliases.sh"
source "$DOTFILES_DIR/profile/colors.sh"
source "$DOTFILES_DIR/profile/functions.sh"