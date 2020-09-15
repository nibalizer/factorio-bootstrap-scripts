#!/bin/bash

# resoruce counts (iron, copper multiplier)
# server password
# max players
# name
# description
export FACTORIO_SERVER_NAME=${FACTORIO_SERVER_NAME:-"freemason"}
export FACTORIO_MAX_PLAYERS=${FACTORIO_MAX_PLAYERS:-"8"}
export FACTORIO_SERVER_PASSWORD=${FACTORIO_SERVER_PASSWORD:-"hunter2"}
export FACTORIO_SERVER_DESCRIPTION=${FACTORIO_SERVER_DESCRIPTION:-"Try to keep your jobs if you can"}
export FACTORIO_RESOURCE_COUNT=${FACTORIO_RESOURCE_COUNT:-"3"}
export FACTORIO_BITER_FREE_ZONE=$((FACTORIO_RESOURCE_COUNT * 2))


docker stop factorio
docker rm factorio

sudo mkdir -p /opt/factorio
sudo mkdir -p /opt/factorio/config

SERVER_SETTINGS_TEMPLATE=gen_factorio_configs/server-settings.json
MAP_SETTINGS_TEMPLATE=gen_factorio_configs/map-gen-settings.json

SERVER_SETTINGS_TARGET=/opt/factorio/config/server-settings.json
MAP_SETTINGS_TARGET=/opt/factorio/config/map-gen-settings.json

# template both config files

cat $SERVER_SETTINGS_TEMPLATE | envsubst | sudo tee $SERVER_SETTINGS_TARGET
cat $MAP_SETTINGS_TEMPLATE | envsubst | sudo tee $MAP_SETTINGS_TARGET 

# create config files in /opt/factorio

sudo chown -R 845:845 /opt/factorio
docker run -d \
  -p 34197:34197/udp \
  -p 27015:27015/tcp \
  -v /opt/factorio:/factorio \
  -e LOAD_LATEST_SAVE=false \
  -e GENERATE_NEW_SAVE=true \
  -e SAVE_NAME=save-$(date +%s)\
  --name factorio \
  --restart=always \
  factoriotools/factorio
