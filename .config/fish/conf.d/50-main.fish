# XDG
set -xg XDG_CONFIG_HOME "$HOME"/.config
set -xg XDG_DATA_HOME "$HOME"/.local/share
set -xg XDG_CACHE_HOME "$HOME"/.cache

# homebrew
if test -x /usr/local/bin/brew
  /usr/local/bin/brew shellenv | source
else if test -x /opt/homebrew/bin/brew
  /opt/homebrew/bin/brew shellenv | source
end

# Custom
set -xg DOTS_HOME "$XDG_CONFIG_HOME"/dots
set -xg LOCAL_BIN_HOME "$HOME"/.local/bin
fish_add_path -g "$HOME"/.local/bin

# bat
abbr -ag l bat -p
set -xg BAT_STYLE numbers,changes
set -xg BAT_THEME ansi

# exa
set -xg TIME_STYLE iso
abbr -ag ll exa -aagl
abbr -ag lll exa -glTL2fu

# less
set -xg PAGER less
set -xg LESS -iRFXMx4
set -xg LESSHISTFILE "$XDG_CACHE_HOME"/less-hist

# man
set -xg MANOPT --no-justification

# sudo
abbr -a -g sv sudoedit

# --- stuff below should stay at the end

# direnv
direnv hook fish | source
