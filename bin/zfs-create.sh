#!/usr/bin/env bash
POOL=$1
NAME=$2

if [[ -z "$POOL" || -z "$NAME" ]]; then
    echo "Usage: $0 POOL NAME"
    exit 1
fi

# Create a new ZFS data set
sudo zfs create $POOL/$NAME

# Change group and make it writable to group
sudo chgrp wheel /$POOL/$NAME
sudo chmod g+w /$POOL/$NAME

# Sync
rsync -av ~/$NAME/ /$POOL/$NAME/

# Make initial snapshot
sudo zfs snapshot $POOL/$NAME@v0
