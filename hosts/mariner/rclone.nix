{ config, lib, pkgs, ... }:

let
  home = "/var/lib/rclone";

  onedrive-mount = { remote, local, serviceConfig ? { } }:
    let
      cache-name = builtins.replaceStrings [ "/" ] [ "-" ] local;
    in
    {
      description = "Mount ${local}";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ "/run/wrappers" ];
      serviceConfig = {
        Type = "notify";
        User = "rclone";
        Group = "rclone";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone ${lib.escapeShellArgs [
            "mount"
            "--allow-other"
            "--dir-perms" "775"
            "--file-perms" "664"
            "--umask" "002"
            "--cache-dir" "${home}/.cache/${cache-name}"
            "--vfs-cache-mode" "writes"
            "--vfs-cache-max-age" "0h5m0s"
            "onedrive:${remote}"
            local
          ]}
        '';
        ExecStop = ''
          ${pkgs.fuse}/bin/fusermount ${lib.escapeShellArgs [ "-u" local ]}
        '';
      } // serviceConfig;
    };
  media-mount = onedrive-mount
    {
      remote = "Media";
      local = "/mnt/media";
      serviceConfig.Group = "media";
    };

in
{

  programs.fuse.userAllowOther = true;

  systemd.services.mount-media = media-mount // {
    before = [ "plex.service" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/media 775 rclone media -"
  ];

  users.groups.rclone = { };
  users.users.rclone = {
    group = "rclone";
    extraGroups = [ "media" ];
    home = home;
    homeMode = "755";
    createHome = true;
    isSystemUser = true;
  };

}
