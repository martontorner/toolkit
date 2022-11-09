if command -v pip &> /dev/null && command -v powerline-daemon &> /dev/null
then
  POWERLINE_ROOT=$(pip show powerline-status | grep Location | cut -d" " -f2)

  if [ -f "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source "$POWERLINE_ROOT"/powerline/bindings/bash/powerline.sh
  fi
fi
