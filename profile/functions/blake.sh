function g()
{
  case $1 in
  c)
    cd ~/chef/chef-repo/;;
  cm)
    cd ~/chef/11/;;
  g)
    cd ~/www/gems;;
  gq)
    cd ~/www/gems/quandl;;

  qc)
    cd ~/www/gems/quandl_cassandra;;
  qcm)
    cd ~/www/gems/quandl_cassandra_models;;
  h)
    cd ~/www/hilscher/;;
  n)
    cd /opt/nginx/;;
  q)
    cd ~/www/quandl/;;
  w)
    cd ~/www/quandl/wikiposit/;;
  wu)
    cd ~/www/quandl/wikiposit-utilities/;;
  wc)
    cd ~/www/quandl/wikiposit_cassandra/;;
  s)
    cd ~/user_settings/;;
  esac
  if [ $2 ];then
    cd $2
  fi
}

function quandl_ssh_cassandra () {
  NAME="$1-cassandra"
  new_window "knife into $NAME-1.1"
  split_pane_vertical "knife into $NAME-1.2"
  split_pane_horizontal "knife into $NAME-2.2"
  split_pane_horizontal "knife into $NAME-3.2"
  select_pane_left
  split_pane_horizontal "knife into $NAME-2.1"
  split_pane_horizontal "knife into $NAME-3.1"
  broadcast_input_to_panes
}

function quandl_gems_bundle_update () {
  gems=(logger operation data babelfish cassandra cassandra_models client format command)
  # iterate over each gem
  for gem in ${gems[@]}; do
    echo "bundle update quandl/${gem}"
    cd "$BUNDLE_LOCAL_DIR/quandl/${gem}" && bundle update | tail -1
    echo "---"
  done
}

function quandl_gems_lbspec (){
  gems=(logger operation data babelfish cassandra cassandra_models client format command)
  # iterate over each gem
  for gem in ${gems[@]}; do
    echo "Running quandl/${gem}"
    quandl_gem_lbspec "quandl/${gem}" | tail -2
    echo "---"
  done
}

function quandl_gems_bspec (){
  gems=(logger operation data babelfish cassandra cassandra_models client format command)
  # iterate over each gem
  for gem in ${gems[@]}; do
    echo "Running quandl/${gem}"
    quandl_gem_bspec "quandl/${gem}" | tail -2
    echo "---"
  done
}

function quandl_gem_lbspec (){
  echo "cd $BUNDLE_LOCAL_DIR/$1 && lbspec"
  cd "$BUNDLE_LOCAL_DIR/$1"
  BUNDLE_LOCAL_GEMS=true bundle exec rspec --color -f d
}

function quandl_gem_bspec (){
  echo "Running $1"
  cd "$BUNDLE_LOCAL_DIR/$1" && bspec
}