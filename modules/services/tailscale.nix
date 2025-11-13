{ config, lib, pkgs, ... }: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    openFirewall = false;
    extraUpFlags = [
      "--operator=${config.users.users.nixos.name}"
    ];
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];
  
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = with pkgs; ''
      sleep 2
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi
      ${tailscale}/bin/tailscale up --operator=${config.users.users.nixos.name}
    '';
  };
}