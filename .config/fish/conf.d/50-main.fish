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

# Custom bin
fish_add_path -g "$HOME"/bin

# bat
if type bat > /dev/null
  abbr -ag l bat -p
  set -xg BAT_STYLE numbers,changes
  set -xg BAT_THEME ansi
else
  abbr -ag l less
end

# exa
if type exa > /dev/null
  set -xg TIME_STYLE iso
  abbr -ag ll exa -aagl
  abbr -ag lll exa -glT --level=2
end

# less
set -xg PAGER less
set -xg LESS -iRFXMx4
set -xg LESSHISTFILE "$XDG_CACHE_HOME"/less-hist

# man
set -xg MANOPT --no-justification

# nvim
if type nvim > /dev/null
  set -xg EDITOR nvim
  abbr -ag v nvim
else
  set -xg EDITOR vim
  abbr -ag v vim
end

# sudo
abbr -a -g sv sudoedit

# --- stuff below should stay at the end

# direnv
if type direnv > /dev/null
  direnv hook fish | source
end
