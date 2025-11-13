{ config, lib, pkgs, ... }: {
  environment = {
    systemPackages = with pkgs; [
      curl
      wget
      git
      htop
      killall
      file
      which
      age
      
      pciutils
      usbutils
      
      zip
      unzip
      
      tree
      
      sbctl

      ps_mem
    ];
    
    defaultPackages = [ ];
    
    variables = {
      EDITOR = "nano";
      BROWSER = "chromium";
    };
  };

  services.flatpak.enable = true;

  programs = {
    nano.enable = true;
    git.enable = true;
    
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
  };
  
  services.locate = {
    enable = true;
    package = pkgs.mlocate;
    interval = "hourly";
    pruneBindMounts = true;
  };
}
