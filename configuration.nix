{ config, pkgs, lib, ... }:

{
  # Hardware scan import
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader and Kernel
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    kernel.sysctl."kernel.split_lock_mitigate"= "0";
    kernelParams = [ "quiet" "splash" ];
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
      gamescopeSession.enable = true;
    };
    gamescope.capSysNice = true;
    mosh.enable = true;
  };

  environment.sessionVariables = {
    PROTON_USE_NTSYNC = "1";
    ENABLE_HDR_WSI = "1";
    DXVK_HDR = "1";
    PROTON_ENABLE_WAYLAND = "1";
  };
  #Sets Gamescope parameters. In the future change -F "nearest" to "fsr" for FSR4 upscaling in all games
  programs.bash.loginShellInit =
    ''
      STEAM_MULTIPLE_XWAYLANDS=1 gamescope -W 1920 -H 1080 -e --xwayland-count 2 --hdr-enabled --fullscreen -F nearest --hdr-itm-enabled -- steam -pipewire-dmabuf -gamepadui -steamos > /dev/null 2>&1
    '';

  # Container Support
  virtualisation.docker.enable = true;
  # Environment
  environment.systemPackages = with pkgs; [
    vim
    wget
    btop
    curl
    tmux
    mangohud
    appimage-run
    retroarch-full
    libretro-shaders-slang
    legendary-gl
    quickemu
    steam-run
    pipx
    python3
  ];

  # User Management
  users.users.steamos = {
    isNormalUser = true;
    description = "as steamos";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ ];
  };
  services.getty = {
    helpLine = lib.mkForce "";
    greetingLine = "";
    extraArgs = [ "--skip-login" ];
    autologinUser = "steamos";
  };

  # Sudo
  security.sudo.wheelNeedsPassword = false;

  # SSH
  services.openssh.enable = true;

  # Nix Flakes and Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # System state version (do not change without reading documentation)
  system.stateVersion = "24.11";
}
