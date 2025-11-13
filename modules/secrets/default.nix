{ config, lib, pkgs, username, inputs, ... }: {
  age = {
    secrets = {
      git-name = {
        file = ../../secrets/git-name.age;
        owner = username;
      };
      
      git-email = {
        file = ../../secrets/git-email.age;
        owner = username;
      };
      
      user-password = {
        file = ../../secrets/user-password.age;
        owner = username;
      };
    };
    
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/home/${username}/.ssh/id_ed25519"
      "/run/media/${username}/HDD/Keys/id_ed25519"
      "/etc/nixos/secrets/keys/id_ed25519"
      "/mnt/etc/nixos/secrets/keys/id_ed25519"
    ];
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default
  ];
}
