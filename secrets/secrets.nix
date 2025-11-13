let
  nixos-desktop = "ssh-ed25519 <key>";
  nixos-laptop = "ssh-ed25519 <key>";
  
  desktop-host = "ssh-ed25519 <key>";
  laptop-host = "ssh-ed25519 <key>";
  
  allUsers = [ nixos-desktop nixos-laptop ];
  allHosts = [ desktop-host laptop-host ];
  allKeys = allUsers ++ allHosts;
in
{
  "git-name.age".publicKeys = allKeys;
  "git-email.age".publicKeys = allKeys;
  "user-password.age".publicKeys = allKeys;
}
