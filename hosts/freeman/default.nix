{ lib, pkgs, config, modulesPath, ... }: {

  imports = [
    ../../nixos
    "${modulesPath}/profiles/minimal.nix"
  ];

  networking.hostName = "freeman";

  services.journald.extraConfig = "SystemMaxUse=50M";

  services.syncthing.enable = true;

  wsl = {
    enable = true;
    defaultUser = "forrest";
    nativeSystemd = true;
    wslConf.automount.root = "/mnt";
  };

}
