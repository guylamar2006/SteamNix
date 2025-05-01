{ config, pkgs, lib, ... }:
let
  customFile = "/etc/nixos/custom.nix";
  customImport = if builtins.pathExists customFile then [ customFile ] else [];
  #For CachyOS Kernel
  chaotic = builtins.getFlake "github:chaotic-cx/nyx/nyxpkgs-unstable"; 
  nyxOverlay = chaotic.overlays.default; 
in
{
  nixpkgs.overlays = [ nyxOverlay ]; 
  # Hardware scan import
  imports = [
    ./hardware-configuration.nix
  ]
  ++ customImport;

  # Bootloader and Kernel
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "quiet" "splash" "console=/dev/null" "tpm=false" "tpm_tis.force=0" ];
    loader.timeout = 0;
    loader.limine.maxGenerations = 3;
    kernel.sysctl = {
        "kernel.split_lock_mitigate" = 0;
        "kernel.nmi_watchdog" = 0;
      };
    plymouth.enable = true;
    initrd = {
      systemd.enable = true;
      kernelModules = [  ];
      verbose = false;
    };
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernel.sysctl."kernel.sched_bore" = "1";
  };

  # Filesystem
  fileSystems."/" = { options = [ "compress=zstd" ]; };

  # Time and Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
    hostName = "nixos"; 
  };
  #test comment for sync
  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Programs and Gaming
  programs = {
    appimage = { enable = true; binfmt = true; };
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [proton-ge-bin];
      extraPackages = with pkgs; [
      wineWowPackages.stagingFull
      mangohud
      gamescope-wsi
    ];
      gamescopeSession.enable = true;
    };
    gamescope.capSysNice = true;
    mosh.enable = true;
  };
  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    ENABLE_HDR_WSI = "1";
    DXVK_HDR = "1";
  };
  #Enables COSMIC Desktop with flatpak. Comment out gamescope/greetd lines below first.
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;

  #Add this to /etc/nixos/custom.nix to change gamescope aurguments
  #programs.steam.gamescopeSession.args = ["-W 1920" "-H 1080" "--xwayland-count 2" "-e" "--hdr-enabled" ];
  
  #Gamescope Auto Boot
  services.xserver.enable = false;
  services.getty.autologinUser = "steamos";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "steam-gamescope > /dev/null 2>&1";
        user = "steamos";
      };
    };
  };

  # Container Support
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  # Environment
  environment.systemPackages = with pkgs; [
    vim
    wget
    btop
    jq
    curl
    tmux
    appimage-run
    pipx
    python3
  ];
  #Bluetooth
  hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        MultiProfile = "multiple";
        FastConnectable = true;
      };
   };

  # User Management
  users.users.steamos = {
    isNormalUser = true;
    description = "as steamos";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "seat" "audio" ];
    packages = with pkgs; [ ];
    password = "steamos";
  };
  
  # Security
  security.sudo.wheelNeedsPassword = false;
  security.polkit.enable = true;
  services.seatd.enable = true;
  
  #Auto-Update
  system.autoUpgrade.enable = true;
  
  #Sync with SteamNix Repo
  systemd.timers."update-configuration-nix" = {
    enable = true;
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  #Sync with Git Repo
  systemd.services."update-configuration-nix" = {
    enable = true;
    script = ''
      set -e
      curl -fsSL https://raw.githubusercontent.com/SteamNix/SteamNix/refs/heads/main/configuration.nix -o /etc/nixos/configuration.nix
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    path = [ pkgs.curl ];
    wantedBy = [ "network-online.target" ]; 
    after = [ "network-online.target"];
    requires = [ "network-online.target" ]; 
  };

  # SSH
  services.openssh.enable = true;

  # Nix Flakes and Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # System state version (do not change without reading documentation)
  system.stateVersion = "24.11";
}
