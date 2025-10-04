export SHELL_TOOLKIT="shell"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";
export HISTCONTROL='ignoreboth';

export EDITOR='vim';

export MANPAGER='less -X';

export IP_REGEX="(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])"
export MAC_REGEX="[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}"

export GPG_TTY="$(tty)"

# Mac
export BASH_SILENCE_DEPRECATION_WARNING=1

# Python
export VIRTUAL_ENV_DISABLE_PROMPT=1
