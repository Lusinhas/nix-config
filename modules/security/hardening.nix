{ config, lib, pkgs, ... }: {
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
        Defaults timestamp_timeout = 30
        Defaults insults
      '';
    };

    pam = {
      services = {
        login.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
        sudo.failDelay = {
          enable = true;
          delay = 3000000;
        };
      };
      loginLimits = [
        { domain = "*"; type = "soft"; item = "nofile"; value = "65536"; }
        { domain = "*"; type = "hard"; item = "nofile"; value = "65536"; }
        { domain = "*"; type = "soft"; item = "nproc"; value = "65536"; }
        { domain = "*"; type = "hard"; item = "nproc"; value = "65536"; }
      ];
    };
    
    lockKernelModules = true;
    protectKernelImage = true;
    allowSimultaneousMultithreading = false;
    forcePageTableIsolation = true;
    virtualisation.flushL1DataCache = "always";
  };

  boot = {
    blacklistedKernelModules = [
      "dccp" "sctp" "rds" "tipc"
      "n-hdlc" "ax25" "netrom" "x25" "rose"
      "decnet" "econet" "af_802154"
      "ipx" "appletalk" "psnap" "p8023" "p8022" "can" "atm"
      "cramfs" "freevxfs" "jffs2" "hfs" "hfsplus" "squashfs" "udf"
      "bluetooth" "btusb"
    ];
    
    kernel.sysctl = {
      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
      "dev.tty.ldisc_autoload" = 0;
      "kernel.yama.ptrace_scope" = 2;
      "kernel.kexec_load_disabled" = 1;

      "net.ipv4.ip_forward" = 0;
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.secure_redirects" = 0;
      "net.ipv4.conf.default.secure_redirects" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.default.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.default.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.default.accept_source_route" = 0;
      
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.suid_dumpable" = 0;
    };
    
    kernelParams = [
      "slab_nomerge"
      "init_on_alloc=1" 
      "init_on_free=1"
      "page_alloc.shuffle=1"
      "pti=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "module.sig_enforce=1"
      "lockdown=confidentiality"
      "mce=0"
      "page_poison=1"
      "slub_debug=P"
      "slab_debug=1"
    ];
  };
}
