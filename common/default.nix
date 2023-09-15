{ config, lib, pkgs, ... }: {
  nixpkgs.overlays = [
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
      plex =
        let plexpass-lock = lib.importJSON ./plexpass.json;
        in prev.plex.override {
          plexRaw = prev.plexRaw.overrideAttrs (x: {
            name = "plexmediaserver-${plexpass-lock.version}";
            src = pkgs.fetchurl {
              url = plexpass-lock.release.url;
              sha1 = plexpass-lock.sha1;
            };
          });
        };
    })
  ];
}
