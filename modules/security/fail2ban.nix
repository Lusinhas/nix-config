{ config, lib, pkgs, ... }: {
  services.fail2ban = {
    enable = true;
    
    maxretry = 3;
    bantime = "1h";
    
    ignoreIP = [
      "127.0.0.0/8"
      "10.0.0.0/8"
      "192.168.0.0/16"
      "172.16.0.0/12"
    ];
    
    banaction = "iptables-multiport";
    banaction-allports = "iptables-allports";
    
    jails = {
      ssh = {
        enabled = true;
        filter = "sshd";
      };
      
      nginx-http-auth = {
        enabled = false;
      };
      
      nginx-noscript = {
        enabled = false;
      };
      
      nginx-badbots = {
        enabled = false;
      };
      
      nginx-noproxy = {
        enabled = false;
      };
    };
    
    extraPackages = with pkgs; [ ipset ];
  };
}
