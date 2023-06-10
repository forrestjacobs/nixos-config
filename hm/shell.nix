{ lib, pkgs, config, inputs, ... }: {

  home.packages = [
    pkgs.fishPlugins.hydro
  ];

  home.sessionVariables =
    let cache = "$HOME/.cache";
    in {
      # XDG
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = cache;

      # bat
      BAT_STYLE = "numbers,changes";
      BAT_THEME = "ansi";

      # exa
      TIME_STYLE = "iso";

      # fish
      fish_greeting = "";

      # helix
      EDITOR = "hx";

      # hydro
      hydro_color_pwd = "$fish_color_cwd";

      # less
      PAGER = "less";
      LESS = "-iRFXMx4";
      LESSHISTFILE = "${cache}/less-hist";

      # man
      MANOPT = "--no-justification";
    };

  programs.direnv.enable = true;

  programs.fish = {
    enable = true;

    shellInit = ''
      # homebrew
      if test -x /usr/local/bin/brew
        /usr/local/bin/brew shellenv | source
      else if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv | source
      end
    '';
    interactiveShellInit = ''
      # Open tmux when connecting via mosh
      if set -q SSH_CONNECTION
        and not set -q TMUX
        and ps -p (ps -p $fish_pid -o ppid= | string trim) -o comm= | grep mosh-server

        exec term
      end
    '';

    functions = {
      l = "bat -p $argv";
      ll = "exa -aagl $argv";
      lll = "exa -glT --level=2 $argv";
      remote = {
        argumentNames = [ "target" ];
        body = ''ssh -t "$target" term'';
      };
    };
    shellAbbrs = {
      se = "sudoedit";
    };
  };

}
