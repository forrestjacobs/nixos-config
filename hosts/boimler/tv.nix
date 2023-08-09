{ config, lib, pkgs, ... }:
{

  programs.firefox.enable = true;
  services.flatpak.enable = true;

  hardware.bluetooth.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.tv = {
    isNormalUser = true;
    description = "TV User";
    homeMode = "755";
    passwordFile = "/etc/nixos/local/tv-password";
  };

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "tv";
      };
    };
    desktopManager.plasma5.enable = true;
  };

}
