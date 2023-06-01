{ config, lib, pkgs, inputs, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.forrest = { pkgs, ... }: {
      imports = [ ../hm ];
    };
  };

  nix.settings = {
    # Not on Mac because https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = !pkgs.stdenv.isDarwin;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable-pkgs {
        system = final.system;
      };
    })
  ];

  programs.fish.enable = true;

}