{ config, lib, pkgs, ... }: {

  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/media" = {
    device = "//192.168.0.101/media";
    fsType = "cifs";
    options = [
      "uid=${builtins.toString config.users.users.media.uid}"
      "file_mode=0664"
      "gid=${builtins.toString config.users.groups.media.gid}"
      "dir_mode=0775"
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=/etc/nixos/local/smb-media-secrets"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 32400 ];

  nixpkgs.config.allowUnfree = true;

  services.plex = {
    enable = true;
    group = "media";
  };

  services.tautulli.enable = true;

  users.groups.media.gid = 994;
  users.users.media = {
    isSystemUser = true;
    group = "media";
    uid = 994;
  };

}
