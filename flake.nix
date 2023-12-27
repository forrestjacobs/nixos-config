{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable-pkgs, flake-utils, home-manager }:
    let
      common = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import unstable-pkgs {
              system = final.system;
              config.allowUnfree = true;
            };
          })
        ];
      };
    in
    {
      darwinModules.default = { ... }: {
        imports = [
          common
          ./common
          home-manager.darwinModules.home-manager
          ./darwin
        ];
      };
      nixosModules.default = { ... }: {
        imports = [
          common
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
