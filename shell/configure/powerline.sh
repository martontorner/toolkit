mkdir -p "${HOME}/.config/powerline"
cat > "${HOME}/.config/powerline/config.json" <<- EOM
{
  "ext": {
    "shell": {
      "theme": "default"
    }
  }
}
EOM

mkdir -p "${HOME}/.config/powerline/colorschemes"
cat > "${HOME}/.config/powerline/colorschemes/default.json" <<- EOM
{
  "groups": {
    "gitstatus":                 { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch":          { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_clean":    { "fg": "green",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_dirty":    { "fg": "gray8",           "bg": "gray2", "attrs": [] },
    "gitstatus_branch_detached": { "fg": "mediumpurple",    "bg": "gray2", "attrs": [] },
    "gitstatus_tag":             { "fg": "darkcyan",        "bg": "gray2", "attrs": [] },
    "gitstatus_behind":          { "fg": "gray10",          "bg": "gray2", "attrs": [] },
    "gitstatus_ahead":           { "fg": "gray10",          "bg": "gray2", "attrs": [] },
    "gitstatus_staged":          { "fg": "green",           "bg": "gray2", "attrs": [] },
    "gitstatus_unmerged":        { "fg": "brightred",       "bg": "gray2", "attrs": [] },
    "gitstatus_changed":         { "fg": "mediumorange",    "bg": "gray2", "attrs": [] },
    "gitstatus_untracked":       { "fg": "brightestorange", "bg": "gray2", "attrs": [] },
    "gitstatus_stashed":         { "fg": "darkblue",        "bg": "gray2", "attrs": [] },
    "gitstatus:divider":         { "fg": "gray8",           "bg": "gray2", "attrs": [] }
  }
}
EOM

mkdir -p "${HOME}/.config/powerline/themes/shell"


cat > "${HOME}/.config/powerline/themes/shell/__main__.json" <<- EOM
{
  "segment_data": {
    "hostname": {
      "args": {
        "only_if_ssh": false
      }
    }
  }
}
EOM
cat > "${HOME}/.config/powerline/themes/shell/default.json" <<- EOM
{
  "segments": {
    "above": [
      {
        "left": [
          {
            "function": "powerline.segments.common.env.user",
            "priority": 30
          },
          {
            "function": "powerline.segments.common.net.hostname",
            "priority": 10
          },
          {
            "function": "powerline.segments.common.env.virtualenv",
            "priority": 50
          },
          {
            "function": "powerline.segments.shell.cwd",
            "priority": 10
          },
          {
            "function": "powerline_gitstatus.gitstatus",
            "priority": 40
          },
          {
            "function": "powerline.segments.shell.jobnum",
            "priority": 20
          },
          {
            "function": "powerline.segments.shell.last_pipe_status",
            "priority": 10
          }
        ]
      }
    ],
    "left": [
      {
        "type": "string",
        "contents": "$",
        "highlight_groups": ["continuation:current"]
      }
    ]
  }
}
EOM

powerline-daemon --replace
