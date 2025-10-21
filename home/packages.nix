{
  pkgs,
  ...
}:
{
  imports = [
    ./helix.nix
  ];

  home = {
    packages = with pkgs; [
      bat
      byobu
      fastfetch
      htop
      ncdu
      ollama
      p7zip
      pinentry_mac
      qmk
      speedtest-cli
      testdisk
      tilt
      tree
      unzip
      xz
      yazi
      zip
      # devtools
      awscli2
      fd
      fzf
      git-trim
      lima
      jq
      postgresql
      ripgrep
      sops
      sqlfluff
      # bash
      bash-language-server
      shfmt
      # html/css/json/eslint
      vscode-langservers-extracted
      eslint
      # BEAM
      elixir
      elixir-ls
      erlang
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
      # latex
      pandoc
      texliveFull
      typst
      # lua
      luaPackages.lua-lsp
      stylua
      # markdown
      marksman
      # nix
      direnv
      hydra-check
      nil
      nixd
      nixfmt-rfc-style
      # nodejs
      nodejs
      yarn
      # pascal
      fpc
      # python
      black
      python311
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
    ];
  };

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
        };
      };
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;
      userName = "Jonathan Powers";
      userEmail = "jonathan@expand.ai";
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };
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
        ls = "exa";
        dc = "docker-compose";
        ga = "git add";
        gm = "git commit -m";
        gs = "git status";
        gb = "git checkout -b";
        gd = "git diff";
        gst = "git stash --include-untracked";
        f = "nvim ~/.zshrc";
        cat = "bat";
        kk = "kubectl";
        k = "kubectl -n expand";
        ks = "kubectl -n expand-staging";
        claudeup = "pnpm up -g @anthropic-ai/claude-code";
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

    kitty = {
      enable = true;
    };
  };
}
