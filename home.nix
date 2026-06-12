{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.llm-agents.overlays.default
    (import ./overlays)
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
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
