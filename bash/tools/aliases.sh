alias ll='ls -lahvF --color=auto'
alias tree='tree -C --dirsfirst'
alias ..='cd ..'
alias ...='cd ../..'
alias p='cd ~/git/'

alias h='history | tail -n 50'

alias g='git'
alias ga='g add'
alias gaa='ga .'
alias gpl='g pull --rebase=true --prune --tags --verbose'
alias gps='g push'
alias gc='g commit'
alias gcm='gc -m'
alias gca='gc --amend'
alias gst='g status -s'
alias gco='g checkout'
alias gf='g fetch'
alias gfa='gf --all'
alias gh='g log --pretty=format:"%C(green)[%h]%C(reset) %<(65)%s %C(yellow)[%ad]%C(reset) %C(bold red)%an%C(reset) %C(blue)%d%C(reset)" --graph --date=format-local:"%Y-%m-%d %H:%M:%S"'
alias gha='gh --all'
alias ghs='gh -n 20'

alias v='vim'
alias grep='grep --color=auto'

alias nb='jupyter notebook'
alias a='. venv/bin/activate || . venv/Scripts/activate'

alias hostfile='sudo vim /etc/hosts'
alias gip='curl https://api.ipify.org ; echo'
alias lip='ifconfig | egrep -o $IP_REGEX'

alias d='docker'
alias dls='d ps --no-trunc --format="table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"'
alias dla='d ps -a --no-trunc --format="table {{.Names}}\t{{.Status}}\t{{.RunningFor}}\t{{.Size}}\t{{.Image}}\t{{.Command}}\t{{.Ports}}"'
alias dli='d images'
alias dlg='d logs'
alias dxc='d exec -it'

docker compose version &> /dev/null
if [ $? -eq 0 ];
then
  alias c='docker compose'
else
  # fallback to old docker-compose
  alias c='docker-compose'
fi
alias cup='c up -d'
alias cwn='c down'

alias utcnow='date -u "+%Y-%m-%dT%H:%M:%SZ"'
alias epochnow='python3 -c "import time;print(time.time_ns())"'
