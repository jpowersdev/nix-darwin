{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

{
  home = {
    packages = with pkgs; [
      bat
      fastfetch
      htop
      ncdu
      p7zip
      pinentry_mac
      qmk
      speedtest-cli
      testdisk
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
      # yaml
      yaml-language-server
    ];
  };

  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
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
        	  '';
    };

  };
}
