{ config, lib, pkgs, ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      ls = "eza";
      ll = "eza -la";
      la = "eza -la";
      lt = "eza --tree";
      grep = "grep --color=auto";
      cat = "bat";
      top = "btop";
      df = "df -h";
      du = "du -h";
      free = "free -h";
      rebuild = "sudo nixos-rebuild switch --flake .";
      update = "nix flake update";
      gc = "sudo nix-collect-garbage -d";
    };
    
    initExtra = ''
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      shopt -s histappend
      
      fastfetch
    '';
  };
}