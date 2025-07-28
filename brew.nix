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
          "thebrowsercompany-dia"
          "betterdisplay"
          "bruno"
          "chatgpt"
          "cursor"
          "darktable"
          "discord"
          "firefox@developer-edition"
          "ghostty"
          "google-chrome"
          "iina"
          "keepingyouawake"
          "keka"
          "kekaexternalhelper"
          "keyboardcleantool"
          "linear-linear"
          "lm-studio"
          "middleclick"
          "mongodb-compass"
          "mountain-duck"
          "orbstack"
          "postico"
          "signal"
          "slack@beta"
          "spotify"
          "steam"
          "stremio"
          "syncthing"
          "telegram"
          "tuple"
          "utm"
          "via"
          "visual-studio-code@insiders"
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
