{

  inputs.dots.url = "github:forrestjacobs/dots";

  outputs = { dots, ... }: {
    nixosConfigurations."[hostname]" = dots.inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        dots.nixosModules.default
        dots.inputs.home-manager.nixosModules.home-manager
        ./hardware-configuration.nix
        {
          home-manager.users.forrest.imports = [ dots.homeModules.default ];
          networking.hostName = "[hostname]";
          users.users.forrest.hashedPasswordFile = "/etc/persist/forrest-password";
        }
      ];
    };
    formatter = dots.formatter;
  };

}
