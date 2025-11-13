{ config, lib, pkgs, ... }: {
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    powertop.enable = false;
  };
  
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
  
  services.irqbalance.enable = true;
  
  boot.kernelParams = [
    "processor.max_cstate=1"
    "intel_idle.max_cstate=0"
    "idle=poll"
    "mitigations=off"
  ];
  
  services.thermald.enable = true;
  
  hardware.cpu.amd = {
    updateMicrocode = true;
    sev.enable = false;
  };
  
  services.auto-cpufreq = {
    enable = false;
  };
  
  environment.systemPackages = with pkgs; [
    stress
  ];
}
