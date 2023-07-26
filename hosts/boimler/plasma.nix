{ config, lib, pkgs, ... }:
{

  programs.steam.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "forrest";
      };
    };
    desktopManager.plasma5.enable = true;
  };

}
