{ pkgs, ... }:

# We're hard-coding the path here to avoid referencing /run/current-system.
# /run/current-system doesn't exist immediately after boot, which is annoying
# when MacOS reopens a terminal app on boot and the shell can't be found.
let fish = "/nix/var/nix/profiles/system/sw/bin/fish";

in {

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    taps = [
      "homebrew/cask-fonts"
    ];
    casks = [
      "font-sarasa-gothic"
      "kitty"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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

  security.pam.enableSudoTouchIdAuth = true;

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
