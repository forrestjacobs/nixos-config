{ config, lib, pkgs, ... }: {

  imports = [
    ./forrest.nix
    ./impermanence.nix
  ];

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000;
    "net.core.wmem_max" = 2500000;
  };
  boot.loader.systemd-boot.netbootxyz.enable = true;

  environment = {
    shellAliases = lib.mkForce { };
    systemPackages = [
      pkgs.git
      pkgs.helix
    ];
  };

  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      persistent = false;
      options = "--delete-older-than 14d";
    };
  };

  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      shellInit = ''
        set -gx EDITOR hx
      '';
    };
    mosh.enable = lib.mkDefault config.services.openssh.enable;
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  services.fstrim.enable = lib.mkDefault true;

  services.openssh = {
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
    ports = [ 36522 ];
  };

  system.stateVersion = lib.mkDefault "23.11";

  system.autoUpgrade = {
    allowReboot = true;
    flags = [ "--recreate-lock-file" ];
    flake = "/etc/nixos";
  };

  time.timeZone = "America/New_York";

  users.defaultUserShell = pkgs.fish;

  virtualisation.docker.autoPrune.enable = true;

}
