{ inputs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.jpowers = {
      home.stateVersion = "24.11";
      imports = [
        ./home/darwin.nix
        ./home/packages.nix
      ];
    };
  };
  users.users.jpowers.home = "/Users/jpowers";
  system.primaryUser = "jpowers";
}
