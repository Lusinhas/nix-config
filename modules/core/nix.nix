{ config, lib, pkgs, username, ... }: {
  nix = {
    package = pkgs.nixVersions.latest;
    
    settings = {
      experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
      auto-optimise-store = true;
      
      trusted-users = [ "root" username ];
      allowed-users = [ username ];
      
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org" 
        "https://hyprland.cachix.org"
        "https://helix.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];
      
      max-jobs = "auto";
      cores = 0;
      
      keep-outputs = false;
      keep-derivations = false;
      
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;
      
      use-xdg-base-directories = true;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };

    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
    
    extraOptions = ''
      builders-use-substitutes = true
      log-lines = 25
      fallback = true
      warn-dirty = false
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
    allowInsecure = false;
    
    permittedInsecurePackages = [ ];
  };
  
  system.autoUpgrade = {
    enable = false;
    dates = "weekly";
    randomizedDelaySec = "1h";
    allowReboot = false;
  };
}