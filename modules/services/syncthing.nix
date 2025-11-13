{ config, lib, pkgs, username, ... }: {
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}/.local/share/syncthing";
    configDir = "/home/${username}/.config/syncthing";
    
    overrideDevices = true;
    overrideFolders = true;
    
    settings = {
      devices = {};
      folders = {};
      
      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
        urAccepted = -1;
        maxFolderConcurrency = 1;
        crashReportingEnabled = false;
      };
      
      gui = {
        theme = "dark";
        insecureAdminAccess = false;
        insecureSkipHostcheck = false;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
  
  systemd.services.syncthing.serviceConfig = {
    UMask = "0007";
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectHome = false;
    NoNewPrivileges = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true;
  };
}