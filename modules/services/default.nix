{ config, lib, pkgs, username, ... }: {
  imports = [
    ./ssh.nix
    ./tailscale.nix
    ./syncthing.nix
  ];

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    
    journald = {
      extraConfig = ''
        SystemMaxUse=500M
        MaxRetentionSec=3day
        MaxFileSec=1day
        MaxLevelStore=warning
      '';
    };
    
    logrotate.enable = true;
  };
  
  systemd.oomd.enable = true;
}
