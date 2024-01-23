{ channels, ... }:
final: prev: {
  direnv = final.stdenv.mkDerivation {
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
}
