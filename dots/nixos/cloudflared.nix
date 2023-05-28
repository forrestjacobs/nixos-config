{ config, lib, pkgs, ... }:

let
  inherit (builtins) toFile toJSON;
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.services.cloudflared;
  configFile = toFile "cloudflared-config.yml" (toJSON {
    tunnel = cfg.tunnelUuid;
    credentials-file = "/etc/cloudflared/${cfg.tunnelUuid}.json";
    origincert = "/etc/cloudflared/cert.pem";
    no-autoupdate = true;
  });

in
{

  options.services.cloudflared = {
    enable = mkEnableOption "Cloudflared";
    tunnelUuid = mkOption {
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # See https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size
    boot.kernel.sysctl."net.core.rmem_max" = 2 * 1024 * 1024;

    environment = {
      etc."cloudflared".source = "/etc/nixos/local/cloudflared";
      systemPackages = [ pkgs.cloudflared ];
    };

    systemd.services.cloudflared = {
      description = "Cloudflared";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = ''
          ${pkgs.cloudflared}/bin/cloudflared --config ${configFile} tunnel run
        '';
        User = "cloudflared";
        Group = "cloudflared";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "full";
      };
    };

    users.groups.cloudflared = { };

    users.users.cloudflared = {
      isSystemUser = true;
      group = "cloudflared";
    };
  };

}
