{ config, lib, pkgs, inputs, ... }: {

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable-pkgs {
        system = final.system;
      };
    })
    (final: prev: {
      direnv = pkgs.stdenv.mkDerivation {
        name = "direnv-wrapped";
        src = prev.direnv;
        # Copy everything except for /share/fish
        # because that results in sourcing direnv twice
        installPhase = ''
          mkdir -p $out/share
          cp -r bin $out/bin
          cp -r share/man $out/share/man
        '';
      };
    })
  ];

}
