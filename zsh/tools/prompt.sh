#
## A simplified powerline prompt
#

_with_color () {
  color=$1

  echo "%{\e[${color}m%}"
}

_with_print () {
  info=$1

  echo "${info}"
}

_user_status () {
  line=""
  
  line="${line}$(_with_color "0;38;5;231;48;5;31;1")"
  line="${line}$(_with_print " $(whoami) ")"
  line="${line}$(_with_color "0;38;5;31;48;5;166;22")"
  line="${line}$(_with_print "")"
  
  echo "${line}"
}

_host_status () {
  line=""
  
  line="${line}$(_with_color "0;38;5;220;48;5;166")"
  line="${line}$(_with_print " $(hostname) ")"
  line="${line}$(_with_color "0;38;5;166;48;5;240;22")"
  line="${line}$(_with_print "")"
  
  echo "${line}"
}

_path_status () {
  set -o ksharrays
  
  line=""

  if ! echo "${PWD}" | grep -q "${HOME}"; then
    STR="${PWD}"
    PARTS=(${(@s:/:)STR})
    PARTS=("/" "${PARTS[@]}")
  else
    STR="${PWD/"$HOME"/"~"}"
    PARTS=(${(@s:/:)STR})
  fi

  line="${line}$(_with_color "0;38;5;250;48;5;240")"

  if [ ${#PARTS[@]} -gt 4 ]; then
    line="${line}$(_with_print " ... ")"
    line="${line}$(_with_color "0;38;5;245;48;5;240;22")"
    line="${line}$(_with_print "")"
    line="${line}$(_with_color "0;38;5;250;48;5;240")"

    PARTS=("${PARTS[@]:-3}")
  fi

  length=${#PARTS[@]}
  if [ "${length}" -gt 0 ]; then
    for part in "${PARTS[@]::${length}-1}"; do
      line="${line}$(_with_print " ${part} ")"
      line="${line}$(_with_color "0;38;5;245;48;5;240;22")"
      line="${line}$(_with_print "")"
      line="${line}$(_with_color "0;38;5;250;48;5;240")"
    done

    line="${line}$(_with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(_with_print " ${PARTS[${length}-1]} ")"
  fi
  
  echo "${line}"
}

_git_status () {
  line=""

  branch=$(git branch 2> /dev/null | grep "\*" | sed -e "s/* \(.*\)/\1/")

  if [ "$branch" ]; then
    line="${line}$(_with_color "0;38;5;240;48;5;236;22")"
    line="${line}$(_with_print "")"

    status_info="$(git status --branch --porcelain)"

    branch_info="$(echo "${status_info}" | head -n 1)"
    file_info="$(echo "${status_info}" | tail -n +2)"

    if [ "${file_info}" ]; then
      line="${line}$(_with_color "0;38;5;247;48;5;236")"
    else
      line="${line}$(_with_color "0;38;5;2;48;5;236")"
    fi
    line="${line}$(_with_print "  ${branch} ")"

    behind="$(echo "${branch_info}" | sed -E "s/.*behind\ ([0-9]+).*/\1/" | sed -e "s/^##.*//")"
    if [ ! -z "${behind}" ]; then
      line="${line}$(_with_color "0;38;5;252;48;5;236")"
      line="${line}$(_with_print "↓ ${behind} ")"
    fi

    ahead="$(echo "${branch_info}" | sed -E "s/.*ahead\ ([0-9]+).*/\1/" | sed -e "s/^##.*//")"
    if [ ! -z "${ahead}" ]; then
      line="${line}$(_with_color "0;38;5;252;48;5;236")"
      line="${line}$(_with_print "↑ ${ahead} ")"
    fi

    staged="$(echo "${file_info}" | grep -E "^([MRC].|[D][^D]|[A][^A])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${staged}" -gt 0 ]; then
      line="${line}$(_with_color "0;38;5;2;48;5;236")"
      line="${line}$(_with_print "● ${staged} ")"
    fi

    unmerged="$(echo "${file_info}" | grep -E "^([U].|.[U]|[A][A]|[D][D])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${unmerged}" -gt 0 ]; then
      line="${line}$(_with_color "0;38;5;2;48;5;236")"
      line="${line}$(_with_print "✖ ${unmerged} ")"
    fi

    modified="$(echo "${file_info}" | grep -E "^(.[M]|[^D][D])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${modified}" -gt 0 ]; then
      line="${line}$(_with_color "0;38;5;166;48;5;236")"
      line="${line}$(_with_print "✚ ${modified} ")"
    fi

    untracked="$(echo "${file_info}" | grep "^??" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${untracked}" -gt 0 ]; then
      line="${line}$(_with_color "0;38;5;214;48;5;236")"
      line="${line}$(_with_print "… ${untracked} ")"
    fi

    stashed="$(git stash list --no-decorate | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${stashed}" -gt 0 ]; then
      line="${line}$(_with_color "0;38;5;31;48;5;236")"
      line="${line}$(_with_print "⚑ ${stashed} ")"
    fi
  fi

  echo "${line}"
}

_virtualenv_status () {
  line=""

  virtualenv=""

  if [ "${VIRTUAL_ENV}" ]; then
    STR="${VIRTUAL_ENV}"
    PARTS=(${(@s:/:)STR})
    virtualenv="${PARTS[${#PARTS[@]}-1]}"
  fi

  if [ "${CONDA_DEFAULT_ENV}" ]; then
    STR="${CONDA_DEFAULT_ENV}"
    PARTS=(${(@s:/:)STR})
    virtualenv="${PARTS[${#PARTS[@]}-1]}"
  fi

  if [ "${virtualenv}" ]; then
    line="${line}$(_with_color "0;38;5;250;48;5;240")"
    line="${line}$(_with_print " \xf0\x9f\x90\x8d ${virtualenv}")"
  fi

  echo "${line}"
}

_create_prompt () {
  line=""

  exit_code=$1

  line="${line}$(_user_status)"

  line="${line}$(_host_status)"

  line="${line}$(_path_status)"

  line="${line}$(_git_status)"

  if [ "${exit_code}" -gt 0 ]; then
    line="${line}$(_with_color "0;38;5;240;48;5;52;22")"
    line="${line}$(_with_print "")"
    line="${line}$(_with_color "0;38;5;231;48;5;52")"
    line="${line}$(_with_print " ${exit_code} ")"
    line="${line}$(_with_color "0;38;5;52;48;5;256;22")"
    line="${line}$(_with_print "")"
  else
    line="${line}$(_with_color "0;38;5;240;48;5;256;22")"
    line="${line}$(_with_print "")"
  fi

  line="${line}\n"

  line="${line}$(_virtualenv_status)"

  line="${line}$(_with_color "0;38;5;250;48;5;240;1")"
  line="${line}$(_with_print " $ ")"

  line="${line}$(_with_color "0;38;5;240;48;5;256;22")"
  line="${line}$(_with_print "")"

  # switch off colors
  line="${line}$(_with_color "0")"
  line="${line}$(_with_print " ")"

  echo "${line}"
}

if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null; then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)

  if [ -f "$POWERLINE_ROOT"/powerline/bindings/zsh/powerline.sh ]; then
    powerline-daemon -q

    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1

    source "$POWERLINE_ROOT"/powerline/bindings/zsh/powerline.sh
  fi
else
  # no powerline is detected -> use custom prompt
  export VIRTUAL_ENV_DISABLE_PROMPT=1

  set -o promptsubst
  PS1='$(_create_prompt $?)'
fi
