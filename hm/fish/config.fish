# XDG
set -xg XDG_CONFIG_HOME "$HOME"/.config
set -xg XDG_DATA_HOME "$HOME"/.local/share
set -xg XDG_CACHE_HOME "$HOME"/.cache

# Open tmux when connecting via mosh
if status --is-interactive
  and set -q SSH_CONNECTION
  and not set -q TMUX
  and ps -p (ps -p $fish_pid -o ppid= | string trim) -o comm= | grep mosh-server

  exec term
end

# homebrew
if test -x /usr/local/bin/brew
  /usr/local/bin/brew shellenv | source
else if test -x /opt/homebrew/bin/brew
  # from `brew shellenv`
  set -gx HOMEBREW_PREFIX "/opt/homebrew";
  set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
  set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
  set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
  set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
  set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;
end

# bat
set -xg BAT_STYLE numbers,changes
set -xg BAT_THEME ansi

# exa
set -xg TIME_STYLE iso

# fish
set -xg fish_greeting

# helix
set -xg EDITOR hx

# hydro
set -xg hydro_color_pwd "$fish_color_cwd"

# less
set -xg PAGER less
set -xg LESS -iRFXMx4
set -xg LESSHISTFILE "$XDG_CACHE_HOME"/less-hist

# man
set -xg MANOPT --no-justification
