#!/usr/bin/env bash
set -e

DEST="/mnt/flashy/syncthing/configs"

if [[ ! -d $DEST ]]; then
	echo "$DEST does not exist"
	exit 1
fi

cp /etc/fstab $DEST
cp /etc/samba/smb.conf $DEST
cp ~/.local/state/syncthing/config.xml $DEST
