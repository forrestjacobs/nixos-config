{ config, lib, pkgs, ... }:

let
  plexpass-lock = lib.importJSON ./plexpass.json;

in
{

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
    package = pkgs.plex.override {
      plexRaw = pkgs.plexRaw.overrideAttrs (x: {
        name = "plexmediaserver-${plexpass-lock.version}";
        src = pkgs.fetchurl {
          url = plexpass-lock.release.url;
          sha1 = plexpass-lock.sha1;
        };
      });
    };
  };

  # Thanks to https://gist.github.com/iamevn/11952b966c05ca799f4910e02c2ffe4a
  systemd.services.update-plexpass-lock = {
    description = "Update Plexpass lock";
    before = [ "nixos-upgrade.service" ];
    wantedBy = [ "nixos-upgrade.service" ];
    path = [ pkgs.curl pkgs.jq pkgs.nix ];
    script = ''
      versionInfo=$(curl -s -H "X-Plex-Token: KsjLojn4Bpq89zTV_6QL" "https://plex.tv/api/downloads/5.json?channel=plexpass" | jq '{
        version: .computer.Linux.version,
        release: .computer.Linux.releases | map(select(.build == "linux-x86_64" and .distro == "debian"))[0],
      }')

      hashed=$(nix-hash --to-base32 "$(echo "$versionInfo" | jq -r '.release.checksum')" --type sha1)

      echo "$versionInfo" | jq '.sha1 = "'"$hashed"'"' > /etc/nixos/hosts/boimler/plexpass.json
    '';
  };

  users.groups.media.gid = 994;
  users.users.media = {
    isSystemUser = true;
    group = "media";
    uid = 994;
  };

}
