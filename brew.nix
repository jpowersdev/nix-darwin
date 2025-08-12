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
      "th-ch/youtube-music"
      "pulumi/tap"
    ];

    # `brew install`
    brews = [
      "aspell"
      "fileicon"
      "gstreamer"
      "k9s"
      "kubectl"
      "libtool"
      "llvm"
      "libomp"
      "pngpaste"
      "pulumi"
    ];

    # `brew install --cask`
    casks =
      let
        packages = [
          "betterdisplay"
          "bruno"
          "cursor"
          "discord"
          "firefox@developer-edition"
          "google-chrome"
          "keepingyouawake"
          "keka"
          "kekaexternalhelper"
          "middleclick"
          "mountain-duck"
          "ngrok"
          "orbstack"
          "postico"
          "signal"
          "slack@beta"
          "spotify"
          "steam"
          "syncthing"
          "telegram"
          "tuple"
          "utm"
          "via"
          "warp"
          "whatsapp"
          "xquartz"
          "zed@preview"
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
