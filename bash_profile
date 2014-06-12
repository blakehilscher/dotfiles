for file in $HOME/.customize_profile/*.sh; do
  source "$file"
done
unset file

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export DOTFILES_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "$DOTFILES_DIR/bashrc"
source "$DOTFILES_DIR/profile/settings.sh"
source "$DOTFILES_DIR/profile/variables.sh"
source "$DOTFILES_DIR/profile/aliases.sh"
source "$DOTFILES_DIR/profile/colors.sh"
source "$DOTFILES_DIR/profile/functions.sh"
source "$DOTFILES_DIR/profile/completion.sh"

[[ -s "$HOME/.remote_profile" ]] && source "$HOME/.remote_profile"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function
# Added by Quandl Toolbelt
PATH="/usr/local/quandl/bin:$PATH"

export EDITOR=vim