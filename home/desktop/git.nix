{ osConfig, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault (builtins.readFile osConfig.age.secrets.git-name.path);
    userEmail = lib.mkDefault (builtins.readFile osConfig.age.secrets.git-email.path);

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nano";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      rerere.enabled = true;
      branch.autosetupmerge = "always";
      branch.autosetuprebase = "always";
      commit.gpgsign = false;
      tag.gpgsign = false;
      fetch.prune = true;
      push.default = "simple";
      status.showUntrackedFiles = "all";
    };

    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      ".direnv"
      "result"
      "result-*"
      "node_modules"
      ".env"
      ".env.local"
      "*.log"
    ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "TwoDark";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          lightTheme = false;
        };
      };
    };
  };
}