{ inputs, ... }:
{
  nixpkgs.overlays = [ inputs.llm-agents.overlays.default ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.jonathan = {
      home.stateVersion = "24.11";
      imports = [
        ./home/darwin.nix
        ./home/packages.nix
      ];
    };
  };
  users.users.jonathan.home = "/Users/jonathan";
  system.primaryUser = "jonathan";
}
