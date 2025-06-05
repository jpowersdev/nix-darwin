{
  config,
  pkgs,
  lib,
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
