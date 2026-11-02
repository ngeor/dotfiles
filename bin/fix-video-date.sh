#!/usr/bin/env bash

FILE="$1"
echo "Processing $FILE"
exiftool -overwrite_original_in_place \
    "-MediaCreateDate<CreationDate" "-FileModifyDate<CreationDate" \
    "$FILE"

# find . -type f -iname "*.mov" -exec  ~/Projects/dotfiles/bin/fix-video-date.sh \{\} \;
