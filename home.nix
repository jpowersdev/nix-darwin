{ inputs, work, ... }:
{
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.shared-nixpkgs
    (import ./overlays)
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs work; };
    users.jonathan = {
      home.stateVersion = "26.05";
      imports = [
        ./home/packages.nix
      ];
    };
  };
  users.users.jonathan.home = "/Users/jonathan";
  system.primaryUser = "jonathan";
}
