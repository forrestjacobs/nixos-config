{ config, lib, pkgs, ... }:

let agentCfg = config.services.forrest-ssh-agent;

in
{

  options.services.forrest-ssh-agent = {
    enable = lib.mkEnableOption "ssh-agent for Forrest";
    keys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "forrestjacobs_github" ];
    };
  };

  config = {

    nixpkgs.config.permittedInsecurePackages = [ pkgs.nodejs-16_x.name ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.forrest = { pkgs, ... }: {
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
    };

    users.users.forrest = {
      isNormalUser = true;
      description = "Forrest Jacobs";
      extraGroups = lib.mkDefault [ "wheel" ];
      openssh.authorizedKeys.keys =
        builtins.map builtins.readFile (lib.filesystem.listFilesRecursive ../../../keys/${config.networking.hostName});
    };

  };

}
