set -e

# Change to repo in ~/git/ directory
function cd_repo () {
  if [ -z "$1" ]; then
    echo "cd_repo: Change to repo in ~/git/ directory

Usage: cd_repo <name>
"

    return;
  fi

  cd ~/git/$1
}
alias cdr='cd_repo'


# Print ASCII table (decimal (d), octal (o), hex (h)) - works only for MAC
function ascii () {
  if [ -z "$1" ]; then
    echo "ascii: Print ASCII table: decimal (d), octal (o), hex (h)

Usage: ascii <table>
"

    return;
  fi

  man ascii | grep -A 18 --color=never -e "The [$1].* set:" | tail -n 18;
}


# Convert epoch timestamp to ISO formatted datetime
function epoch2iso () {
  if [ -t 0 ]; then
    e=$1
    shift 1;
  else
    e=$(</dev/stdin)
  fi

  p=$1

  if [ -z "$p" ]; then
    p=0
  fi

  if [ -z "$e" ]; then
    echo "epoch2iso: Convert epoch timestamp to ISO formatted datetime

Usage: epoch2iso <epoch> [<precision = 0>]

Precision is counted from seconds (so 9 means nanosecond precision).
"

    return;
  fi

  python3 -c "import datetime;print(datetime.datetime.fromtimestamp($e / 1e$p).isoformat())"
}

function random_password_generator () {
  if [ -z "$1" ]; then
    echo "random_password_generator: Create a random password

Usage: random_password_generator <length> [<use_special_characters = 0>]
"

    return;
  fi

  length=$1
  use_special_characters=$2

  if [ -z "$use_special_characters" ]; then
    use_special_characters=0
  fi

  if [ $use_special_characters -eq 1 ]; then
    CHARS=( \
      a b c d e f g h i j k l m n o p q r s t u v w x y z \
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
      0 1 2 3 4 5 6 7 8 9 \
      \; \: \. \~ \! \@ \# \$ \% \^ \& \* - + = \? \
    )
  else
    CHARS=( \
      a b c d e f g h i j k l m n o p q r s t u v w x y z \
      A B C D E F G H I J K L M N O P Q R S T U V W X Y Z \
      0 1 2 3 4 5 6 7 8 9 \
    )
  fi

  CNUM="${#CHARS[@]}"

  result=""

  let POSCNT=0;
  while [ 1 -eq 1 ]; do
    if [ $POSCNT -ge $length ]; then
      break;
    fi

    result="${result}${CHARS[${RANDOM}%${CNUM}]}"

    let POSCNT=$POSCNT+1
  done

  echo "${result}"
}
alias rpwdgen='random_password_generator'

# Enter a docker container bash
function docker_exec_bash () {
  if [ -z "$1" ]; then
    echo "docker_exec_bash: Enter a docker container bash

Usage: docker_exec_bash <name>
"

    return;
  fi

  docker exec -it $1 /bin/bash
}
alias dxcb='docker_exec_bash'


# Clone a github repo by account and by name
function github_clone () {
  if [ -z "$2" ]; then
    echo "github_clone: Clone a github repo by account and by name

Usage: github_clone_own <account> <name>
"

    return;
  fi

  account=$1
  name=$2

  git clone "git@github.com:${account}/${name}.git"
}
alias ghc='github_clone'
# Clone own repo
alias ghco='github_clone tornermarton'


# Deploy toolkit over ssh to a remote host
function deploy_toolkit () {
  if [ -z "$1" ]; then
    echo "deploy_toolkit: Deploy toolkit over ssh to a remote host

Usage: deploy_toolkit <target> [<path>]
"

    return;
  fi

  target=$1
  toolkit_path=$2

  if [ -z "$2" ]; then
    toolkit_path="${HOME}/.toolkitrc"
    echo "Using default path: ${toolkit_path}"
  fi

  scp "${toolkit_path}" "${target}:${toolkit_path}"
}


# Update installed toolkit
function update_toolkit () {
  toolkit_path=$1

  if [ -z "$1" ]; then
    toolkit_path="${HOME}/.toolkitrc"
    echo "Using default path: ${toolkit_path}"
  fi

  source <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/${SHELL_TOOLKIT}/install.sh) > "${toolkit_path}.tmp"

  if [ -z "$(cat ${toolkit_path}.tmp)" ]; then
    echo "ERROR: New tookit file is empty, prevent overwrite"
    rm "${toolkit_path}.tmp"
    return 1;
  fi

  mv "${toolkit_path}.tmp" "${toolkit_path}"

  source "${toolkit_path}"
}

set +e
