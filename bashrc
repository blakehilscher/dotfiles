[[ -s "/etc/bashrc" ]] && . /etc/bashrc

export EDITOR=/usr/bin/vi
export PATH=$PATH:$HOME/bin
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=$JRUBY_HOME/bin:$PATH

export NODE_PATH=/usr/local/lib/node_modules:$NODE_PATH

export CQLSH_HOST="192.168.33.10"
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export EC2_PRIVATE_KEY=$EC2_HOME/pk-blake.pem
export EC2_CERT=$EC2_HOME/cert-blake.pem
export EC2_SSH_PRIVATE_KEY=~/.ssh/quandl_3.pem

[[ -s "/usr/libexec/java_home" ]] && export JAVA_HOME="`/usr/libexec/java_home`"

# include private keys
[[ -s "$HOME/.private/keys.bash" ]] && source "$HOME/.private/keys.bash"

# include rvm
rvm_project_rvmrc=1
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting