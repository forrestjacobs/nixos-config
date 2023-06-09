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

  users.users.forrest = {
    passwordFile = "/etc/nixos/local/forrest-password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAI9YXHVezSBj+0RZA88GMzq+WCF6KL233ll9nD7UXD"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXWLpi6e2AQXVc36dHO0TrF676J6eiCU3Gl7gTCduWw forrest@rutherford"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVgcmpIoCHabKItQkL4Su2E7ldFubqLHlq5yd3/Nkfw forrest@freeman"
    ];
  };

}
