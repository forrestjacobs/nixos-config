{ config, lib, pkgs, ... }:

let
  inherit (builtins) listToAttrs map;
  cfg = config.impermanence;
  toSubvolumeMount = name: {
    name = "/${name}";
    value = {
      device = cfg.btrfs.device;
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=${name}" "compress=zstd" "noatime" ];
    };
  };

in
{

  options.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    btrfs = {
      device = lib.mkOption {
        type = lib.types.str;
      };
      subvolumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "etc/nixos"
          "etc/persist"
          "home"
          "nix"
          "var/lib"
          "var/log"
        ];
      };
    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.btrfs-progs
    ];

    services.openssh.hostKeys = [
      { type = "ed25519"; path = "/etc/persist/ssh/ssh_host_ed25519_key"; }
    ];

    fileSystems = {
      "/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=2G" "mode=755" ];
      };
      "/mnt/main" = {
        device = cfg.btrfs.device;
        fsType = "btrfs";
      };
    } // listToAttrs (map toSubvolumeMount cfg.btrfs.subvolumes);

    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/mnt/main" ];
    };

    users.mutableUsers = false;

  };

}
