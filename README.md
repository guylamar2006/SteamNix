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
cd Steam Non-Game Shortcut Generator
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






