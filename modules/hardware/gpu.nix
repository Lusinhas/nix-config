{ config, lib, pkgs, ... }: {
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  hardware.amdgpu.opencl.enable = true;

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    RADV_PERFTEST = "sam";
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
  ];
}