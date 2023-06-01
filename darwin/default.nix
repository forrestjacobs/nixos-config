{ config, lib, pkgs, inputs, ... }: {

  imports = [ ../shared.nix ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.forrest = { pkgs, ... }: {
      imports = [ ../hm ];
    };
  };

  nix.settings = {
    # Not on Mac because https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;
    experimental-features = [ "nix-command" "flakes" ];
  };

  programs.fish = {
    enable = true;
    babelfishPackage = pkgs.babelfish;
    useBabelfish = true;
  };

}
