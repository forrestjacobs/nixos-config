{ config, lib, pkgs, ... }:

let
  inherit (builtins) listToAttrs map;
  cfg = config.impermanence;
  toSubvolumeMount = name: {
    name = "/${name}";
    value = {
      device = cfg.btrfs.device;
      fsType = "btrfs";
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
          "home"
          "nix"
          "var/lib"
          "var/log"
        ];
      };
    };

  };

  config = lib.mkIf cfg.enable {

    services.openssh.hostKeys = [
      { type = "ed25519"; path = "/etc/nixos/local/ssh/ssh_host_ed25519_key"; }
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

    users.mutableUsers = false;

  };

}
