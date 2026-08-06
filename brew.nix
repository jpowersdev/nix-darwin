{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
      upgrade = true;
    };

    taps = [
      {
        name = "anomalyco/tap";
        trusted = true;
      }
      {
        name = "schpet/tap";
        trusted = true;
      }
    ];

    # `brew install`
    brews = [
      "aspell"
      "fileicon"
      "gstreamer"
      "sdl3"
      "sdl2-compat"
      "k9s"
      "kubectl"
      "libtool"
      "llvm"
      "libomp"
      "pngpaste"
      "pulumi"
      "anomalyco/tap/opencode"
      "schpet/tap/linear"
    ];

    # `brew install --cask`
    casks =
      let
        packages = [
          "betterdisplay"
          "bruno"
          "conductor"
          "cursor"
          # Discord has its own updater; forcing greedy Homebrew cask upgrades can leave
          # the app's internal updater in an inconsistent installer state.
          {
            name = "discord";
            greedy = false;
          }
          "db-browser-for-sqlite"
          "firefox@developer-edition"
          "google-chrome"
          "google-drive"
          "granola"
          "ghostty"
          "keepingyouawake"
          "jetbrains-toolbox"
          "keka"
          "kekaexternalhelper"
          "lens"
          "lm-studio"
          "middleclick"
          "mountain-duck"
          "ngrok"
          "orbstack"
          "obsidian"
          "postico"
          "signal"
          "slack@beta"
          "spotify"
          "steam"
          "syncthing-app"
          "tailscale-app"
          "telegram"
          "tabby"
          "tuple"
          "utm"
          "via"
          "visual-studio-code"
          "vivaldi"
          "whatsapp"
          "xquartz"
          "zoom"
        ];
      in
      (map (
        pkg:
        if builtins.isString pkg then
          {
            name = pkg;
            greedy = true;
          }
        else
          pkg
      ) packages)
      ++ [ ];
  };
}
