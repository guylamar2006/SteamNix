# SteamOS-NixOS-Edition
Nix Flake for creating a SteamOS like experience on NixOS. Clean quiet boot like on SteamDeck. Two second shutdown time.

# Requirements
* PC with NixOS installed
* Ethernet Connection

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
Copy VDF file to directory:
```
scp  steamos@192.168.152.163:shortcuts.vdf .local/share/Steam/userdata/115922529/config/
```
Restart Steam/PC

# Installing Epic Games
SSH into PC and run:
```
legendary install gameid
```

# Running Epic Games
* Create script such as godlike.sh
```
#!/usr/bin/env bash

GAME_ID=...

PROTON=$(find $HOME/.steam/steam/steamapps/common/ -maxdepth 1 -name Proton* | sort | sed -e '$!d')

export STEAM_GAME_PATH=<Your game install folder>
export STEAM_COMPAT_DATA_PATH="$STEAM_GAME_PATH" # Or point to where your pfx folder is
export STEAM_COMPAT_CLIENT_INSTALL_PATH="$STEAM_GAME_PATH"
legendary launch $GAME_ID --no-wine --wrapper "'$PROTON/proton' run"
```
* Fill in STEAM_GAME_PATH with path to game, default ~/Games/GameFolder
* Fill in GAME_ID with gameid
* Create a shortcut and add the full script path to the target field in parentheses: "/home/steamos/godlike.sh"









