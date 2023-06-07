{ config, lib, pkgs, modulesPath, ... }: {

  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "xen_blkfront"
    ];
    kernelModules = [ "nvme" ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  impermanence.btrfs.device = "/dev/sda2";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1B4E-CA38";
    fsType = "vfat";
  };

  networking = {
    useDHCP = false;
    useNetworkd = true;
    interfaces.enp0s3.useDHCP = true;
  };

}
