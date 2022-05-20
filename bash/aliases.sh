alias ll='ls -lGahF'
alias p='cd ~/git/'

alias v='vim'

alias nb='jupyter notebook'
alias a='. venv/bin/activate || . venv/Scripts/activate'

alias hostfile='sudo vim /etc/hosts'
alias gip='curl https://api.ipify.org ; echo'
alias lip='ifconfig | egrep -o $IP_REGEX'

alias d='docker'
complete -F _docker d
alias dls='docker ps -a --no-trunc'
alias dexec='docker exec -it'
_docker_containername_completions()
{
	containers="$(docker ps -a --format "{{.Names}}" | awk '{print}' ORS=' ')"
    parameter="${COMP_WORDS[$((${#COMP_WORDS[@]}-1))]}"
    if [ "$parameter" == "=" ]; then
        parameter=""
    fi
    COMPREPLY=( $(compgen -W "${containers}" "${parameter}") )
}
complete -F _docker_containername_completions dexec


alias c='docker compose'
complete -F _docker_compose c
alias cup='c up -d'
alias cwn='c down'

alias utcnow='date -u "+%Y-%m-%dT%H:%M:%SZ"'
alias epochnow='python3 -c "import time;print(time.time_ns())"'
