# ❄️ SteamOS NixOS Edition ❄️
Nix Flake for creating a SteamOS like experience on NixOS. Clean quiet boot like on SteamDeck. Two second shutdown time.

# Requirements
* PC with NixOS installed
* Ethernet Connection (wifi may work in steam, not tested)

# Features
* Zero Desktop Bloat. Gamescope is used as window manager.
* CatchyOS Kernel with BORE scheduler activated + ntsync module loaded
* Clean, textless boot. Similar to SteamDeck bootup. Minus the Splash logo.
* Read-only system files and binaries to prevent corruption or malware.
* Boot menu with previous system states, incase update breaks system, allowing you to boot to a previous good state.
* Full Control over system via Nix configuration file


# How to Build NixOS Base System from Flake
```
git clone https://github.com/leonewton253/SteamOS-NixOS-Edition.git
cp /etc/nixos/hardware-configuration.nix systemFlake/
sudo nixos-rebuild switch --flake systemFlake/
```

All Further changes to configuration.nix for the system need to be done through this command and configuration file!

# How to use VDF Editor (Add Non-Steam Games)
```
cd VDF-Editor
python shortcuts.py shortcuts.vdf "Super Video Game IV" "~/mount/ES-DE/EmulationStation.AppImage" ~/mount/ES-DE/ "" "" "" 0 0 1 0 0 FPS Puzzle
```
```
"Super Video Game IV" = Game Title 
"~/mount/ES-DE/EmulationStation.AppImage" = location of executable or command
```

Find Folder to copy VDF file to:
```
find .local/share/Steam/ -name localconfig*
```
Copy VDF file to Remote directory :
```
scp shortcuts.vdf steamos@192.168.152.163:.local/share/Steam/userdata/115922529/config/
```
Restart Steam/PC

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









