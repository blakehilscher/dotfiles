alias quandl_forward_staging_pg='ssh -i "/Users/blake/.ssh/quandl_3.pem" -L 5558:localhost:5432 ubuntu@54.234.46.46'
alias quandl_reinstall_gems='for i in [command format client data babelfish operation logger]; do gem uninstall -aIx "quandl_$i"; done; gem install quandl_command'
alias q='quandl'

alias ki='knife into '

alias g='goto'

alias flushhosts='dscacheutil -flushcache;sudo killall -HUP mDNSResponder'

alias mate='sublime'