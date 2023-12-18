{

  inputs.dots.url = "github:forrestjacobs/dots";

  outputs = { dots, ... }: {
    nixosConfigurations."[hostname]" = dots.inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        dots.nixosModules.default
        ./hardware-configuration.nix
        {
          networking.hostName = "[hostname]";
          users.users.forrest.hashedPasswordFile = "/etc/persist/forrest-password";
        }
      ];
    };
  };

}
