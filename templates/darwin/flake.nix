{

  inputs.dots.url = "github:forrestjacobs/dots";

  outputs = { dots, ... }: {
    darwinConfigurations."[hostname]" = dots.inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        dots.darwinModules.default
        dots.inputs.home-manager.darwinModules.home-manager
        {
          home-manager.users.forrest.imports = [ dots.homeModules.default ];
          networking.hostName = "[hostname]";
        }
      ];
    };
    formatter = dots.formatter;
  };

}
