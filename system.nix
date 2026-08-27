{
  pkgs,
  ...
}:
{
  system = {
    defaults = {
      menuExtraClock.Show24Hour = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      cachix
      zlib

      # macOS applications packaged by nixpkgs.
      bruno
      code-cursor
      discord
      firefox-devedition
      google-chrome
      jetbrains-toolbox
      lens
      linear
      lmstudio
      signal-desktop
      sqlitebrowser
    ];
  };

  programs = {
    bash.enable = true;
    zsh.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      font-awesome
      material-design-icons
    ];
  };
}
