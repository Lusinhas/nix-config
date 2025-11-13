{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    
    allowedTCPPortRanges = [ ];
    allowedUDPPortRanges = [ ];
    
    interfaces = { };
    
    extraCommands = ''
      iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
      iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
      
      iptables -A INPUT -m state --state INVALID -j DROP
      iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
      iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
      
      iptables -A INPUT -p tcp --dport 22 -m recent --name ssh --set
      iptables -A INPUT -p tcp --dport 22 -m recent --name ssh --rcheck --seconds 60 --hitcount 4 -m limit --limit 1/min --limit-burst 1 -j LOG --log-prefix "SSH_brute_force "
      iptables -A INPUT -p tcp --dport 22 -m recent --name ssh --rcheck --seconds 60 --hitcount 4 -j DROP
    '';
    
    logRefusedConnections = false;
    logRefusedPackets = false;
    logRefusedUnicastsOnly = true;
    
    pingLimit = "--limit 1/minute --limit-burst 5";
    
    checkReversePath = lib.mkForce "strict";
  };
  
  networking.nftables = {
    enable = false;
  };
}
