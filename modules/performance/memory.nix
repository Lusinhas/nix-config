{ config, lib, pkgs, ... }: {
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
    priority = 10;
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "-g"
      "--avoid '(^|/)(systemd|kernel|kthreadd|ksoftirqd|migration|rcu_|watchdog)'"
      "--prefer '(^|/)(chromium|firefox|thunderbird|code|slack)'"
    ];
  };
  
  services.systembus-notify.enable = true;
  
  boot.kernel.sysctl = {
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_writeback_centisecs" = 500;
    "vm.page-cluster" = 0;
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 50;
  };
}
