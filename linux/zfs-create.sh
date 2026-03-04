#!/usr/bin/env bash
set -ex

POOL=$1
shift
NAME=$1
shift

if [[ -z "$POOL" || -z "$NAME" ]]; then
    echo "Usage: $0 POOL NAME"
    exit 1
fi

if [ ! -d /$POOL/$NAME ]; then
    # Create a new ZFS data set
    sudo zfs create $POOL/$NAME
fi

# Change group and make it writable to group
sudo chgrp wheel /$POOL/$NAME
sudo chmod g+w /$POOL/$NAME

# Sync
# v verbose
# r recursive
# L transform links to referent file/dir
# p preserve permissions
# t preserve modification timestamps
# N preserve creation timestamps - not supported by this version of rsync
# U preserve access times
# o preserve owner
# g preserver group
# delete: delete extraneous files
# delete-excluded: also delete excluded files
# TODO: only for Projects dir, add --exclude='target' \
rsync -rLptUog --delete --delete-excluded \
    $* \
    --exclude='.DS_Store' \
    --exclude='desktop.ini' \
    --exclude='.trash' \
    --exclude='.trashed-*' \
    ~/$NAME/ /$POOL/$NAME/

# Make snapshot
sudo zfs snapshot $POOL/$NAME@$(date +%Y%m%d-%H%M%S)
