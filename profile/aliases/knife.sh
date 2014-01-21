#--------------------------
# General
#--------------------------

alias kn='knife'



#--------------------------
# Sever Management
#--------------------------

alias knssh='knife ssh -x ubuntu -a cloud.public_ipv4 -i ~/.ssh/quandl_3.pem'

alias kssh_staging_cassandra='knssh "role:quandl_cassandra AND chef_environment:staging"'
alias kssh_staging_app='knssh "role:quandl_app_server AND chef_environment:staging"'
alias kssh_staging_api='knssh "role:quandl_api_server AND chef_environment:staging"'
alias kssh_staging_capture='knssh "role:quandl_capture AND chef_environment:staging"'

alias kssh_production_cassandra='knssh "role:quandl_cassandra AND chef_environment:production"'
alias kssh_production_app='knssh "role:quandl_app_server AND chef_environment:production"'
alias kssh_production_api='knssh "role:quandl_api_server AND chef_environment:production"'
alias kssh_production_capture='knssh "role:quandl_capture AND chef_environment:production"'

alias kssh_production_cassandra_describe="kssh_production_cassandra 'echo \"| \$(hostname) | \$CASSANDRA_PLACEMENT\" ' "
alias kssh_staging_cassandra_describe="kssh_staging_cassandra 'echo \"| \$(hostname) | \$CASSANDRA_PLACEMENT\" ' "



#--------------------------
# Chef Repo Management
#--------------------------

alias knc='kn cookbook'
alias kne='kn environment'
alias knr='kn role'
alias knd='kn data bag'
alias knn='kn node'

alias kncu='knc upload'
alias kneu='kne from file'
alias knru='knr from file'
alias kndu='knd from file'

alias kncs='knc show'
alias knes='kne show'
alias knrs='knr show'
alias knds='knd show'
alias knns='knn show'

alias kncc='knc create'
alias knec='kne create'
alias knrc='knr create'
alias kndc='knd create'

alias kncd='knc delete'
alias kned='kne delete'
alias knrd='knr delete'
alias kndd='knd delete'

alias kndus='kndu --secret-file ~/.chef/data_bag_key'
alias kndss='knd show --secret-file ~/.chef/data_bag_key'