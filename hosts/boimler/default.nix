{ pkgs, ... }:
{

  imports = [
    ../../nixos

    ./docker.nix
    ./hardware-configuration.nix
    ./media.nix
    ./tv.nix
  ];

  # from local config

  impermanence.enable = true;

  services.update-system.enable = true;

  # from global config

  environment.etc.machine-id.source = "/etc/nixos/local/machine-id";

  networking.hostName = "boimler";

  systemd.services.cloudflare-dyndns = {
    description = "CloudFlare Dynamic DNS Client";
    after = [ "network.target" ];
    startAt = "*:0/15";

    environment.CLOUDFLARE_DOMAINS = toString [ "boimler.t19.co" ];

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "cloudflare-dyndns";
      EnvironmentFile = "/etc/nixos/local/cloudflare-api-token";
      ExecStart =
        "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns --cache-file /var/lib/cloudflare-dyndns/ip.cache -4 -no-6";
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels."2a9a5063-1732-45fd-a1f7-2520f9120c25" = {
      credentialsFile = "/etc/nixos/local/cloudflared/tunnel.json";
      default = "http_status:404";
    };
  };

  services.openssh.enable = true;

  services.syncthing.enable = true;

  users.users.forrest.passwordFile = "/etc/nixos/local/forrest-password";

}

