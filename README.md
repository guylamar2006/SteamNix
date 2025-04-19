# ❄️ SteamOS NixOS Edition ❄️
Nix Flake for creating a SteamOS like experience on NixOS. Clean quiet boot like on SteamDeck. Two second shutdown time. Meant for those who primarily use SSH, but would like a SteamOS experience for games. For example, you own a MacBook Pro and don't care to use linux desktop software.

# Requirements
* Desktop PC (For SteamDeck see https://github.com/Jovian-Experiments/Jovian-NixOS )

# Features
* Zero Desktop Bloat. Gamescope is used as window manager.
* Latest Kernel and NTsync
* FPS improvement over stock NixOS kernel.
* Clean, textless boot. Similar to SteamDeck bootup. Minus the Splash logo.
* Read-only system files and binaries to prevent corruption or malware.
* Boot menu with previous system states, incase update breaks system, allowing you to boot to a previous good state.
* Full Control over system via Nix configuration file


# How to Build NixOS Base System
```
git clone https://github.com/leonewton253/SteamOS-NixOS-Edition.git
mv SteamNix/configuration.nix /etc/nixos/
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nixos-rebuild boot --upgrade 
sudo reboot now
```

All Further changes to configuration.nix for the system need to be done through this command and configuration file!

# How to use Steam VDF (Add Non-Steam Games)
```
pipx install steam-vdf

usage: steam-vdf [-h] [-d] [-v] [-o {json,text}] {info,list-shortcuts,view,add-shortcut,delete-shortcut,restart-steam} ...

Steam VDF Tool

positional arguments:
  {info,list-shortcuts,view,add-shortcut,delete-shortcut,restart-steam}
    info                Display Steam library information
    list-shortcuts      List existing non-Steam game shortcuts
    view                View contents of a VDF file
    add-shortcut        Add a new non-Steam game shortcut
    delete-shortcut     Delete an existing non-Steam game shortcut
    restart-steam       Restart Steam

options:
  -h, --help            show this help message and exit
  -d, --debug           Enable debug output
  -v, --dump-vdfs       Enable dumping of VDFs to JSON
  -o {json,text}, --output {json,text}
                        Output type format

```

Restart Steam from power menu

# Headless Install of https://fitgirl-repacks.site via Docker/Podman

* Place all of Fitgirl bins and setup.exe in fgextract folder and run ./fgextract.sh
* Use btop to check when done, when QuickSFV.exe is run, its safe to exit the container.
* In the future a kill command will be added to the script.
* The files are located in the .wine folder in the current directory

# Installing Epic Games
SSH into PC and run:
```
legendary install gameid
```

# Running Epic Games with Steam's Proton
* Create script such as godlike.sh
```
#!/usr/bin/env bash

GAME_ID=...

PROTON=$(find $HOME/.steam/steam/steamapps/common/ -maxdepth 1 -name *Experimental | sort | sed -e '$!d')

export STEAM_GAME_PATH=<Your game install folder>
export STEAM_COMPAT_DATA_PATH="$STEAM_GAME_PATH" # Or point to where your pfx folder is
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_GAME_PATH"
legendary launch $GAME_ID --no-wine --wrapper "'$PROTON/proton' run"
```
* Fill in STEAM_GAME_PATH with path to game, default ~/Games/GameFolder
* Fill in GAME_ID with gameid
* Create a shortcut and add the full script path to the target field in parentheses: "/home/steamos/godlike.sh"

# Symlinking RetroArch Cores so EmulationStation can find them (If using AppImage)
```
ln -s /run/current-system/sw/lib/retroarch/cores/ .config/retroarch/
```
NixOS uses hashes as paths and are subject to change. /run/current-system contains static paths to hashed folders. 

# LiveCD AutoInstaller
* WARNING! Will erase all data on largest drive detected. Place flake.nix in empty folder and CD into folder.
* To generate ISO:
  
  ```
  git init
  git add flake.nix 
  nix build .#install-iso
  ```

# Password/Login
```
Username: steamos
Password: steamos
```
* Use "passwd" to change password, then delete line in nixos config with password.
 

# TODO
* [x] Find VDF python library
* [ ] Game banners will be imported for each sortcut
* [ ] Boot time improvement
* [ ] Add dot files for preconfigured RetroArch settings
* [x] Create minimal auto installer ISO
* [ ] Create GH pages site with basic support
* [ ] Create Fitgirl Store App with one click fitgirl installs

  









