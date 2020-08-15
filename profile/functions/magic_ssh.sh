
assh() { 
  aws-tools ssh -f -m $1 $2 $3 $4
}

dssh() { 
  digital-ocean-ssh $1
}
