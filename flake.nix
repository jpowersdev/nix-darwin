{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let

      darwinNixpkgsConfig = {
        config.allowUnfree = true;
      };
      configuration =
        { pkgs, ... }:
        {
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Allow determinate nix to manage nix install
          nix.enable = false;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          nix.settings.trusted-users = [
            "root"
            "jpowers"
            "@admin"
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Jonathans-MacBook-Pro
      darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./system.nix
          ./brew.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.jpowers = {
                home.stateVersion = "24.11";
                imports = [ ./home.nix ];
              };
            };
            users.users.jpowers.home = "/Users/jpowers";
            system.primaryUser = "jpowers";
          }
        ];
      };
    };
}
