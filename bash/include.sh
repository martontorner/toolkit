DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. "$DIR"/variables.sh
. "$DIR"/aliases.sh
. "$DIR"/functions.sh
. "$DIR"/tmux.sh

cat "$DIR"/banner.txt
echo ""

. "$DIR"/powerline.sh
