{ config, lib, pkgs, ... }: {
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs.kdePackages; [
        xdg-desktop-portal-kde
      ];
      config.common.default = "kde";
    };
    
    mime = {
      enable = true;
      defaultApplications = {
        "text/html" = "chromium.desktop";
        "x-scheme-handler/http" = "chromium.desktop";
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/about" = "chromium.desktop";
        "x-scheme-handler/unknown" = "chromium.desktop";
        "application/pdf" = "okular.desktop";
        "text/plain" = "kate.desktop";
      };
    };
  };
  
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };
}
