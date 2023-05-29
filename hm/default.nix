{ lib, pkgs, config, inputs, ... }: {

  home.stateVersion = "22.11";

  home.packages = [
    (pkgs.stdenv.mkDerivation {
      name = "home-bin";
      src = ./bin;
      installPhase = ''
        mkdir -p $out/bin
        cp * $out/bin
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
    extraConfig = {
      diff.colorMoved = "default";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      pull.ff = "only";
    };
    ignores = [
      ".DS_Store"
      "*.forrest"
      "*.forrest.*"
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
  };

  xdg.configFile = {
    fish = {
      source = ./fish;
      recursive = true;
    };
    helix.source = ./helix;
    kitty.source = ./kitty;
    tmux.source = ./tmux;
    "starship.toml".source = ./starship.toml;
  };

}
