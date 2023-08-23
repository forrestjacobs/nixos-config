{ config, lib, pkgs, inputs, ... }:

# We're hard-coding the path here to avoid referencing /run/current-system.
# /run/current-system doesn't exist immediately after boot, which is annoying
# when MacOS reopens a terminal app on boot and the shell can't be found.
let fish = "/nix/var/nix/profiles/system/sw/bin/fish";

in {

  imports = [
    ../shared.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  environment.userLaunchAgents."co.t19.fetch-dots.plist" = {
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>co.t19.fetch-dots</string>
          <key>ProgramArguments</key>
          <array>
            <string>/usr/bin/git</string>
            <string>fetch</string>
          </array>
          <key>WorkingDirectory</key>
          <string>${config.users.users.forrest.home}/.config/darwin</string>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
          <key>StartInterval</key>
          <integer>3600</integer>
        </dict>
      </plist>
    '';
  };

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
