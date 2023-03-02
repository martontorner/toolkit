_docker_containername_completions()
{
	containers="$(docker ps -a --format "{{.Names}}" | awk '{print}' ORS=' ')"
    parameter="${COMP_WORDS[$((${#COMP_WORDS[@]}-1))]}"
    if [ "$parameter" == "=" ]; then
        parameter=""
    fi
    COMPREPLY=( $(compgen -W "${containers}" "${parameter}") )
}

_cd_repo()
{
    local GIT_DIR=~/git/
    local cmd=$1 cur=$2 pre=$3
    local arr i file

    arr=( $( cd "$GIT_DIR" && compgen -d -- "$cur" ) )
    COMPREPLY=()
    for ((i = 0; i < ${#arr[@]}; ++i)); do
        file=${arr[i]}
        if [[ -d $GIT_DIR/$file ]]; then
            file=$file/
        fi
        COMPREPLY[i]=$file
    done
}

# For alias d
complete -F _docker d

# For aliases dlg and dxc
complete -F _docker_containername_completions dlg
complete -F _docker_containername_completions dxc

# For alias c
complete -F _docker_compose c

# For function dxcb
complete -F _docker_containername_completions docker_exec_bash
complete -F _docker_containername_completions dxcb

# for function cd_repo
complete -F _cd_repo -o nospace cd_repo
complete -F _cd_repo -o nospace cdr
