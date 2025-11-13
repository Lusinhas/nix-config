{ pkgs }: {
  rust = pkgs.mkShell {
    packages = with pkgs; [
      rustup
      rust-analyzer
      cargo-edit
      cargo-watch
      cargo-audit
    ];
    shellHook = ''
      echo "Rust Development Environment"
      rustc --version
    '';
  };
  
  python = pkgs.mkShell {
    packages = with pkgs; [
      python313
      python313Packages.pip
      python313Packages.uv
      ruff
      black
    ];
    shellHook = ''
      echo "Python Development Environment"
      python --version
    '';
  };
  
  node = pkgs.mkShell {
    packages = with pkgs; [
      nodejs_24
      pnpm
      nodePackages.typescript
      nodePackages.eslint
      nodePackages.prettier
    ];
    shellHook = ''
      echo "Node.js Development Environment"
      node --version
      pnpm --version
    '';
  };
  
  go = pkgs.mkShell {
    packages = with pkgs; [
      go
      gopls
      gotools
      go-tools
    ];
    shellHook = ''
      echo "Go Development Environment"
      go version
    '';
  };
}
