{ pkgs, ... }:

let
  git-watch = pkgs.writeShellScriptBin "git-watch" ''
    #!/usr/bin/env bash

    # Start watch in background
    ${pkgs.procps}/bin/watch -n 1 ${pkgs.git}/bin/git status --short &
    WATCH_PID=$!

    # Save terminal settings
    old_tty_settings=$(stty -g)

    # Cleanup function
    cleanup() {
        # Restore terminal settings
        stty "$old_tty_settings"
        # Kill the watch process
        kill "$WATCH_PID" 2>/dev/null
        exit 0
    }

    # Set up trap for cleanup
    trap cleanup EXIT INT TERM

    # Put terminal in raw mode to capture individual keypresses
    stty -echo -icanon time 0 min 0

    echo "Press ESC to stop watching..."

    # Monitor for escape key
    while kill -0 "$WATCH_PID" 2>/dev/null; do
        char=$(dd bs=1 count=1 2>/dev/null)
        
        # Check if escape key (ASCII 27 / 0x1b)
        if [ "$char" = $'\x1b' ]; then
            cleanup
        fi
        
        sleep 0.1
    done

    cleanup
  '';
in
{
  home.packages = [ git-watch ];
}
