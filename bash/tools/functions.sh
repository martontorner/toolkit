set -e

# Print ASCII table (decimal (d), octal (o), hex (h)) - works only for MAC
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


# Update installed toolkit
function update_toolkit () {
  path=$1

  if [ -z "$1" ]; then
    path="${HOME}/.toolkitrc"
    echo "Using default path: ${path}"
  fi

  bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/install.sh) > "${path}"
}

set +e
