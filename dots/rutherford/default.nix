{ config, lib, pkgs, inputs, ... }: {

  imports = [ inputs.home-manager.darwinModules.home-manager ];

  environment.shells = [ pkgs.fish ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.forrest = { pkgs, ... }: {
      imports = [ ../nixos/home.nix ];
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable-pkgs {
        system = final.system;
      };
    })
  ];

  programs.fish.enable = true;

  services.nix-daemon.enable = true;

  users.users.forrest = {
    description = "Forrest Jacobs";
    home = "/Users/forrest";
    shell = pkgs.fish;
  };

}
