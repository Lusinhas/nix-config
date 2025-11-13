{ config, lib, pkgs, ... }: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }  # uBlock Origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; }  # Bitwarden
    ];
    commandLineArgs = [
      "--enable-features=VaapiVideoDecoder"
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--disable-background-timer-throttling"
      "--disable-renderer-backgrounding"
      "--disable-backgrounding-occluded-windows"
      "--enable-zero-copy"
    ];
  };
  
  programs.firefox = {
    enable = false;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        ms-python.python
        esbenp.prettier-vscode
        bradlc.vscode-tailwindcss
      ];
      userSettings = {
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontSize" = 14;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.minimap.enabled" = false;
        "workbench.colorTheme" = "Default Dark Modern";
        "telemetry.telemetryLevel" = "off";
      };
    };
  };
}
