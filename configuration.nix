{ config, pkgs, ... }:
{
  imports =
  [ 
    ./hardware-configuration.nix
    ./pkgs.nix
    ./users/seungheonoh.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 10;
    };
    cleanTmpDir = true;
  };

  i18n = {
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
    };
  };

  networking = {
    hostName = "cL7AySgCX3";
    networkmanager.enable = true;
    interfaces = {
      wlo1.useDHCP = true;
      enp24s0.useDHCP = false;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8080 ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Standard Editor
    ed

    # man
    manpages

    # Basics
    bash
    file
    unzip
    htop
    whois
    coreutils
    killall
    wget 
    tmux 
    git 
    cmake 
    ag
    clang
    jq

    # editor
    vim

    # util
    ntfs3g
    imagemagick
    ffmpeg
    pot

    # email
    aerc
    neomutt

    # GUIs
    xclip
    pcmanfm
    wmutils-core
    xorg.xkill
    rxvt_unicode
    urxvt_font_size
    libnotify
    wine
    wind
    xdotool
    feh

    #db
    influxdb

    #etc
    telegraf

    # Fun
    steam
    rpcs3
    minecraft
    minecraft-server
  ];

  fonts = {
    enableFontDir = true;
    fontconfig.enable = true;
    fonts = with pkgs; [
      # English/Universial
      ibm-plex
      unifont
      corefonts
      iosevka
      google-fonts

      # Korean
      nanum-gothic-coding

      # Emojis
      noto-fonts-emoji
      noto-fonts-cjk
    ];
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl.driSupport32Bit = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "nvidia" ];
      #displayManager.startx.enable = true;
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;
    };
    grafana = {
      enable = true;
      port = 3000;
      domain = "localhost";
      protocol = "http";
      dataDir = "/var/lib/grafana";
    };
    influxdb = {
      enable = true;
      dataDir = "/var/db/influxdb";
    };
    telegraf = {
      enable = true;
      extraConfig = {
        inputs = {
          net = { interfaces = [ "wlo1" ]; };
          netstat = {};
          cpu = { totalcpu = true; };
          sensors = {};
          kernel = {};
          mem = {};
          swap = {};
          processes = {};
          system = {};
          disk = {};
          diskio = {};
        };
        outputs = {
          influxdb = {
            database = "system_log";
            urls = [ "http://localhost:8086" ];
          };
        };
      };
    };
  };
  systemd.services.telegraf.path = [ pkgs.lm_sensors ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "19.09";
}

