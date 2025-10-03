#
## A simplified shell-only powerline-like prompt
#

# --- HELPERS --- #

__prompt_length () {
  echo -e "$1" | sed -r 's/\\\[[^]]*\\\]//g' | { read -r s; echo "${#s}"; }
}

__with_color () {
  echo "\[\e[${1}m\]"
}

__with_print () {
  echo "${1}"
}

__set_options () {
  :
}

__unset_options () {
  :
}

# --- HELPERS --- #
# --- COMMONS --- #

_host_status () {
  local line=""

  line="${line}$(__with_color "0;38;5;31;48;49;22")"
  line="${line}$(__with_print "")"
  line="${line}$(__with_color "0;38;5;231;48;5;31")"
  line="${line}$(__with_print " $(hostname) ")"
  line="${line}$(__with_color "0;38;5;31;48;5;166;22")"
  line="${line}$(__with_print "")"

  echo "${line}"
}

_user_status () {
  local line=""

  line="${line}$(__with_color "0;38;5;229;48;5;166")"
  line="${line}$(__with_print "  $(whoami) ")"
  line="${line}$(__with_color "0;38;5;166;48;5;240;22")"
  line="${line}$(__with_print "")"

  echo "${line}"
}

_path_status () {
  local line=""

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

  line="${line}$(__with_color "0;38;5;250;48;5;240")"

  if [ ${#PARTS[@]} -gt 4 ]; then
    line="${line}$(__with_print " ... ")"
    line="${line}$(__with_color "0;38;5;245;48;5;240;22")"
    line="${line}$(__with_print "")"
    line="${line}$(__with_color "0;38;5;250;48;5;240")"

    PARTS=("${PARTS[@]: -3}")
  fi

  length=${#PARTS[@]}
  if [ "${length}" -gt 0 ]; then
    for part in "${PARTS[@]::${length}-1}"; do
      line="${line}$(__with_print " ${part} ")"
      line="${line}$(__with_color "0;38;5;245;48;5;240;22")"
      line="${line}$(__with_print "")"
      line="${line}$(__with_color "0;38;5;250;48;5;240")"
    done

    line="${line}$(__with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(__with_print " ${PARTS[${length}-1]} ")"
  fi

  echo "${line}"
}

_repo_status () {
  local line=""

  local branch=$(git branch 2> /dev/null | grep "\*" | sed -e "s/* \(.*\)/\1/")

  if [ "$branch" ]; then
    line="${line}$(__with_color "0;38;5;240;48;5;236;22")"
    line="${line}$(__with_print "")"

    status_info="$(git status --branch --porcelain)"

    branch_info="$(echo "${status_info}" | head -n 1)"
    file_info="$(echo "${status_info}" | tail -n +2)"

    if [ "${file_info}" ]; then
      line="${line}$(__with_color "0;38;5;247;48;5;236")"
    else
      line="${line}$(__with_color "0;38;5;2;48;5;236")"
    fi
    line="${line}$(__with_print "  ${branch} ")"

    behind="$(echo "${branch_info}" | sed -E "s/.*behind\ ([0-9]+).*/\1/" | sed -e "s/^##.*//")"
    if [ ! -z "${behind}" ]; then
      line="${line}$(__with_color "0;38;5;252;48;5;236")"
      line="${line}$(__with_print "↓ ${behind} ")"
    fi

    ahead="$(echo "${branch_info}" | sed -E "s/.*ahead\ ([0-9]+).*/\1/" | sed -e "s/^##.*//")"
    if [ ! -z "${ahead}" ]; then
      line="${line}$(__with_color "0;38;5;252;48;5;236")"
      line="${line}$(__with_print "↑ ${ahead} ")"
    fi

    staged="$(echo "${file_info}" | grep -E "^([MRC].|[D][^D]|[A][^A])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${staged}" -gt 0 ]; then
      line="${line}$(__with_color "0;38;5;2;48;5;236")"
      line="${line}$(__with_print "● ${staged} ")"
    fi

    unmerged="$(echo "${file_info}" | grep -E "^([U].|.[U]|[A][A]|[D][D])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${unmerged}" -gt 0 ]; then
      line="${line}$(__with_color "0;38;5;2;48;5;236")"
      line="${line}$(__with_print "✖ ${unmerged} ")"
    fi

    modified="$(echo "${file_info}" | grep -E "^(.[M]|[^D][D])" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${modified}" -gt 0 ]; then
      line="${line}$(__with_color "0;38;5;166;48;5;236")"
      line="${line}$(__with_print "✚ ${modified} ")"
    fi

    untracked="$(echo "${file_info}" | grep "^??" | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${untracked}" -gt 0 ]; then
      line="${line}$(__with_color "0;38;5;214;48;5;236")"
      line="${line}$(__with_print "… ${untracked} ")"
    fi

    stashed="$(git stash list --no-decorate | wc -l | sed -e "s/^[[:space:]]*//")"
    if [ "${stashed}" -gt 0 ]; then
      line="${line}$(__with_color "0;38;5;31;48;5;236")"
      line="${line}$(__with_print "⚑ ${stashed} ")"
    fi

    line="${line}$(__with_color "0;38;5;236;48;5;240;22")"
    line="${line}$(__with_print "")"
  fi

  echo "${line}"
}

_exit_status () {
  local line=""

  local exit_code=$1

  if [ "${exit_code}" -gt 0 ]; then
    line="${line}$(__with_color "0;38;5;240;48;5;52;22")"
    line="${line}$(__with_print "")"
    line="${line}$(__with_color "0;38;5;231;48;5;52")"
    line="${line}$(__with_print " ${exit_code} ")"
    line="${line}$(__with_color "0;38;5;52;48;49;22")"
    line="${line}$(__with_print "")"
  else
    line="${line}$(__with_color "0;38;5;240;48;49;22")"
    line="${line}$(__with_print "")"
  fi

  echo "${line}"
}

_kube_status () {
  local line=""

  line="${line}$(__with_color "0;38;5;240;48;49;22")"
  line="${line}$(__with_print "")"

  if command -v docker &> /dev/null; then
    line="${line}$(__with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(__with_print "   ")"
  fi

  local context=$(kubectl config current-context 2> /dev/null)

  if [ "${context}" ]; then
    line="${line}$(__with_color "0;38;5;252;48;5;240;1")"
    line="${line}$(__with_print "${context} ")"
  fi

  echo "${line}"
}

_tool_status () {
  local line=""

  local has_version=0

  local python3_version=$(python3 -V 2> /dev/null)
  local python_version=$(python -V 2> /dev/null)

  local node_version=$(node -v 2> /dev/null)

  local go_version=$(go version 2> /dev/null | awk '{print $3}')

  if [ "$python3_version" ]; then
    has_version=1

    line="${line}$(__with_color "0;38;5;75;48;5;236")"
    line="${line}$(__with_print " ")"
    line="${line}$(__with_color "0;38;5;247;48;5;236")"
    line="${line}$(__with_print " ${python3_version/Python /} ")"
  elif [ "$python_version" ]; then
    has_version=1

    line="${line}$(__with_color "0;38;5;75;48;5;236")"
    line="${line}$(__with_print " ")"
    line="${line}$(__with_color "0;38;5;247;48;5;236")"
    line="${line}$(__with_print " ${python_version/Python /} ")"
  fi

  if [ "$node_version" ]; then
    if [ $has_version ]; then
      line="${line}$(__with_color "0;38;5;247;48;5;236")"
      line="${line}$(__with_print "")"
    fi

    has_version=1

    line="${line}$(__with_color "0;38;5;2;48;5;236")"
    line="${line}$(__with_print " ")"
    line="${line}$(__with_color "0;38;5;247;48;5;236")"
    line="${line}$(__with_print " ${node_version/v/} ")"
  fi

  if [ "$go_version" ]; then
    if [ $has_version ]; then
      line="${line}$(__with_color "0;38;5;247;48;5;236")"
      line="${line}$(__with_print "")"
    fi

    has_version=1

    line="${line}$(__with_color "0;38;5;39;48;5;236")"
    line="${line}$(__with_print " 󰟓 ")"
    line="${line}$(__with_color "0;38;5;247;48;5;236")"
    line="${line}$(__with_print " ${go_version/go/} ")"
  fi

  if [ $has_version ]; then
    line="$(__with_print "")${line}"
    line="$(__with_color "0;38;5;236;48;5;240;22")${line}"

    line="${line}$(__with_color "0;38;5;240;48;5;236;22")"
    line="${line}$(__with_print "")"
  fi

  echo "${line}"
}

_time_status () {
  local line=""

  line="${line}$(__with_color "0;38;5;252;48;5;240;1")"
  line="${line}$(__with_print " $(date +'%I:%M %p')  ")"

  line="${line}$(__with_color "0;38;5;240;48;49;22")"
  line="${line}$(__with_print "")"
  line="${line}$(__with_color "0")"

  echo "${line}"
}

_create_status_line () {
  local line_s=""
  local line_e=""

  line_s="${line_s}$(_host_status)"
  line_s="${line_s}$(_user_status)"
  line_s="${line_s}$(_path_status)"
  line_s="${line_s}$(_repo_status)"
  line_s="${line_s}$(_exit_status $1)"

  line_e="${line_e}$(_kube_status)"
  line_e="${line_e}$(_tool_status)"
  line_e="${line_e}$(_time_status)"

  line_s_length=$(__prompt_length "${line_s}")
  line_e_length=$(__prompt_length "${line_e}")
  line_c_length=$((COLUMNS - line_s_length - line_e_length))

  echo "${line_s}$(printf '%*s' "$line_c_length" '')${line_e}"
}

_create_prompt_line () {
  echo "$(__with_print " $ ")"
}

_update_prompt () {
  local line=""

  __set_options

  line="${line}$(_create_status_line $?)"
  line="${line}\n"
  line="${line}$(_create_prompt_line)"

  __unset_options

  PS1=$(echo "${line}")
}

# --- COMMONS --- #

if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null; then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)
  POWERLINE_PATH="${POWERLINE_ROOT}/powerline/bindings/bash/powerline.sh"

  if [ -f "${POWERLINE_PATH}" ]; then
    powerline-daemon -q

    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1

    source "${POWERLINE_PATH}"
  fi
else
  # no powerline is detected -> use custom prompt
  PROMPT_COMMAND=_update_prompt
fi
