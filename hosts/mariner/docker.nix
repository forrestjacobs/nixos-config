{ config, lib, pkgs, ... }: {

  systemd.services.local-docker-services = {
    description = "Local Docker services";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig =
      let cmdPrefix = "${pkgs.docker}/bin/docker compose --env-file /etc/nixos/local/docker/.env -f /etc/nixos/local/docker/compose.yaml";
      in {
        ExecStartPre = [
          "-${cmdPrefix} pull"
        ];
        ExecStart = "${cmdPrefix} up";
        ExecStop = "${cmdPrefix} down";
      };
  };

  users.users.docker-services = {
    isSystemUser = true;
    group = "media";
    uid = 990;
  };

  virtualisation.docker.enable = true;

}
