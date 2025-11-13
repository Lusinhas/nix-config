{ config, pkgs, ... }: {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        Relogin = false;
      };
      Theme = {
        Current = "breeze";
      };
    };
  };

  services.xserver.xkb.layout = "br";
  
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    akregator
    discover
    dolphin-plugins
    dragon
    elisa
    gwenview
    juk
    kaddressbook
    kalarm
    kamera
    kcalc
    kcharselect
    kcolorchooser
    kdeconnect-kde
    kdenlive
    kdepim-addons
    kdepim-runtime
    kget
    kgpg
    khelpcenter
    kmail
    kmouth
    kolourpaint
    konversation
    korganizer
    krdc
    krfb
    kdeplasma-addons
    ksshaskpass
    kwallet
    kwalletmanager
    print-manager
    skanpage
    sweeper
    telly-skout
  ];
  
  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.konsole
    kdePackages.ark
    kdePackages.okular
    kdePackages.spectacle
  ];
}
