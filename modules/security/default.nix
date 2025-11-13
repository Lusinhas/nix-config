{ lib, ... }: {
  imports = [
    ./hardening.nix
    ./firewall.nix
    ./apparmor.nix
    ./fail2ban.nix
  ];
}