if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

source "$DOTFILES_DIR/profile/settings.sh"
source "$DOTFILES_DIR/profile/variables.sh"
source "$DOTFILES_DIR/profile/aliases.sh"
source "$DOTFILES_DIR/profile/colors.sh"
source "$DOTFILES_DIR/profile/functions.sh"