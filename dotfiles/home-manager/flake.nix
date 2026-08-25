{
  description = "Home Manager configuration of @vorburger";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Function to create home configurations to avoid duplication.
      mkHomeConfig =
        {
          username,
          homeDirectory ? "/home/${username}",
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit username homeDirectory;
          };
          modules = [
            nix-index-database.homeModules.nix-index
            ./home.nix
          ];
        };
    in
    {
      homeConfigurations = {
        vorburger = mkHomeConfig { username = "vorburger"; };
        code = mkHomeConfig { username = "code"; };

        "vorburger@headless-workstation" = mkHomeConfig {
          username = "vorburger";
          homeDirectory = "/var/home/vorburger";
        };
        "vorburger@vorburger.c.googlers.com" = mkHomeConfig {
          username = "vorburger";
          homeDirectory = "/usr/local/google/home/vorburger";
        };
        "vorburger@vorburger" = mkHomeConfig {
          username = "vorburger";
          homeDirectory = "/usr/local/google/home/vorburger";
        };
      };
    };
}
