{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";

      # Current job settings. Update this block when changing jobs.
      work = {
        githubOrg = "vitalizecare";
        repository = "web-app";
      };

      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # Let nix-darwin manage the Lix installation and /etc/nix/nix.conf.
          nix.enable = true;
          nix.package = pkgs.lix;

          # Flake-based lookup is sufficient; omit the nonexistent legacy root channel.
          nix.nixPath = [ "nixpkgs=flake:nixpkgs" ];

          nix.settings = {
            # Necessary for using `nix` subcommands and flakes.
            experimental-features = [
              "nix-command"
              "flakes"
            ];

            # Trust the Numtide cache system-wide instead of prompting via flake nixConfig.
            extra-substituters = [ "https://cache.numtide.com" ];
            extra-trusted-public-keys = [
              "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
            ];

            trusted-users = [
              "root"
              "jonathan"
              "@admin"
            ];
          };

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = system;

        };
    in
    {
      darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs work; };
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          ./system.nix
          ./brew.nix
          ./home.nix
        ];
      };
    };
}
