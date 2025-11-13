{ config, lib, pkgs, inputs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "nixos-desktop";

  hardware.cpu.amd.updateMicrocode = true;

  fileSystems."/" = {
    options = [ "compress=zstd:1" "noatime" "space_cache=v2" "discard=async" ];
  };

  system.stateVersion = "25.05";
}
