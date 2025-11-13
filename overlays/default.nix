{ inputs, ... }: {
  flake.overlays.default = final: prev: {
    customPackages = import ../packages { pkgs = final; };
  };
}