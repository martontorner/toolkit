alias ll='ls -lahF --color=auto'
alias p='cd ~/git/'

alias v='vim'

alias nb='jupyter notebook'
alias a='. venv/bin/activate || . venv/Scripts/activate'

alias hostfile='sudo vim /etc/hosts'
alias gip='curl https://api.ipify.org ; echo'
alias lip='ifconfig | egrep -o $IP_REGEX'

alias d='docker'
alias dls='d ps --no-trunc'
alias dla='d ps -a --no-trunc'
alias dli='d images'
alias dlg='d logs'
alias dxc='d exec -it'


alias c='docker compose'
alias cup='c up -d'
alias cwn='c down'

alias utcnow='date -u "+%Y-%m-%dT%H:%M:%SZ"'
alias epochnow='python3 -c "import time;print(time.time_ns())"'
