{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable-pkgs, flake-utils, home-manager, vscode-server }:
    let
      overlays = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import unstable-pkgs {
              system = final.system;
            };
            direnv = pkgs.stdenv.mkDerivation {
              name = "direnv-wrapped";
              src = prev.direnv;
              # Copy everything except for /share/fish
              # because that results in sourcing direnv twice
              installPhase = ''
                mkdir -p $out/share
                cp -r bin $out/bin
                cp -r share/man $out/share/man
              '';
            };
            plex =
              let plexpass-lock = lib.importJSON ./plexpass.json;
              in prev.plex.override {
                plexRaw = prev.plexRaw.overrideAttrs (x: {
                  name = "plexmediaserver-${plexpass-lock.version}";
                  src = pkgs.fetchurl {
                    url = plexpass-lock.release.url;
                    sha1 = plexpass-lock.sha1;
                  };
                });
              };
          })
        ];
      };
    in
    {
      darwinModules.default = { ... }: {
        imports = [
          overlays
          home-manager.darwinModules.home-manager
          ./darwin
        ];
      };
      nixosModules.default = { ... }: {
        imports = [
          overlays
          home-manager.nixosModules.home-manager
          ./nixos
        ];
        home-manager.users.forrest.imports = [
          vscode-server.nixosModules.home
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
