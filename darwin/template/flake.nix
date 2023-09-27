{

  inputs = {
    dots.url = "github:forrestjacobs/dots";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "dots/nixpkgs";
    };
  };

  outputs = { self, dots, darwin }: {
    darwinConfigurations."[hostname]" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        dots.darwinModules.default
        { networking.hostName = "[hostname]"; }
      ];
    };
  };

}
