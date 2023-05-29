{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (builtins) listToAttrs map;
  main = "/dev/sda2";
  subvolume = name: {
    device = main;
    fsType = "btrfs";
    options = [ "subvol=${name}" "compress=zstd" "noatime" ];
  };
  subvolumes = names: listToAttrs (map
    (name: {
      name = "/${name}";
      value = subvolume name;
    })
    names);

in
{

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
      systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/1B4E-CA38";
      fsType = "vfat";
    };
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };
    "/mnt/main" = {
      device = main;
      fsType = "btrfs";
    };
  } // subvolumes [
    "etc/nixos"
    "home"
    "nix"
    "var/lib"
    "var/log"
  ];

  networking = {
    useDHCP = false;
    useNetworkd = true;
    interfaces.enp0s3.useDHCP = true;
  };

}
