#
## A simplified powerline prompt
#

#  ✓ victor ⏻ 94% ⏳ ~/bin master  ✔ 
#  |   |    |     |    |     |- Git status
#  |   |    |     |    |- PWD
#  |   |    |     |- sudo status
#  |   |    |- battery indicator and percentage
#  |   |- User
#  |- $?

## User choices
battery_info="n"
sudo_info="y"
# Choose from: ⌚, ⏳, ✰, ⵌ, ✷
sudo_icon="ⵌ"

_foreground () {
  color=$1

  return "\[\\033[38;5;${color}m\]"
}

_background () {
  color=$1

  return "\[\\033[48;5;${color}m\]"
}

# Colors
PS_Green='\[\e[32m\]'
PS_Red='\[\e[31m\]'
# Background
On_Black='\001\e[40m\002'
On_Grey='\001\e[47m\002'
On_Darkgrey='\001\e[100m\002'
On_Yellow='\001\e[43m\002'
On_Purple='\001\e[45m\002'
On_Green='\001\e[42m\002'
On_Blue='\001\e[44m\002'
On_Red='\001\e[41m\002'
# Foreground
Black='\001\e[0;30m\002'
Grey='\001\e[0;37m\002'
Darkgrey='\001\e[0;90m\002'
White='\001\e[0;97m\002'
Purple='\001\e[0;35m\002'
Green='\001\e[0;32m\002'
Blue='\001\e[0;34m\002'
Yellow='\001\e[0;33m\002'
Red='\001\e[0;31m\002'
# Reset
Color_Off='\001\e[0m\002'
# Color_Off='\[\e[0m\]'
PS_Color_Off='\[\e[0m\]'

_sudo_status () {
  sudo -n uptime 2>&1 | grep -q "load"
  if [[ $? -eq 0 ]] ; then
    echo -e "${Yellow}${On_Black}$sudo_icon"
  fi
}

_git_branch ()
{
  local gitbranch gitstatus modified

  gitbranch=$(git branch 2> /dev/null | grep '\*' | sed -e 's/* \(.*\)/\1/')

  if [ "$gitbranch" ] ; then
    gitbranch=" ${gitbranch}"
    gitstatus=$(git status -s)
    modified="+$(git status -s | wc -l | sed -e 's/^[[:space:]]*//')"

    if [ "$gitstatus" ] ; then
      printf "${Grey}${On_Black} ${gitbranch} ${Red}${On_Black}${modified} ${Black}"
    else
      printf "${Green}${On_Black} ${gitbranch} ${Black}"
    fi
  fi
}

_git_colors () {
  git_status=$(_git_branch)

  if [ "$git_status" ] ; then
    if [[ "$(echo $git_status | grep -q + ; echo $?)" -eq 1 ]] ; then
      printf "${On_Black}${git_status}"
    else
      printf "${On_Black}${git_status}"
    fi
  fi
}

_create_prompt () {
  user=$1
  host=$2
  cwd=$3
  exit_code=$4

  printf "${White}${On_Blue} ${user} "
  if [ \$sudo_info = y ] ; then _sudo_status ; fi
  printf "${Blue}${On_Yellow}"

  printf "${Black}${On_Yellow} ${host} ${Yellow}${On_Darkgrey}"

  IFS="/" read -ra PARTS <<< "${cwd}"
  PARTS=("${PARTS[@]:1}")
  if [ ${#PARTS[@]} -gt 3 ]; then
    printf "${White}${On_Darkgrey} ... ${Darkgrey}"
    PARTS=("${PARTS[@]: -3}")
  else
    printf "${White}${On_Darkgrey} / ${Darkgrey}"
  fi
  for part in "${PARTS[@]}"
  do
    printf "${White}${On_Darkgrey}  ${part} ${Darkgrey}"
  done

  _git_colors

  if [ $exit_code != 0 ]; then
    printf "${On_Red}${White}${On_Red} ${exit_code} ${Red}"
  fi

  printf "${Color_Off}"
}

if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null
then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)

  if [ -f "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh
  fi
else
  # no powerline is detected -> use custom
  PS1="\`_create_prompt \u \H \w \$?\`"
fi
