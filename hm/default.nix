{ lib, pkgs, config, inputs, ... }: {

  imports = [
    ./shell.nix
  ];

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
    pkgs.exa
    pkgs.fd
    pkgs.gitui
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
    pkgs.tmux
    pkgs.unzip
  ];

  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    userName = "Forrest Jacobs";
    userEmail = lib.mkDefault "forrestjacobs@gmail.com";
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

  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    settings = {
      theme = "base16_transparent";
      editor = {
        color-modes = true;
        cursor-shape.insert = "bar";
        indent-guides.render = true;
        line-number = "relative";
      };
    };
  };

  xdg.configFile = {
    kitty.source = ./kitty;
    tmux.source = ./tmux;
  };

}
