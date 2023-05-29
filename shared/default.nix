{ config, lib, pkgs, inputs, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.forrest = { pkgs, ... }: {
      imports = [ ../hm ];
    };
  };

  nix.settings = {
    auto-optimise-store = true;
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