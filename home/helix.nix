{
  lib,
  pkgs,
  ...
}:
let
  mkProjectTool =
    name: fallback:
    pkgs.writeShellScriptBin "${name}-flex" ''
      set -euo pipefail

      dir="$PWD"
      yarn_root=""

      while true; do
        if [ -x "$dir/node_modules/.bin/${name}" ]; then
          exec "$dir/node_modules/.bin/${name}" "$@"
        fi

        if [ -f "$dir/yarn.lock" ]; then
          yarn_root="$dir"
        fi

        if [ "$dir" = "/" ]; then
          break
        fi

        dir="$(dirname "$dir")"
      done

      if [ -n "$yarn_root" ] && command -v yarn >/dev/null 2>&1; then
        cd "$yarn_root"
        exec yarn exec ${name} "$@"
      fi

      exec ${lib.getExe fallback} "$@"
    '';

  oxlint = mkProjectTool "oxlint" pkgs.oxlint;
  oxfmt = mkProjectTool "oxfmt" pkgs.oxfmt;
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "monokai_soda";
      editor = {
        line-number = "relative";
        mouse = true;
        completion-timeout = 100;
        color-modes = true;
      };
      editor.file-picker = {
        hidden = false;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      keys.normal = {
        "C-g" = [
          ":write-all"
          ":insert-output lazygit >/dev/tty"
          ":redraw"
          ":reload-all"
        ];
        C-y = [
          # Yazi
          ":sh rm -f /tmp/unique-file"
          ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
          ":insert-output echo '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
      };
    };
    languages.language-server = {
      oxlint = {
        command = lib.getExe oxlint;
        args = [ "--lsp" ];
      };
      typescript-language-server = {
        command = "typescript-language-server";
        args = [ "--stdio" ];
        config = {
          hostInfo = "helix";
          typescript.tsserver.maxTsServerMemory = 8192;
        };
      };
    };
    languages.language = [
      {
        name = "typescript";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "oxlint"
        ];
        auto-format = true;
        formatter = {
          command = lib.getExe oxfmt;
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
      {
        name = "javascript";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "oxlint"
        ];
        auto-format = true;
        formatter = {
          command = lib.getExe oxfmt;
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
      {
        name = "tsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "oxlint"
        ];
        auto-format = true;
        formatter = {
          command = lib.getExe oxfmt;
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
      {
        name = "jsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "oxlint"
        ];
        auto-format = true;
        formatter = {
          command = lib.getExe oxfmt;
          args = [
            "--stdin-filepath"
            "%{buffer_name}"
          ];
        };
      }
      {
        name = "json";
        language-servers = [
          {
            name = "vscode-json-language-server";
            except-features = [ "format" ];
          }
        ];
        auto-format = true;
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt;
      }
      {
        name = "yaml";
        auto-format = true;
        formatter = {
          command = "yamlfmt";
          args = [ "-" ];
        };
      }
    ];
  };
}
