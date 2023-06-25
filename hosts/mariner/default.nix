{ config, lib, pkgs, ... }: {

  imports = [
    ../../nixos

    ./hardware-configuration.nix
  ];

  # from local config

  impermanence.enable = true;

  services.forrest-ssh-agent.enable = true;

  # from global config

  networking.hostName = "mariner";

  services.cloudflared = {
    enable = true;
    tunnels."c451cc44-d4e3-454e-85a5-79c30a0a7dd8" = {
      credentialsFile = "/etc/nixos/local/cloudflared/tunnel.json";
      default = "http_status:404";
    };
  };

  services.openssh.enable = true;

  services.syncthing.enable = true;

  users.users.forrest.passwordFile = "/etc/nixos/local/forrest-password";

}
