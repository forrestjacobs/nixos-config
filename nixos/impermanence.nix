{ config, lib, pkgs, ... }:

let
  cfg = config.impermanence;

in
{

  options.impermanence.enable = lib.mkEnableOption "impermanence";

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
    };

    users.mutableUsers = false;

  };

}
