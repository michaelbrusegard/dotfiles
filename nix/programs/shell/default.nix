{ pkgs, catppuccin, ... }: {
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableVteIntegration = true;
      autocd = true;
      defaultKeymap = "vicmd";
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=${catppuccin.flavors.mocha.overlay0}";
      };
      history = {
        append = true;
        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        saveNoDups = true;
        ignoreDups = true;
        findNoDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
        path = "$ZDOTDIR/.zsh_history";
      };
      historySubstringSearch = {
        enable = true;
        searchUpKey = "^P";
        searchDownKey = "^N";
      };
      shellAliases = {
        reload = "source ~/.zshrc";
        dl = "cd ~/Downloads";
        dt = "cd ~/Desktop";
        dc = "cd ~/Documents";
        dp = "cd ~/Developer";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        "-" = "cd -";
        ls = "eza";
        cat = "bat";
      };
      antidote = {
        enable = true;
        useFriendlyNames = true;
        plugins = [
          "sindresorhus/pure kind:fpath"
          "getantidote/use-omz"
          "ohmyzsh/ohmyzsh path:lib"
          "ohmyzsh/ohmyzsh path:plugins/git"
          "ohmyzsh/ohmyzsh path:plugins/podman"
          "ohmyzsh/ohmyzsh path:plugins/gradle"
        ]
      };
    };
    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git"
        ".DS_Store"
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "always";
      git = true;
      icons = "always";
      extraOptions = [
        "-a"
        "-1"
      ];
    };
    bat = {
      enable = true;
      config = {
        color = "always";
        italic-text = "always";
        style = "numbers";
        pager = "delta";
        paging = "never";
        map-syntax = [
          ".ignore:.gitignore"
        ];
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      colors = {
        "bg+" = "${catppuccin.flavors.mocha.surface1}";
        bg = "${catppuccin.flavors.mocha.base}";
        spinner = "${catppuccin.flavors.mocha.rosewater}";
        hl = "${catppuccin.flavors.mocha.red}";
        fg = "${catppuccin.flavors.mocha.text}";
        header = "${catppuccin.flavors.mocha.red}";
        info = "${catppuccin.flavors.mocha.mauve}";
        pointer = "${catppuccin.flavors.mocha.rosewater}";
        marker = "${catppuccin.flavors.mocha.rosewater}";
        "fg+" = "${catppuccin.flavors.mocha.text}";
        prompt = "${catppuccin.flavors.mocha.mauve}";
        "hl+" = "${catppuccin.flavors.mocha.red}";
      };
      defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git --exclude .DS_Store";
      fileWidgetCommand = "fd --hidden --strip-cwd-prefix --exclude .git --exclude .DS_Store";
      fileWidgetOptions = [
        "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; elif file --mime-type {} | grep -q \"image/\"; then chafa -f iterm -s ${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES} {}; else bat -n --color=always --line-range :500 {}; fi'"
      ];
      historyWidgetOptions = [
        "--sort"
        "--exact"
      ];
    };
    thefuck = {
      enable = true;
      enableZshIntegration = true;
      enableInstantMode = true;
    };
    jq.enable = true;
    fastfetch.enable = true;
  };
};
