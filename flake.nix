{
  description = "Example nix-darwin system flake";

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = inputs@{
      self,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      system = "aarch64-darwin";
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # Let nix-darwin manage the Lix installation and /etc/nix/nix.conf.
          nix.enable = true;
          nix.package = pkgs.lix;

          # Necessary for using `nix` subcommands and flakes.
          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = system;

          nix.settings.trusted-users = [
            "root"
            "jonathan"
            "@admin"
          ];
        };
    in
    {
      darwinConfigurations."Jonathans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs; };
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
