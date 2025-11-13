{ config, lib, pkgs, ... }: {
  networking = {
    hostName = lib.mkDefault "nixos-desktop";
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        macAddress = "random";
      };
      ethernet.macAddress = "random";
      dns = "systemd-resolved";
    };
    
    useDHCP = false;
    dhcpcd.enable = false;
    
    nameservers = [ 
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
    ];
    
    enableIPv6 = true;
    
    timeServers = [
      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"  
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ 
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
    ];
    dnsovertls = "true";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com
      DNSOverTLS=yes
      Cache=yes
      LLMNR=no
      MulticastDNS=no
    '';
  };
  
  services.avahi = {
    enable = false;
    nssmdns4 = false;
    nssmdns6 = false;
  };
}