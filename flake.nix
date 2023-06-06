{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { darwin, home-manager, nixpkgs, ... }@inputs:
    let specialArgs.inputs = inputs;
    in {
      darwinConfigurations = {
        rutherford = darwin.lib.darwinSystem {
          inherit specialArgs;
          system = "aarch64-darwin";
          modules = [ ./hosts/rutherford ];
        };
      };
      nixosConfigurations = {
        boimler = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [ ./hosts/boimler ];
        };
        freeman = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [ ./hosts/freeman ];
        };
        mariner = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "aarch64-linux";
          modules = [ ./hosts/mariner ];
        };
      };
    };

}
