#!/usr/bin/env bash
set -e

# Copies Git repositories into an archive folder
# Repos as copied as bare git repos.
# In order of priority:
# - Repos in /mnt/flashy/projects
# - Repos in ~/Projects
# - Repos in GitHub (uses the gh command line tool)
# Priority means that if a repo is already found in a location,
# it is not taken into account from subsequent locations.

DRY_RUN=false
VERBOSE=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n|--dry-run) DRY_RUN=true ;;
        -v|--verbose) VERBOSE=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

function remove_folder() {
    local folder="$1"
    if [[ -d "$folder" ]]; then
        if [[ "$VERBOSE" == "true" ]]; then
            echo "Removing $folder"
        fi
        if [[ "$DRY_RUN" == "false" ]]; then
            rm -rf "$folder"
        fi
    fi
}

DEST=~/Archive/git-archive

if [[ ! -d "$DEST" ]]; then
    echo "$DEST does not exist"
    exit 1
fi

SRC_1=/mnt/flashy/projects
SRC_2=~/Projects

if [[ ! -d "$SRC_1" ]]; then
    echo "$SRC_1 does not exist"
    exit 1
fi

if [[ ! -d "$SRC_2" ]]; then
    echo "$SRC_2 does not exist"
    exit 1
fi

# Associative array to keep track of processed repos
declare -A processed_repos

# Copy repos from SRC_1
echo "Copying repos from $SRC_1"
for path in "$SRC_1"/*; do
    name=$(basename "$path")
    if [[ ! -d "$path" || ! -d "$path/.git" ]]; then
        continue
    fi

    processed_repos["$name"]=1
    remove_folder "$DEST/$name"
    echo "Cloning $path into $DEST/$name"
    if [[ "$DRY_RUN" == "false" ]]; then
        git clone --bare -q "$path" "$DEST/$name"
    fi
done

# Copy repos from SRC_2
echo "Copying repos from $SRC_2"
for path in "$SRC_2"/*; do
    name=$(basename "$path")
    if [[ -v processed_repos["$name"] ]]; then
        if [[ "$VERBOSE" == "true" ]]; then
            echo "Skipping $name from $SRC_2, as it was found in $SRC_1"
        fi
        continue
    fi

    if [[ ! -d "$path" || ! -d "$path/.git" ]]; then
        continue
    fi

    processed_repos["$name"]=1
    remove_folder "$DEST/$name"
    echo "Cloning $path into $DEST/$name"
    if [[ "$DRY_RUN" == "false" ]]; then
        git clone --bare -q "$path" "$DEST/$name"
    fi
done

# Copy repos from GitHub
gh auth status
for name in $(gh api user/repos?affiliation=owner --paginate --jq '.[].name'); do
    if [[ "$VERBOSE" == "true" ]]; then
        echo "Checking $name"
    fi

    if [[ -v processed_repos["$name"] ]]; then
        if [[ "$VERBOSE" == "true" ]]; then
            echo "Skipping $name from GitHub, as it was found in $SRC_1 or $SRC_2"
        fi
        continue
    fi

    processed_repos["$name"]=1
    remove_folder "$DEST/$name"
    echo "Cloning $name from GitHub"
    if [[ "$DRY_RUN" == "false" ]]; then
        git clone --bare -q git@github.com:ngeor/$name.git "$DEST/$name"
    fi
done
