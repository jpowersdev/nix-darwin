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
    {
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      configuration =
        { ... }:
        {
          nixpkgs.config.allowUnfree = true;

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
          nixpkgs.hostPlatform = system;

          nix.settings.trusted-users = [
            "root"
            "jpowers"
            "@admin"
          ];
        };
    in
    {
      darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
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
