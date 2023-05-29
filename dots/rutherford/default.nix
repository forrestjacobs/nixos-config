{ config, lib, pkgs, inputs, ... }: {

  imports = [
    inputs.home-manager.darwinModules.home-manager
    ../shared
  ];

  environment.shells = [ pkgs.fish ];

  services.nix-daemon.enable = true;

  users.users.forrest = {
    description = "Forrest Jacobs";
    home = "/Users/forrest";
    shell = pkgs.fish;
  };

}
