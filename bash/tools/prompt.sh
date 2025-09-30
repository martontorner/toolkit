#
## A simplified powerline prompt
#

_with_color () {
  color=$1

  echo "\[\e[${color}m\]"
}

_with_print () {
  info=$1

  echo "${info}"
}

_host_status () {
  line=""

  line="${line}$(_with_color "0;38;5;31;48;49;22")"
  line="${line}$(_with_print "")"
  line="${line}$(_with_color "0;38;5;231;48;5;31")"
  line="${line}$(_with_print " $(hostname) ")"
  line="${line}$(_with_color "0;38;5;31;48;5;166;22")"
  line="${line}$(_with_print "")"

  echo "${line}"
}

_user_status () {
  line=""

  line="${line}$(_with_color "0;38;5;229;48;5;166")"
  line="${line}$(_with_print "  $(whoami) ")"
  line="${line}$(_with_color "0;38;5;166;48;5;240;22")"
  line="${line}$(_with_print "")"

  echo "${line}"
}

_path_status () {
  line=""

  if ! echo "${PWD}" | grep -q "${HOME}"; then
    IFS="/" read -ra PARTS <<< "${PWD}"
    PARTS[0]="/"
  else
    IFS="/" read -ra PARTS <<< "$(echo "${PWD}" | sed "s|${HOME}|~|g")"
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

    line="${line}$(_with_color "0;38;5;236;48;5;240;22")"
    line="${line}$(_with_print "")"
  fi

  echo "${line}"
}

_left_status () {
  line=""

  exit_code=$1

  if [ "${exit_code}" -gt 0 ]; then
    line="${line}$(_with_color "0;38;5;240;48;5;52;22")"
    line="${line}$(_with_print "")"
    line="${line}$(_with_color "0;38;5;231;48;5;52")"
    line="${line}$(_with_print " ${exit_code} ")"
    line="${line}$(_with_color "0;38;5;52;48;49;22")"
    line="${line}$(_with_print "")"
  else
    line="${line}$(_with_color "0;38;5;240;48;49;22")"
    line="${line}$(_with_print "")"
  fi

  echo "${line}"
}

_runtime_status () {
  line=""

  has_version=0

  python3_version=$(python3 -V 2> /dev/null)
  python_version=$(python -V 2> /dev/null)

  node_version=$(node -v 2> /dev/null)

  if [ "$python3_version" ]; then
    has_version=1

    line="${line}$(_with_color "0;38;5;75;48;5;236")"
    line="${line}$(_with_print " ")"
    line="${line}$(_with_color "0;38;5;247;48;5;236")"
    line="${line}$(_with_print " ${python3_version/Python /} ")"
  elif [ "$python_version" ]; then
    has_version=1

    line="${line}$(_with_color "0;38;5;75;48;5;236")"
    line="${line}$(_with_print " ")"
    line="${line}$(_with_color "0;38;5;247;48;5;236")"
    line="${line}$(_with_print " ${python_version/Python /} ")"
  fi

  if [ "$node_version" ]; then
    if [ $has_version ]; then
      line="${line}$(_with_color "0;38;5;247;48;5;236")"
      line="${line}$(_with_print "")"
    fi

    has_version=1

    line="${line}$(_with_color "0;38;5;2;48;5;236")"
    line="${line}$(_with_print " ")"
    line="${line}$(_with_color "0;38;5;247;48;5;236")"
    line="${line}$(_with_print " ${node_version/v/} ")"
  fi

  if [ $has_version ]; then
    line="$(_with_print "")${line}"
    line="$(_with_color "0;38;5;236;48;5;240;22")${line}"

    line="${line}$(_with_color "0;38;5;240;48;5;236;22")"
    line="${line}$(_with_print "")"
  fi

  echo "${line}"
}

_right_status () {
  line=""

  line="${line}$(_with_color "0;38;5;240;48;49;22")"
  line="${line}$(_with_print "")"

  echo "${line}"
}

_time_status () {
  line=""
  line="${line}$(_with_color "0;38;5;252;48;5;240;1")"
  line="${line}$(_with_print " $(date +'%I:%M %p')  ")"

  line="${line}$(_with_color "0;38;5;240;48;49;22")"
  line="${line}$(_with_print "")"

  echo "${line}"
}

_create_prompt () {
  l_line=""
  l_line="${l_line}$(_host_status)"
  l_line="${l_line}$(_user_status)"
  l_line="${l_line}$(_path_status)"
  l_line="${l_line}$(_git_status)"
  l_line="${l_line}$(_left_status $1)"

  r_line=""
  r_line="${r_line}$(_right_status)"
  r_line="${r_line}$(_runtime_status)"
  r_line="${r_line}$(_time_status)"

  l_len=$(echo -e "$l_line" | sed -r 's/\\\[[^]]*\\\]//g' | { read -r s; echo "${#s}"; })
  r_len=$(echo -e "$r_line" | sed -r 's/\\\[[^]]*\\\]//g' | { read -r s; echo "${#s}"; })
  padding_size=$((COLUMNS - l_len - r_len))

  line="${l_line}$(printf '%*s' "$padding_size" '')${r_line}"

  # switch off colors
  line="${line}$(_with_color "0")"
  line="${line}\n"
  line="${line}$(_with_print " $ ")"

  echo "${line}"
}

if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null; then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)

  if [ -f "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q

    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1

    source "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh
  fi
else
  # no powerline is detected -> use custom prompt
  export VIRTUAL_ENV_DISABLE_PROMPT=1

  _set_prompt () {
    PS1="$(_create_prompt $?)"
  }

  PROMPT_COMMAND=_set_prompt
fi
