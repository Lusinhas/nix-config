{ config, lib, pkgs, ... }: {
  imports = [
    ./gpu.nix
    ./audio.nix
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    enableRedistributableFirmware = true;
    enableAllFirmware = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
  
  services.udev.extraRules = ''
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="mq-deadline", ATTR{queue/scheduler}="kyber"
    SUBSYSTEM=="block", ATTR{queue/scheduler}=="bfq", ATTR{queue/scheduler}="kyber"
  '';
}