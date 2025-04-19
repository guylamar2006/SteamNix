#!/usr/bin/env bash

set -e

API="https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases"
INSTALL_DIR="$HOME/.steam/root/compatibilitytools.d"

mkdir -p "$INSTALL_DIR"

# Get the URLs and names of the last 5 .tar.gz assets
releases=$(curl -s "$API" | jq -r '[.[] | {name: .tag_name, asset: (.assets[] | select(.name | endswith(".tar.gz")) | .browser_download_url)}] | .[:5]')
urls=($(echo "$releases" | jq -r '.[].asset'))
names=($(echo "$releases" | jq -r '.[].name'))

# Download and extract each into INSTALL_DIR (if not exists)
for i in "${!urls[@]}"; do
    url="${urls[$i]}"
    name="${names[$i]}"
    dest_dir="$INSTALL_DIR/$name"
    if [[ ! -d "$dest_dir" ]]; then
        tmpfile=$(mktemp)
        echo "Downloading $name..."
        curl -L "$url" -o "$tmpfile"
        echo "Extracting $name..."
        mkdir -p "$dest_dir"
        tar -xf "$tmpfile" -C "$INSTALL_DIR"
        rm -f "$tmpfile"
    else
        echo "$name is already installed."
    fi
done

# Remove old versions, keeping only the latest 5
cd "$INSTALL_DIR"
all_dirs=($(ls -d Proton-* GE-Proton* 2>/dev/null | sort -Vr))
old_dirs=("${all_dirs[@]:5}")

for dir in "${old_dirs[@]}"; do
    echo "Removing old version: $dir"
    rm -rf "$dir"
done

echo "Done!"
