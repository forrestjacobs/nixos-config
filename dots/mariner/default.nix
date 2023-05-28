{ config, lib, pkgs, ... }: {

  imports = [
    ../nixos

    ./docker.nix
    ./hardware-configuration.nix
    ./media.nix
    ./rclone.nix
  ];

  # from local config

  impermanence.enable = true;

  services.cloudflared = {
    enable = true;
    tunnelUuid = "c451cc44-d4e3-454e-85a5-79c30a0a7dd8";
  };

  services.forrest-ssh-agent.enable = true;

  # from global config

  networking.hostName = "mariner";

  services.openssh.enable = true;

  services.syncthing.enable = true;

  users.users.forrest = {
    passwordFile = "/etc/nixos/local/forrest-password";
    extraGroups = [
      "wheel"
      "cloudflared"
    ];
    packages = [
      pkgs.rclone
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICAI9YXHVezSBj+0RZA88GMzq+WCF6KL233ll9nD7UXD"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXWLpi6e2AQXVc36dHO0TrF676J6eiCU3Gl7gTCduWw forrest@rutherford"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVgcmpIoCHabKItQkL4Su2E7ldFubqLHlq5yd3/Nkfw forrest@freeman"
    ];
  };

}
