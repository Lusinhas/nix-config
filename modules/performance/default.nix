{ lib, ... }: {
  imports = [
    ./cpu.nix
    ./memory.nix
    ./storage.nix
    ./network.nix
  ];
}