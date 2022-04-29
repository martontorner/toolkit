DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cat "$DIR"/banner.txt
echo ""

. "$DIR"/variables.sh
. "$DIR"/aliases.sh
. "$DIR"/functions.sh
. "$DIR"/tmux.sh

. "$DIR"/powerline.sh
