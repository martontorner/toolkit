_docker_containername_completions()
{
	containers="$(docker ps -a --format "{{.Names}}" | awk '{print}' ORS=' ')"
    parameter="${COMP_WORDS[$((${#COMP_WORDS[@]}-1))]}"
    if [ "$parameter" == "=" ]; then
        parameter=""
    fi
    COMPREPLY=( $(compgen -W "${containers}" "${parameter}") )
}

# For alias d
complete -F _docker d

# For aliases dlg and dxc
complete -F _docker_containername_completions dlg
complete -F _docker_containername_completions dxc

# For alias c
complete -F _docker_compose c

# For function dxcb
complete -F _docker_containername_completions dxcb
