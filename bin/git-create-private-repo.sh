#!/usr/bin/env bash
set -e

# Constants

GIT_HOST=192.168.2.8
GIT_ROOT=/mnt/flashy/git-host/private/

# Variables

NAME=$1

if [[ -z "$NAME" ]]; then
    echo "Usage: $0 <name>" >&2
    exit 1
fi

shift

if [[ "$1" != "--remote-exec" ]]; then
    echo "[!] Local: Shipping myself to $GIT_HOST..."

    # THE PIPE:
    # We take the content of this file ($0) and pipe it (<) into ssh.
    # 'bash -s' tells the remote shell to read from stdin.
    ssh "$GIT_HOST" "bash -s -- $NAME --remote-exec" < "$0"

    exit $?
fi

# From here on it runs on the Git host

if [[ ! -d "$GIT_ROOT" ]]; then
    echo "Error: Git root directory does not exist: $GIT_ROOT" >&2
    exit 1
fi

REPO_PATH="${GIT_ROOT}${NAME}.git"

echo "--- Creating private git repository on $(cat /etc/hostname) ---"
echo "Repo name: $NAME"
echo "Repo path: $REPO_PATH"

if [ -e "$REPO_PATH" ]; then
    echo "Error: Path already exists: $REPO_PATH" >&2
    exit 1
fi

git init --bare "$REPO_PATH"
echo "Successfully created bare repository."
