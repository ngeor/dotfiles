#!/usr/bin/env bash
set -e -x

NAME=$1

if [[ ! -d ../$NAME ]]; then
    echo "Not a directory: $NAME"
    exit 1
fi

# Go to the repo that is going to be migrated into the monorepo
cd ../$1

# Get latest
git checkout master
git pull

# Got to the monorepo
cd ../win-retro

# Add the old repo as a subtree

# First flavor: subfolder under some folder in the monorepo
# git subtree add -P java/$1 ../$1/ master

# Second flavor: entire contents become a top-level folder in the monorepo
git subtree add -P TP6/ ../$1/ master

# Push to monorepo
git push

# Delete old repo
rm -rf ../$1
