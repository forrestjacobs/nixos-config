{ config, lib, pkgs, inputs, ... }: {

  imports = [
    ../shared

    ./cloudflared.nix
    ./forrest.nix
    ./impermanence.nix
  ];

  boot.loader.timeout = 3;

  environment = {
    defaultPackages = lib.mkForce [ ];
    shellAliases = lib.mkForce { };
    systemPackages = [
      pkgs.git
      pkgs.unstable.helix
      pkgs.nano
      pkgs.wget # required by VS Code WSL plugin -- who knew??
    ];
  };

  nix = {
    settings.allowed-users = [ "@wheel" ];
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  programs = {
    command-not-found.enable = false;
    fish.shellInit = ''
      set -gx EDITOR hx
    '';
    mosh.enable = lib.mkDefault config.services.openssh.enable;
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.journald.extraConfig = lib.mkDefault "SystemMaxUse=500M";

  services.openssh = {
    passwordAuthentication = false;
    permitRootLogin = "no";
    ports = [ 36522 ];
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    flags = (
      lib.concatMap
        (input: [ "--update-input" input ])
        (lib.remove "self" (builtins.attrNames inputs))
    );
    flake = "/etc/nixos";
  };

  system.stateVersion = lib.mkDefault "22.05";

  systemd.coredump.extraConfig = ''
    Storage=none
  '';

  time.timeZone = "America/New_York";

  users.defaultUserShell = pkgs.fish;

  virtualisation.docker.autoPrune.enable = true;

}
