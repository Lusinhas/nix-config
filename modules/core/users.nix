{ config, lib, pkgs, username, ... }: {
  users = {
    mutableUsers = false;
    
    defaultUserShell = pkgs.bash;
    
    users.${username} = {
      isNormalUser = true;
      description = "Lucas";

      extraGroups = [
        "wheel"
        "networkmanager" 
        "video"
        "audio"
      ];
      
      hashedPassword = builtins.replaceStrings ["\n"] [""] (builtins.readFile config.age.secrets.user-password.path);
      
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 <key>"
      ];
    };

    users.root = {
      hashedPassword = "!";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 <key>"
      ];
    };
  };

  services.gnome.gnome-keyring.enable = lib.mkDefault true;
}
