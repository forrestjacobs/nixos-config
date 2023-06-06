{ config, lib, pkgs, ... }:
{

  imports = [
    ../../nixos

    ./hardware-configuration.nix
  ];

  # from local config

  impermanence.enable = true;

  # from global config

  environment.etc.machine-id.source = "/etc/nixos/local/machine-id";

  networking.hostName = "boimler"; # Define your hostname.

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.openssh.enable = true;

  users.users.forrest = {
    passwordFile = "/etc/nixos/local/forrest-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNCUl6rMSDG6nUIP3R8Yl3FYmRX2WqBEOdveeHoNHze"
    ];
  };

}

