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
    hostName = "NixOS";
    networkmanager.enable = true;
    interfaces = {
      wlo1.useDHCP = true;
      enp24s0.useDHCP = false;
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Standard Editor
    ed

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

    # editor
    vim

    # util
    imagemagick

    # email
    aerc
    neomutt

    # GUIs
    xclip
    pcmanfm
    wmutils-core
    xorg.xkill
    rxvt_unicode
    libnotify

    # Fun
    steam
    minecraft
    minecraft-server
  ];

  fonts = {
    enableFontDir = true;
    fontconfig.enable = true;
    fonts = with pkgs; [
      # English/Universial
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
  hardware.pulseaudio.enable = true;
  hardware.opengl.driSupport32Bit = true;

  services = {
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "nvidia" ];
      displayManager.startx.enable = true;
      windowManager.wind.enable = true;
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "19.09";
}
