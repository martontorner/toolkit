echo '#----------------------------- VARIABLES --------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/tools/variables.sh)
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/tools/variables.sh)
echo '#------------------------------ ALIASES ---------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/tools/aliases.sh)
echo '#----------------------------- FUNCTIONS --------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/tools/functions.sh)
echo '#------------------------------- TMUX -----------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/tools/tmux.sh)
echo '#------------------------------ BANNER ----------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/shell/tools/banner.sh)
echo '#---------------------------- AUTOCOMPLETE ------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/tools/autocomplete.sh)
echo '#------------------------------ PROMPT ----------------------------------'
cat <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/tools/prompt.sh)
