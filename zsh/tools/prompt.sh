#
## A simplified shell-only powerline-like prompt
#

# --- HELPERS --- #

__prompt_length () {
  emulate -L zsh
  local COLUMNS=${2:-$COLUMNS}
  local -i x y=$#1 m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ));
    done
    local xy
    while (( y > x + 1 )); do
      m=$(( x + (y - x) / 2 ))
      typeset ${${(%):-$1%$m(l.x.y)}[-1]}=$m
    done
  fi
  echo $x
}

_with_color () {
  color=$1

  echo "%{\e[${color}m%}"
}

_with_print () {
  info=$1

  echo "${info}"
}

_with_merge() {
  line_s=$1
  line_e=$2

  line_s_length=$(__prompt_length "${line_s}")
  line_e_length=$(__prompt_length "${line_e}")
  line_c_length=$((COLUMNS - line_s_length - line_e_length))

  line_c="${(pl.$line_c_length.. .)}"

  echo "${line_s}${line_c}${line_e}"
}

_set_options () {
  set -o ksharrays
}

_unset_options () {
  set +o ksharrays
}

# --- HELPERS --- #

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

  PARTS=()
  if [[ "$PWD" == "$HOME"* ]]; then
    while IFS= read -r p; do
      PARTS+=("$p")
    done < <(printf '%s\n' "~${PWD#$HOME}" | tr '/' '\n')
  else
    while IFS= read -r p; do
      PARTS+=("$p")
    done < <(printf '%s\n' "${PWD#/}" | tr '/' '\n')
    PARTS[0]="/"
  fi

  line="${line}$(_with_color "0;38;5;250;48;5;240")"

  if [ ${#PARTS[@]} -gt 4 ]; then
    line="${line}$(_with_print " ... ")"
    line="${line}$(_with_color "0;38;5;245;48;5;240;22")"
    line="${line}$(_with_print "")"
    line="${line}$(_with_color "0;38;5;250;48;5;240")"

    PARTS=("${PARTS[@]: -3}")
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

_repo_status () {
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

_exit_status () {
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

_kube_status () {
  line=""

  line="${line}$(_with_color "0;38;5;240;48;49;22")"
  line="${line}$(_with_print "")"

  if command -v docker &> /dev/null; then
    line="${line}$(_with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(_with_print "   ")"
  fi

  context=$(kubectl config current-context 2> /dev/null)

  if [ "${context}" ]; then
    line="${line}$(_with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(_with_print "${context} ")"
  fi

  echo "${line}"
}

_tool_status () {
  line=""

  has_version=0

  python3_version=$(python3 -V 2> /dev/null)
  python_version=$(python -V 2> /dev/null)

  node_version=$(node -v 2> /dev/null)

  go_version=$(go version 2> /dev/null | awk '{print $3}')

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

  if [ "$go_version" ]; then
    if [ $has_version ]; then
      line="${line}$(_with_color "0;38;5;247;48;5;236")"
      line="${line}$(_with_print "")"
    fi

    has_version=1

    line="${line}$(_with_color "0;38;5;39;48;5;236")"
    line="${line}$(_with_print " 󰟓 ")"
    line="${line}$(_with_color "0;38;5;247;48;5;236")"
    line="${line}$(_with_print " ${go_version/go/} ")"
  fi

  if [ $has_version ]; then
    line="$(_with_print "")${line}"
    line="$(_with_color "0;38;5;236;48;5;240;22")${line}"

    line="${line}$(_with_color "0;38;5;240;48;5;236;22")"
    line="${line}$(_with_print "")"
  fi

  echo "${line}"
}

_time_status () {
  line=""

  line="${line}$(_with_color "0;38;5;252;48;5;240;1")"
  line="${line}$(_with_print " $(date +'%I:%M %p')  ")"

  line="${line}$(_with_color "0;38;5;240;48;49;22")"
  line="${line}$(_with_print "")"
  line="${line}$(_with_color "0")"

  echo "${line}"
}

_create_status_line () {
  l_line=""
  r_line=""

  l_line="${l_line}$(_host_status)"
  l_line="${l_line}$(_user_status)"
  l_line="${l_line}$(_path_status)"
  l_line="${l_line}$(_repo_status)"
  l_line="${l_line}$(_exit_status $1)"

  r_line="${r_line}$(_kube_status)"
  r_line="${r_line}$(_tool_status)"
  r_line="${r_line}$(_time_status)"

  echo "$(_with_merge "${l_line}" "${r_line}")"
}

_create_prompt_line () {
  echo "$(_with_print " $ ")"
}

_create_prompt () {
  line=""

  _set_options

  line="${line}$(_create_status_line $1)"
  line="${line}\n"
  line="${line}$(_create_prompt_line)"

  _unset_options

  echo "${line}"
}

if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null; then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)
  POWERLINE_PATH="${POWERLINE_ROOT}/powerline/bindings/zsh/powerline.sh"

  if [ -f "${POWERLINE_PATH}" ]; then
    powerline-daemon -q

    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1

    source "${POWERLINE_PATH}"
  fi
else
  # no powerline is detected -> use custom prompt
  export VIRTUAL_ENV_DISABLE_PROMPT=1

  set -o promptsubst
  PS1='$(_create_prompt $?)'
fi
