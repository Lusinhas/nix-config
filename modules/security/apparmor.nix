{ config, lib, pkgs, ... }: {
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
    
    policies = {
      "bin.ping" = {
        state = "enforce";
        profile = ''
          #include <tunables/global>
          
          /bin/ping flags=(complain) {
            #include <abstractions/base>
            #include <abstractions/consoles>
            #include <abstractions/nameservice>
            
            capability net_raw,
            capability setuid,
            
            /bin/ping mr,
            /etc/hosts r,
            /etc/host.conf r,
            /etc/nsswitch.conf r,
            /etc/resolv.conf r,
            
            owner @{PROC}/@{pid}/stat r,
            @{PROC}/sys/net/ipv4/ping_group_range r,
          }
        '';
      };
    };
    
    packages = with pkgs; [
      apparmor-profiles
    ];
  };
}
