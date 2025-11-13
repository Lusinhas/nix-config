{
  description = "Modern, Secure, and High-Performance NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, disko, agenix, nixos-hardware, nixos-generators, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [
        ./overlays
      ];

      flake = {
        nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
              username = "nixos";
            };
            modules = [
              disko.nixosModules.disko
              agenix.nixosModules.default
              home-manager.nixosModules.home-manager
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-pc-ssd
              ./hosts/desktop
              ./modules/core
              ./modules/desktop
              ./modules/services
              ./modules/security
              ./modules/performance
              ./modules/hardware
              ./modules/networking
              ./modules/secrets
              {
                nixpkgs.overlays = [
                  self.overlays.default
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                      system = prev.system;
                      config.allowUnfree = true;
                    };
                  })
                ];
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = { inherit inputs; username = "nixos"; };
                  users.nixos = import ./home/desktop;
                };
              }
            ];
          };
        };

        packages.x86_64-linux = {
          iso = nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
              username = "nixos";
            };
            modules = [
              {
                nixpkgs.overlays = [
                  self.overlays.default
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                      system = prev.system;
                      config.allowUnfree = true;
                    };
                  })
                ];

                networking = {
                  hostName = "nixos-installer";
                  wireless.enable = false;
                };

                services.xserver = {
                  enable = true;
                  desktopManager.gnome.enable = true;
                  displayManager.gdm.enable = true;
                };

                environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
                  git
                  vim
                  neovim
                  wget
                  curl
                  htop
                  btop
                  tmux
                  disko.packages.x86_64-linux.disko
                  agenix.packages.x86_64-linux.default
                  parted
                  gptfdisk
                  cryptsetup
                  e2fsprogs
                  btrfs-progs
                  dosfstools
                  rsync
                  nixos-install-tools
                ];

                nix.settings = {
                  experimental-features = [ "nix-command" "flakes" ];
                  warn-dirty = false;
                };

                environment.etc."nixos-config".source = self;

                systemd.tmpfiles.rules = [
                  "d /etc/agenix-keys 0755 root root -"
                  "L+ /root/nixos-config - - - - /etc/nixos-config"
                ];

                environment.etc."install-script" = {
                  text = ''
                    #!/usr/bin/env bash
                    set -e

                    echo "NixOS Custom Configuration Installer"
                    echo "====================================="
                    echo ""

                    if [ ! -f /root/nixos-config/hosts/desktop/disko.nix ]; then
                      echo "ERROR: disko.nix not found. Please create hosts/desktop/disko.nix first."
                      exit 1
                    fi

                    echo "Step 1: Generating agenix encryption keys"
                    echo "=========================================="
                    echo ""

                    mkdir -p /tmp/secrets/keys
                    cp /root/nixos-config/secrets/secrets.nix /tmp/secrets

                    ssh-keygen -t ed25519 -N "" -C "" -f /tmp/secrets/keys/id_ed25519 -C "agenix-host-key"
                    chmod 600 /tmp/secrets/keys/id_ed25519
                    chmod 644 /tmp/secrets/keys/id_ed25519.pub

                    NEW_KEY=$(cat /tmp/secrets/keys/id_ed25519.pub)

                    echo ""
                    read -p "Enter your Git name: " GIT_NAME
                    read -p "Enter your Git email: " GIT_EMAIL
                    read -sp "Enter user password: " USER_PASSWORD
                    echo ""

                    echo ""
                    echo "Step 2: Encrypting secrets with agenix"
                    echo "======================================="
                    echo ""

                    cd /tmp/secrets
                    mkdir -p /run/agenix
                    echo "$GIT_NAME" > /run/agenix/git-name
                    echo "$EMAIL" > /run/agenix/git-email
                    echo -n "$USER_PASSWORD" | mkpasswd -m sha-512 -s > /run/agenix/user-password

                    sed -i "s|ssh-ed25519 <key>|$NEW_KEY|g" /tmp/secrets/secrets.nix

                    cat /run/agenix/git-name | agenix -e git-name.age -i /tmp/secrets/keys/id_ed25519
                    cat /run/agenix/git-email | agenix -e git-email.age -i /tmp/secrets/keys/id_ed25519
                    cat /run/agenix/user-password | agenix -e user-password.age -i /tmp/secrets/keys/id_ed25519
                    chmod 600 /tmp/secrets/*.age

                    echo "Secrets encrypted successfully!"
                    echo ""

                    echo "Step 3: Disk partitioning"
                    echo "========================="
                    echo ""

                    read -p "Enter disk device (e.g., /dev/nvme0n1 or /dev/sda): " DISK
                    if [ ! -b "$DISK" ]; then
                      echo "ERROR: $DISK is not a valid block device"
                      exit 1
                    fi

                    echo ""
                    echo "WARNING: This will ERASE ALL DATA on $DISK"
                    read -p "Are you sure? (yes/no): " CONFIRM
                    if [ "$CONFIRM" != "yes" ]; then
                      echo "Installation cancelled"
                      exit 0
                    fi

                    echo ""
                    echo "Running disko to partition and format $DISK..."
                    sed "s|/dev/sdb|$DISK|g" /root/nixos-config/hosts/desktop/disko.nix > /tmp/disko-modified.nix
                    disko --mode disko /tmp/disko-modified.nix

                    echo ""
                    echo "Step 4: Preparing installation"
                    echo "==============================="
                    echo ""

                    echo "Copying configuration to /mnt/etc/nixos..."
                    mkdir -p /mnt/etc/nixos
                    cp -r /root/nixos-config/* /mnt/etc/nixos/

                    echo "Copying encrypted secrets..."
                    mkdir -p /mnt/etc/nixos/secrets/keys
                    cp -r /tmp/secrets/keys/* /mnt/etc/nixos/secrets/keys/
                    cp /tmp/secrets/*.age /mnt/etc/nixos/secrets/

                    chmod 600 /mnt/etc/nixos/secrets/keys/id_ed25519
                    chmod 644 /mnt/etc/nixos/secrets/keys/id_ed25519.pub
                    chmod 600 /mnt/etc/nixos/secrets/*.age

                    echo "Replacing old ssh-ed25519 keys with the new one..."
                    sed -i "s|ssh-ed25519 <key>|$NEW_KEY|g" /mnt/etc/nixos/*.nix

                    echo "Generating hardware configuration..."
                    nixos-generate-config --no-filesystems --root /mnt
                    mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/desktop/
                    rm /mnt/etc/nixos/configuration.nix

                    if [ -d /etc/agenix-keys ] && [ "$(ls -A /etc/agenix-keys)" ]; then
                      echo "Copying additional agenix keys..."
                      mkdir -p /mnt/etc/agenix-keys
                      cp -r /etc/agenix-keys/* /mnt/etc/agenix-keys/
                    fi

                    echo ""
                    echo "Step 5: Installing NixOS"
                    echo "========================"
                    echo ""

                    nixos-install --flake /mnt/etc/nixos#desktop --impure

                    echo ""
                    echo "Installation complete!"
                    echo "======================"
                    echo ""
                    echo "Your agenix encryption key is at: /mnt/etc/nixos/secrets/keys/id_ed25519"
                    echo "Make sure to back this up securely!"
                    echo ""
                    read -p "Reboot now? (yes/no): " REBOOT
                    if [ "$REBOOT" = "yes" ]; then
                      reboot
                    fi
                  '';
                  mode = "0755";
                };

                boot.supportedFilesystems = [ "btrfs" "ext4" "xfs" "ntfs" "vfat" ];

                programs.bash.shellAliases = {
                  install-nixos = "/etc/install-script";
                };

                services.displayManager.autoLogin = {
                  enable = true;
                  user = "nixos";
                };

                environment.loginShellInit = ''
                  if [ "$(tty)" = "/dev/tty1" ]; then
                    echo ""
                    echo "╔═══════════════════════════════════════════════════════╗"
                    echo "║       Welcome to Custom NixOS Installer ISO           ║"
                    echo "╚═══════════════════════════════════════════════════════╝"
                    echo ""
                    echo "Your configuration is located at: /root/nixos-config"
                    echo ""
                    echo "To install NixOS with your custom configuration:"
                    echo "  sudo install-nixos"
                    echo ""
                  fi
                '';
              }
            ];
            format = "install-iso";
          };
        };
      };

      perSystem = { config, self', inputs', pkgs, system, ... }:
      let
        devShells = import ./dev-shells { inherit pkgs; };
      in {
        devShells = devShells // {
          default = pkgs.mkShell {
            packages = with pkgs; [
              agenix.packages.${system}.default
              nixos-rebuild
              git
              disko.packages.${system}.disko
            ];

            shellHook = ''
              echo "NixOS Development Environment"
              echo "Available commands: agenix, nixos-rebuild, disko"
              echo "Available dev shells: nix develop .#rust .#python .#node .#go"
              echo ""
              echo "Build ISO with embedded config: nix build .#iso"
              echo ""
              echo "After booting the ISO, run: sudo install-nixos"
            '';
          };
        };
      };
    };
}
