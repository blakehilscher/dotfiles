alias quandl_forward_staging_pg='ssh -i "/Users/blake/.ssh/quandl_3.pem" -L 5558:localhost:5432 ubuntu@54.234.46.46'
alias quandl_reinstall_gems='for i in [command format client data babelfish operation logger]; do gem uninstall -aIx "quandl_$i"; done; gem install quandl_command'

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

function quandl_ssh_staging_cassandra (){
  split_horizontal "knife into staging-cassandra-1.2" 
  split_horizontal "knife into staging-cassandra-2.1"
  split_vertical "knife into staging-cassandra-2.2"
  split_horizontal "knife into staging-cassandra-3.1"
  split_horizontal "knife into staging-cassandra-3.2"
  knife into staging-cassandra-1.1
}