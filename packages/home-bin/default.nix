{ stdenv, ... }: stdenv.mkDerivation {
  name = "home-bin";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';
}
