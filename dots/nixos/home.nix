{ lib, pkgs, config, inputs, ... }: {

  home.stateVersion = "22.11";

  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "home-bin";
      src = ../bin;
      installPhase = ''
        shopt -s extglob
        mkdir -p $out/bin
        cp !(dot*) $out/bin
      '';
    })

    pkgs.bat
    pkgs.delta
    pkgs.direnv
    pkgs.exa
    pkgs.gitui
    pkgs.unstable.helix
    pkgs.htop
    pkgs.jq
    pkgs.lsof
    pkgs.mosh
    pkgs.ncdu
    pkgs.nix-tree
    pkgs.nixpkgs-fmt
    pkgs.nodePackages.bash-language-server # bash lsp
    pkgs.openssh
    pkgs.p7zip
    pkgs.patchutils
    pkgs.rnix-lsp # nix lsp
    pkgs.starship
    pkgs.tmux
    pkgs.unzip
  ];

  programs.git = {
    enable = true;
    userName = "Forrest Jacobs";
    userEmail = "forrestjacobs@gmail.com";
    extraConfig.include.path = "~/.config/git/main.inc";
  };

  xdg.configFile = {
    fish = {
      source = ../../fish;
      recursive = true;
    };
    git = {
      source = ../../git;
      recursive = true;
    };
    helix.source = ../../helix;
    tmux.source = ../../tmux;
    "starship.toml".source = ../../starship.toml;
  };

}
