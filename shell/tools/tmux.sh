_tmux_dump() {
  local d=$'\t'
  tmux list-windows -a -F "#S${d}#W${d}#{pane_current_path}"
}

_terminal_size() {
  stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }'
}

_tmux_session_exists() {
  tmux has-session -t "$1" 2>/dev/null
}

_tmux_add_window() {
  tmux new-window -d -t "$1:" -n "$2" -c "$3"
}

_tmux_new_session() {
  cd "$3" &&
  tmux new-session -d -s "$1" -n "$2"
}

set -e

tmux_save() {
  _tmux_dump > ~/.tmux-session
}

tmux_load() {
  local count=0

  while IFS=$'\t' read session_name window_name dir; do
    if [[ -d "$dir" && $window_name != "log" && $window_name != "man" ]]; then
      if _tmux_session_exists "$session_name"; then
        _tmux_add_window "$session_name" "$window_name" "$dir"
      else
        _tmux_new_session "$session_name" "$window_name" "$dir"
        count=$(( count + 1 ))
      fi
    fi
  done < ~/.tmux-session

  echo "restored $count sessions"
}

set +e
