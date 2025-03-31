# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #Mitigation Performance
  boot.kernelParams = [
      "mitigations=off" 
      "quiet"
      "splash"
        ];
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  #Enable for Intel PCs
  #boot.kernel.sysctl."kernel.split_lock_mitigate"= "0";
  boot.kernel.sysctl."kernel.sched_bore" = "1";
  #Kernel Modules
  boot.initrd.kernelModules = ["ntsync"];
  #Nix Flakes
  #Enable Appimage
  programs.appimage = {
    enable = true;
    binfmt = true;
    };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  #SteamOS Auto Boot
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope.capSysNice = true;
  #hardware.xone.enable = true; # support for the xbox controller USB dongle
  programs.bash.loginShellInit = "steam-gamescope > /dev/null 2>&1";
  #CatchyOS Kernel
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;
  #Chaotic Nix Pkgs
  chaotic.mesa-git.enable = true;  
  #Sound
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
    
  # Enable networking and WiFi
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  #Silent Boot
  services.getty.helpLine = lib.mkForce "" ;
  services.getty.greetingLine = "";
  services.getty.extraArgs = ["--skip-login"];

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  #Enable Filesystem Compression
  fileSystems = {
  "/".options = [ "compress=zstd" ];
  };

  security.sudo.wheelNeedsPassword = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steamos = {
    isNormalUser = true;
    description = "as                                                                                                                                                                                   steamos";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "steamos";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     btop
     curl
     tmux
     mangohud
     appimage-run
     legendary-gl
     #emulationstation-de
     #retroarch-full
     
  ];


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

   networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
