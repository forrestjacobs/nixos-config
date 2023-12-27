{ config, lib, pkgs, ... }: {
  nixpkgs.overlays = [
    (import ./direnv.nix)
    (import ./gencolor.nix)
  ];
}
