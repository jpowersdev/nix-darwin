{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      # Keep rebuilds deterministic and perform Homebrew upgrades explicitly.
      autoUpdate = false;
      # Preserve application data when moving casks to Nix.
      cleanup = "uninstall";
      upgrade = false;
    };

    taps = [
      {
        name = "incident-io/tap";
        trusted = true;
      }
      {
        name = "schpet/tap";
        trusted = true;
      }
    ];

    # `brew install`
    brews = [
      "fileicon"
      "gstreamer"
      "sdl3"
      "sdl2-compat"
      "libtool"
      "llvm"
      "libomp"
      "incident-io/tap/inc"
      "schpet/tap/linear"
    ];

    # `brew install --cask`
    casks = [
      "betterdisplay"
      "conductor"
      "google-drive"
      "granola"
      "ghostty"
      "keepingyouawake"
      "keka"
      "kekaexternalhelper"
      "middleclick"
      "mountain-duck"
      "orbstack"
      # The pinned nixpkgs package currently fails to unpack its app bundle.
      "obsidian"
      "postico"
      "slack@beta"
      # The nixpkgs source archive is rate-limited by the Internet Archive.
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
  };
}
