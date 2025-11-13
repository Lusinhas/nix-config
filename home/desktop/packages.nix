{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    btop
    eza
    fd
    fzf
    ripgrep
    jq
    unzip
    zip
    
    delta
    lazygit
    gh

    nodejs_24
    python3
    go
    pkgs.unstable.zulu25

    distrobox
 
    vlc
    pkgs.unstable.qview

    prismlauncher
    
    fastfetch
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      update_ms = 2000;
    };
  };
}
