{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }:
    {
      darwinModules.default = { ... }: {
        imports = [
          ./common
          home-manager.darwinModules.home-manager
          ./darwin
        ];
      };
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
