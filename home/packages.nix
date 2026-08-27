{
  pkgs,
  work,
  ...
}:
{
  imports = [
    ./ghostty.nix
    ./helix.nix
    ./terraform.nix
    ./commands/git-watch.nix
    ./commands/notion.nix
    ./commands/wt.nix
  ];

  home = {
    # Preserve explicit environment overrides while providing profile defaults.
    sessionVariablesExtra = ''
      export WT_ORG="''${WT_ORG:-${work.githubOrg}}"
      export WT_REPO="''${WT_REPO:-${work.repository}}"
    '';

    packages = with pkgs; [
      bat
      byobu
      fastfetch
      flyctl
      htop
      ncdu
      ollama
      p7zip
      poppler-utils
      pinentry_mac
      qmk
      rclone
      speedtest-cli
      testdisk
      tilt
      terminal-notifier
      tree
      tuicr
      unzip
      watch
      willow-voice
      xz
      zip
      # devtools
      argocd
      awscli2
      ssm-session-manager-plugin
      buildkite-cli
      fd
      fzf
      git-trim
      lima
      jq
      postgresql
      pscale
      ripgrep
      sentry-cli
      sops
      sqlfluff
      supabase-cli
      temporal-cli
      terraform
      # bash
      bash-language-server
      shfmt
      # html/css/json/eslint
      vscode-langservers-extracted
      eslint
      # BEAM
      beamPackages.elixir
      elixir-ls
      beamPackages.erlang
      # go
      go
      gopls
      # java
      jdk
      # js
      bun
      deno
      pnpm
      typescript-language-server
      typescript
      graphviz
      # haskell
      ghc
      # latex
      pandoc
      texliveFull
      typst
      # lua
      luaPackages.lua-lsp
      stylua
      # markdown
      glow
      marksman
      # nix
      direnv
      hydra-check
      nil
      nixd
      nixfmt
      # nodejs
      nodejs
      yarn
      # pascal
      fpc
      # python
      black
      pyright
      uv
      # rust
      cargo
      rustc
      rustfmt
      rustPackages.clippy
      # rust-analyzer-nightly
      yamlfmt
      yaml-language-server
      # AI coding agents (https://github.com/numtide/llm-agents.nix)
      llm-agents.pi
      llm-agents.codex
      llm-agents.claude-code
    ];
  };

  programs = {
    gh = {
      enable = true;
      extensions = [ pkgs.gh-stack ];
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings."*" = {
        ForwardAgent = true;
        AddKeysToAgent = "yes";
      };
    };

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        user = {
          name = "Jonathan Powers";
          email = "jon@powers.dev";
        };
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
      };
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

    zsh = {
      enable = true;

      shellAliases = {
        ls = "eza";
        dc = "docker compose";
        cat = "bat";
        k = "kubectl";
        mcp-cli = "npx -y @wong2/mcp-cli";
        granola-mcp = "npx -y @wong2/mcp-cli --url https://mcp.granola.ai/mcp";
        posthog = "npx -y @posthog/cli";
      };

      initContent = ''
        HISTFILE=~/.histfile
        HISTSIZE=10000
        SAVEHIST=10000

        setopt autocd extendedglob nomatch notify
        unsetopt beep
        bindkey -v

        zstyle :compinstall filename "$HOME/.zshrc"
        autoload -Uz compinit
        compinit

        eval "$(direnv hook zsh)"

        eval "$(env /opt/homebrew/bin/brew shellenv)"

        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"

        export BUN_INSTALL="$HOME/.bun"
        export PATH="$BUN_INSTALL/bin:$PATH"

        export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

        # Allow Ctrl-z to toggle between suspend and resume
        function Resume {
          fg
          zle push-input
          BUFFER=""
          zle accept-line
        }
        zle -N Resume
        bindkey "^Z" Resume
      '';
    };

    yazi = {
      enable = true;
      settings = {
        manager = {
          sort_sensitive = true;
        };
      };
    };

    zed-editor = {
      enable = true;
      themes = {
        mode = "system";
        light = "macOS Classic";
        dark = "Dracula";
      };
    };
  };
}
