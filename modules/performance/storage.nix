{ config, lib, pkgs, ... }: {
  services.fstrim = {
    enable = true;
    interval = "daily";
  };
  
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  
  boot.kernel.sysctl = {
    "vm.dirty_expire_centisecs" = 3000;
  };
  
  environment.systemPackages = with pkgs; [
    iotop
    hdparm
  ];
}
