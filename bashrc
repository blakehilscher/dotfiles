[[ -s "/etc/bashrc" ]] && . /etc/bashrc

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

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
export JAVA_HOME="`/usr/libexec/java_home`"

[[ -s "$DIR/private/keys.bash" ]] && source "$DIR/private/keys.bash"

rvm_project_rvmrc=1
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting