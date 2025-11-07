{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "mongodb/brew"
      "derailed/k9s"
      "pulumi/tap"
      "sst/tap"
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
    ];

    # `brew install --cask`
    casks =
      let
        packages = [
          "betterdisplay"
          "bruno"
          "cursor"
          "discord"
          "db-browser-for-sqlite"
          "firefox@developer-edition"
          "google-chrome"
          "ghostty"
          "keepingyouawake"
          "keka"
          "kekaexternalhelper"
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
