{ pkgs, ...}:
[
  # fish
  pkgs.bat
  pkgs.direnv
  pkgs.exa

  # git
  pkgs.delta
  pkgs.patchutils

  # nvim
  pkgs.neovim

  # utils
  pkgs.htop
  pkgs.jq
  pkgs.lsof
  pkgs.ncdu
  pkgs.nix-tree
  pkgs.nixpkgs-fmt
  pkgs.unzip
]
