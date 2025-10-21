{
  lib,
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "monokai_soda";
      editor.file-picker = {
        hidden = false;
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
          ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
          ":open %sh{cat /tmp/unique-file}"
          ":redraw"
        ];
      };
    };
    languages.language-server = {
      biome = {
        command = "biome";
        args = [ "lsp-proxy" ];
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
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "javascript";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "tsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "jsx";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "json";
        language-servers = [
          {
            name = "vscode-json-language-server";
            except-features = [ "format" ];
          }
          "biome"
        ];
        auto-format = true;
      }
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
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
