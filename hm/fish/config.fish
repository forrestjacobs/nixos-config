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
  # from `brew shellenv`
  set -gx HOMEBREW_PREFIX "/usr/local";
  set -gx HOMEBREW_CELLAR "/usr/local/Cellar";
  set -gx HOMEBREW_REPOSITORY "/usr/local/Homebrew";
  set -q PATH; or set PATH ''; set -gx PATH "/usr/local/bin" "/usr/local/sbin" $PATH;
  set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/usr/local/share/man" $MANPATH;
  set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/usr/local/share/info" $INFOPATH;
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

# helix
set -xg EDITOR hx

# hydro
set -xg hydro_symbol_prompt "❯"
set -xg hydro_color_pwd      green
set -xg hydro_color_git      cyan
set -xg hydro_color_duration normal
set -xg hydro_color_error    red

# less
set -xg PAGER less
set -xg LESS -iRFXMx4
set -xg LESSHISTFILE "$XDG_CACHE_HOME"/less-hist

# man
set -xg MANOPT --no-justification
