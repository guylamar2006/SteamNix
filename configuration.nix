{ config, pkgs, lib, ... }:
let
  customFile = "/etc/nixos/custom.nix";
  customImport = if builtins.pathExists customFile then [ customFile ] else [];
in
{
  # Hardware scan import
  imports = [
    ./hardware-configuration.nix
  ]
  ++ customImport;

  # Bootloader and Kernel
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "quiet" "splash" "console=/dev/null" "tpm=false" "tpm_tis.force=0" "8250.nr_uarts=0" ];
    loader.timeout = 0;
    kernel.sysctl."kernel.split_lock_mitigate"= "0";
    
    plymouth.enable = true;
    initrd = {
      systemd.enable = true;
      kernelModules = [ "ntsync" ];
      verbose = false;
    };
    consoleLogLevel = 0;
    kernelPackages = pkgs.linuxPackages_latest;
    # kernel.sysctl."kernel.sched_bore" = "1";
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
      extraPackages = with pkgs; [
      wineWowPackages.stagingFull
    ];
      gamescopeSession.enable = true;
    };
    gamescope.capSysNice = true;
    mosh.enable = true;
  };

  environment.sessionVariables = {
    STEAM_MULTIPLE_XWAYLANDS = "1";
    PROTON_USE_NTSYNC = "1";
    ENABLE_HDR_WSI = "1";
    DXVK_HDR = "1";
    PROTON_ENABLE_WAYLAND = "1";
  };
  #Enables GNOME Desktop. Comment out gamescope line below first.
  #services.xserver = {
  #enable = true;
  #displayManager.gdm.enable = true;
  #desktopManager.gnome.enable = true;
  #};

  #Add this line to /etc/nixos/custom.nix to set Gamescope parameters: 1080P HDR.
  #programs.steam.gamescopeSession.args = ["-W 1920" "-H 1080" "--xwayland-count 2" "-e" "--hdr-enabled" "--hdr-itm-enabled" ];

  #Gamescope Parameters
  programs.steam.gamescopeSession.args = ["--xwayland-count 2" "-e"];

  #Gamescope Auto Boot
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "steamos";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  
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
    mangohud
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
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "seat" ];
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

  #Update ProtonGE at boot
  systemd.services.protonup = {
    enable = true;
    description = "Run ProtonUp script at boot";
    wantedBy = [ "network-online.target" ]; 
    after = [ "network-online.target"];
    requires = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        /run/current-system/sw/bin/curl -sSL https://raw.githubusercontent.com/SteamNix/SteamNix/main/protonup.sh -o /tmp/protonup.sh
        chmod +x /tmp/protonup.sh
        /tmp/protonup.sh
      '';
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
