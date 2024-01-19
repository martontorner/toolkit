DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#----------------------------- VARIABLES --------------------------------
. "$DIR"/../shell/tools/variables.sh
. "$DIR"/tools/variables.sh
#------------------------------ ALIASES ---------------------------------
. "$DIR"/../shell/tools/aliases.sh
#----------------------------- FUNCTIONS --------------------------------
. "$DIR"/../shell/tools/functions.sh
#------------------------------- TMUX -----------------------------------
. "$DIR"/../shell/tools/tmux.sh
#------------------------------ BANNER ----------------------------------
. "$DIR"/../shell/tools/banner.sh
#---------------------------- COMPLETIONS -------------------------------
. "$DIR"/tools/completions.sh
#------------------------------ PROMPT ----------------------------------
. "$DIR"/tools/prompt.sh
