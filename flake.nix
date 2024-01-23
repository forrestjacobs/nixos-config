{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, flake-utils, home-manager }:
    let
      darwinModule = { ... }: {
        imports = [
          ./common
          home-manager.darwinModules.home-manager
          ./darwin
        ];
      };
    in
    {
      darwinConfigurations.rutherford = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          darwinModule
          ({ pkgs, ... }: {
            networking.hostName = "rutherford";
            users.users.forrest.packages = [
              pkgs.rclone
            ];
          })
        ];
      };
      darwinModules.default = darwinModule;
      nixosModules.default = { ... }: {
        imports = [
          ./common
          home-manager.nixosModules.home-manager
          ./nixos
        ];
      };
      templates = {
        darwin = {
          path = ./darwin/template;
          description = "Base Mac configuration";
        };
        nixos = {
          path = ./nixos/template;
          description = "Base NixOS configuration";
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    });

}
