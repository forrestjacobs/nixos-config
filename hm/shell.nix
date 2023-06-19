{ lib, pkgs, config, inputs, ... }: {

  home.packages = [
    pkgs.fishPlugins.hydro
  ];

  programs.direnv.enable = true;

  programs.fish = {
    enable = true;

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
