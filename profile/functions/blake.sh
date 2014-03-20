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