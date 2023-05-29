{ lib, pkgs, config, inputs, modulesPath, ... }: {

  imports = [
    ../../nixos

    inputs.NixOS-WSL.nixosModules.wsl
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
