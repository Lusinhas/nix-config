{ config, lib, pkgs, username, inputs, ... }: {
  imports = [
    ./shell.nix
    ./git.nix
    ./packages.nix
    ./programs.nix
  ];

  programs.home-manager.enable = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";

    sessionVariables = {
      EDITOR = "nano";
      BROWSER = "chromium";
      TERMINAL = "konsole";
      SHELL = "${pkgs.bash}/bin/bash";
    };
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      publicShare = null;
      templates = null;
    };
    
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "chromium.desktop";
        "x-scheme-handler/http" = "chromium.desktop";
        "x-scheme-handler/https" = "chromium.desktop";
        "application/pdf" = "okular.desktop";
        "text/plain" = "kate.desktop";
        "inode/directory" = "dolphin.desktop";
      };
    };
  };
}