# Print ASCII table (decimal (d), octal (o), hex (h)) - works only for MAC
function ascii () {
  if [ -z "$1" ]; then
    echo "ascii: Print ASCII table

    Usage: ascii <table_type>

    Table type can be decimal (d), octal (o), hex (h).
    "

    return;
  fi

  man ascii | grep -A 18 --color=never -e "The [$1].* set:" | tail -n 18;
}
export -f ascii

# Enter a docker container bash
function docker_exec_bash () {
    dxc $1 /bin/bash
}
export -f docker_exec_bash
alias dxcb='docker_exec_bash'

# Clone a git repo from my own account by name
function github_clone_own () {
  if [ -z "$1" ]; then
    echo "github_clone_own: Clone a git repo from my own account by name

    Usage: github_clone_own <name>
    "

    return;
  fi

  name=$1

  git clone "git@github.com:tornermarton/${name}.git"
}
export -f github_clone_own
alias ghco='github_clone_own'

# Update installed toolkit
function update_toolkit () {
  path=$1

  if [ -z "$1" ]; then
    path="~/.toolkitrc"
    echo "Using default path: ${path}"
  fi

  bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/install.sh) > $path
}
export -f update_toolkit
