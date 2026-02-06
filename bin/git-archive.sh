#!/usr/bin/env bash
set -e

SRC=/mnt/flashy/projects
DEST=~/Archive/git-archive

if [[ ! -d $SRC ]]; then
    echo "$SRC does not exist"
    exit 1
fi

if [[ ! -d $DEST ]]; then
    echo "$DEST does not exist"
    exit 1
fi

for name in $(ls $SRC); do
    if [[ -d "$SRC/$name" && -d "$SRC/$name/.git" ]]; then
        if [[ -d "$DEST/$name" ]]; then
            rm -rf "$DEST/$name"
        fi
        echo "Cloning $SRC/$name into $DEST/$name"
        git clone --bare -q "$SRC/$name" "$DEST/$name"
    fi
done
