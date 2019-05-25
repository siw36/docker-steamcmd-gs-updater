#!/bin/sh

if [ -z "$STEAM_APP" ]; then
  echo "STEAM_APP variable is not defined!"
  exit 1
fi

if [ $PURGE ]; then
  echo "Deleting game files from PVC"
  rm -rfv $SERVER/*
fi

cd $HOME/steamcmd
./steamcmd.sh +login anonymous +force_install_dir $SERVER +app_update $STEAM_APP validate +quit \
rm -rf /tmp/*

exit 0
