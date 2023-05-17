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

# bin
fish_add_path -g "$HOME"/.config/dots/bin

# bat
set -xg BAT_STYLE numbers,changes
set -xg BAT_THEME ansi

# exa
set -xg TIME_STYLE iso

# helix
set -xg EDITOR hx

# less
set -xg PAGER less
set -xg LESS -iRFXMx4
set -xg LESSHISTFILE "$XDG_CACHE_HOME"/less-hist

# man
set -xg MANOPT --no-justification

# sudo
abbr -a -g se sudoedit

# Open tmux when connecting via mosh
if status is-interactive
  and set -q SSH_CONNECTION
  and not set -q TMUX
  and ps -p (ps -p $fish_pid -o ppid= | string trim) -o comm= | grep mosh-server

  exec term
end

# starship
if type -q starship
  function starship_transient_prompt_func
    starship module directory
    starship module character
  end
  starship init fish | source
  enable_transience
end

# direnv -- should stay at end
if type -q direnv
  direnv hook fish | source
end
