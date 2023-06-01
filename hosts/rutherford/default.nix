{ config, lib, pkgs, inputs, ... }:

# We're hard-coding the path here to avoid referencing /run/current-system.
# /run/current-system doesn't exist immediately after boot, which is annoying
# when MacOS reopens a terminal app on boot and the shell can't be found.
let fish = "/nix/var/nix/profiles/system/sw/bin/fish";

in {

  imports = [
    ../../darwin

    inputs.home-manager.darwinModules.home-manager
  ];

  environment.shells = [ fish ];

  homebrew = {
    enable = true;
    taps = [
      "homebrew/cask-fonts"
    ];
    casks = [
      "font-sarasa-gothic"
      "kitty"
    ];
  };

  services.nix-daemon.enable = true;

  users.users.forrest = {
    description = "Forrest Jacobs";
    home = "/Users/forrest";
    shell = fish;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
