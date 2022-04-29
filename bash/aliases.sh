alias ll='ls -lGahF'
alias p='cd ~/git/'

alias v='vim'

alias nb='jupyter notebook'
alias a='. venv/bin/activate'

alias hostfile='sudo vim /etc/hosts'
alias ip='curl https://diagnostic.opendns.com/myip ; echo'
alias lip='ifconfig | egrep -o $IP_REGEX'

alias d='docker'
alias dls='docker ps -a'

alias c='docker compose'
alias cup='c up -d'
alias cwn='c down'

alias utcnow='date -u "+%Y-%m-%dT%H:%M:%SZ"'
alias epochnow='python3 -c "import time;print(time.time_ns())"'
