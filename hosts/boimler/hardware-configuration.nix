{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (builtins) listToAttrs map;
  main = "/dev/disk/by-uuid/a8990de5-d796-4bd7-b489-5882709f67fe";
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

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];

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
      device = "/dev/disk/by-uuid/DE1E-3E98";
      fsType = "vfat";
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

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking = {
    useDHCP = false;
    useNetworkd = true;
    interfaces.enp0s25.useDHCP = true;
  };

}
