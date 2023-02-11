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
function dxcb () {
    dxc $1 /bin/bash
}
export -f dxcb


# Update installed toolkit
function update_toolkit () {
  path=$1

  if [ -z "$1" ]; then
    path="~/.toolkitrc"
    echo "Using default path: ${path}"
  fi

  bash <(curl -s https://raw.githubusercontent.com/tornermarton/toolkit/master/bash/install.sh) > $path
}
