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
      "mongodb/brew"
      "derailed/k9s"
      "pulumi/tap"
      "sst/tap"
      "schpet/tap"
    ];

    # `brew install`
    brews = [
      "aspell"
      "fileicon"
      "gstreamer"
      "gh"
      "k9s"
      "kubectl"
      "libtool"
      "llvm"
      "libomp"
      "pngpaste"
      "pulumi"
      "sst/tap/opencode"
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
          "discord"
          "db-browser-for-sqlite"
          "firefox@developer-edition"
          "google-chrome"
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
          "tailscale"
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
