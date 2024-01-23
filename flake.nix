{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: (inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;
    snowfall.namespace = "dots";
    outputs-builder = channels: {
      formatter = channels.nixpkgs.nixpkgs-fmt;
    };
  }) // {
    templates = {
      darwin = {
        path = ./templates/darwin;
        description = "Base Mac configuration";
      };
      nixos = {
        path = ./templates/nixos;
        description = "Base NixOS configuration";
      };
    };
  };
}
