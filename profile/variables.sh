DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for file in $DIR/variables/*.sh; do
  source "$file"
done
unset file