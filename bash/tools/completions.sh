[ -x "$(command -v docker)" ] && source <(docker completion bash)
[ -x "$(command -v kubectl)" ] && source <(kubectl completion bash)

_cd_repo() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -f -W "$(ls -1 ~/git)" -- "${cur}") )
}
complete -F _cd_repo -o nospace cd_repo

_docker_exec_bash() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local containers
    containers=$(docker ps --format '{{.Names}}')
    COMPREPLY=( $(compgen -W "${containers}" -- "${cur}") )
}
complete -F _docker_exec_bash docker_exec_bash

# Bash cannot autocomplete with aliases so we must do the most common ones by hand
complete -F _cd_repo -o nospace cdr

complete -F _docker d
complete -F _docker_exec_bash dlg
complete -F _docker_exec_bash dxc
complete -F _docker_exec_bash dxcb

complete -F _docker_compose c
