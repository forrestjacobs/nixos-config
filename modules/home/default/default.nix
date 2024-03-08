{ lib, pkgs, config, inputs, osConfig, ... }:

let
  hostName = osConfig.networking.hostName;
  genHostColor = lib.dots.gencolor hostName;

in
{

  imports = [ inputs.dotfiles.homeModules.default ];

  home.stateVersion = "23.11";

  home.packages = [
    pkgs.dots.home-bin
    pkgs.agenix
    pkgs.bat
    pkgs.darkhttpd
    pkgs.delta
    pkgs.eza
    pkgs.fd
    pkgs.fishPlugins.hydro
    pkgs.gitui
    pkgs.htop
    pkgs.jq
    pkgs.lazygit
    pkgs.lldb
    pkgs.lsof
    pkgs.mosh
    pkgs.ncdu
    pkgs.nil
    pkgs.nix-tree
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.bash-language-server # bash lsp
    pkgs.openssh
    pkgs.p7zip
    pkgs.patchutils
    pkgs.rnix-lsp # nix lsp
    pkgs.rust-analyzer
    pkgs.tmux
    pkgs.unzip
  ];

  programs.direnv.enable = true;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      garbage = "sudo nix-collect-garbage --delete-older-than 14d";
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nixos-rebuild switch --recreate-lock-file";
    };
  };

  xdg.configFile = {
    "fish/conf.d/60-generated.fish".text = ''
      set -xg hydro_color_prompt ${genHostColor 160}
    '';
    "tmux/tmux.conf".text = ''
      source ${./tmux.conf}
      set -g status-right "#[bg=#${genHostColor 64}] ${hostName} #[bg=default] "
    '';
  };

}
