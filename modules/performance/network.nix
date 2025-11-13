{ config, lib, pkgs, ... }: {
  boot.kernel.sysctl = {
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_window_scaling" = 1;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_no_metrics_save" = 1;
    "net.ipv4.route.flush" = 1;
    "net.ipv6.route.flush" = 1;
  };
  
  networking = {
    dhcpcd.extraConfig = "noarp";
    networkmanager.wifi.powersave = false;
  };
  
  services.irqbalance.enable = true;
}
