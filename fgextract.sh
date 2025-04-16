#!/usr/bin/env bash
#Tool to Extract fitgirl bins by running the setup.exe in a docker conatiner. Run this script from the same direcory as the setup.exe..


docker run -it --rm \
  --hostname="$(hostname)" \
  --name="wine" \
  --platform="linux/amd64" \
  --shm-size="1g" \
  --workdir="$HOME" \
  --env="USER_NAME=$(whoami)" \
  --env="USER_UID=$(id -u)" \
  --env="USER_GID=$(id -g)" \
  --env="USER_HOME=/home/$(whoami)" \
  --env="TZ=$(cat /etc/timezone 2>/dev/null || echo UTC)" \
  --env="USE_XVFB=yes" \
  --env="XVFB_SERVER=:95" \
  --env="XVFB_SCREEN=0" \
  --env="XVFB_RESOLUTION=320x240x8" \
  --env="DISPLAY=:95" \
  --volume "$(pwd):$HOME" \
  scottyhardy/docker-wine:stable-6.0.2 \
    wine setup.exe /verysilent
