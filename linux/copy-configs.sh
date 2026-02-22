#!/usr/bin/env bash
set -e

# Copies configs into an archive folder
DEST=~/Sync/configs/hp

if [[ ! -d "$DEST" ]]; then
    echo "$DEST does not exist"
    exit 1
fi

mkdir -p "$DEST/syncthing"
cp "$HOME/.local/state/syncthing/config.xml" "$DEST/syncthing"

mkdir -p "$DEST/ssh"
cp $HOME/.ssh/id* "$DEST/ssh"

mkdir -p "$DEST/etc"
cp /etc/fstab "$DEST/etc"
