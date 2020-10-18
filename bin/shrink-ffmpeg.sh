#!/bin/bash
# try combining with find . -type f -size +6G -not iname "*.mp4"
FILE="$1"

if [ ! -r "$FILE" ]; then
  echo "Error: File $FILE not found"
  exit 1
fi

NEW_FILE=$(echo "$FILE" | sed -r 's/\.[A-Za-z0-9]+$/.mp4/')
if [ "$FILE" = "$NEW_FILE" ]; then
  echo "$FILE already converted."
  exit 0
fi

echo "Converting $FILE to $NEW_FILE"
echo "Original file size: $(du --si "$FILE" | cut -f1)"

ffmpeg -nostats -loglevel warning -i "$FILE" "$NEW_FILE"
if [ $? -ne 0 ]; then
  echo "Error converting $FILE"
  rm "$NEW_FILE"
  exit 1
fi

echo "New file size: $(du --si "$NEW_FILE" | cut -f1)"

OLD_SIZE=$(du "$FILE" | cut -f1)
NEW_SIZE=$(du "$NEW_FILE" | cut -f1)

if [ $NEW_SIZE -lt $OLD_SIZE ]; then
  echo "New file is smaller than original file"
  if [ $NEW_SIZE -lt 10000 ]; then
    echo "Error: New file is too small, less than 10KB..."
    rm "$NEW_FILE"
    exit 1
  else
    rm "$FILE"
  fi
else
  echo "New file is larger that original file!"
  rm "$NEW_FILE"
fi
