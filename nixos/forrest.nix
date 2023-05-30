{ config, lib, pkgs, inputs, ... }:

let agentCfg = config.services.forrest-ssh-agent;

in
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.services.forrest-ssh-agent = {
    enable = lib.mkEnableOption "ssh-agent for Forrest";
    keys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "forrestjacobs_github" ];
    };
  };

  config = {
    home-manager.users.forrest = { pkgs, ... }: {
      imports = [
        inputs.vscode-server.nixosModules.home
      ];
      home.stateVersion = "22.11";
      services.vscode-server = {
        enable = true;
        nodejsPackage = pkgs.nodejs-16_x;
      };
      systemd.user.services.ssh-agent = lib.mkIf agentCfg.enable {
        Unit.Description = "SSH key agent";
        Install.WantedBy = [ "default.target" ];
        Service = {
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
          ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
          ExecStartPost = (builtins.map
            (key: "${pkgs.openssh}/bin/ssh-add %h/.ssh/${key}")
            agentCfg.keys);
        };
      };
      xdg.configFile."fish/conf.d/99-ssh-agent.fish" = lib.mkIf agentCfg.enable {
        text = ''set -xg SSH_AUTH_SOCK "$XDG_RUNTIME_DIR"/ssh-agent.socket'';
      };
    };

    users.users.forrest = {
      isNormalUser = true;
      description = "Forrest Jacobs";
      extraGroups = lib.mkDefault [ "wheel" ];
    };

    services.syncthing = {
      configDir = "/home/forrest/.config/syncthing";
      user = "forrest";
      group = "users";
    };

    networking.firewall = lib.mkIf config.services.syncthing.enable {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 21027 22000 ];
    };

  };

}