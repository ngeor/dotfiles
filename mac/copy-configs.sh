#!/usr/bin/env bash
set -e

# Copies configs into an archive folder
DEST=/Volumes/Lexar128G/configs

if [[ ! -d "$DEST" ]]; then
    echo "$DEST does not exist"
    exit 1
fi

mkdir -p "$DEST/syncthing"
cp "$HOME/Library/Application Support/Syncthing/config.xml" "$DEST/syncthing"

mkdir -p "$DEST/ssh"
cp $HOME/.ssh/id* "$DEST/ssh"
