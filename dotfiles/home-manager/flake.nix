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
          homeDirectory ? "",
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # Pass variables to home.nix.
          # envHOME gets the explicitly passed homeDirectory, or falls back to reading
          # the HOME environment variable if --impure is passed, or is empty ("").
          extraSpecialArgs = {
            inherit username;
            envHOME = if homeDirectory != "" then homeDirectory else builtins.getEnv "HOME";
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
