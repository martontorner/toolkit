# Print ASCII table (decimal (d), octal (o), hex (h))
function ascii {
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
dexec () {
    docker exec -it $1 /bin/bash
}
export -f dexec

