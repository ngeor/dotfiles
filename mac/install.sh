#!/usr/bin/env bash
set -e

function main() {
    # readlink -e does not work on Mac
    local repo_dir=$(dirname $(readlink -f $(dirname $0)))

    if [[ "$1" == "up" ]]; then
        install "$1" "$repo_dir"
    elif [[ "$1" == "down" ]]; then
        install "$1"
    else
        echo "Please run with up or down as first parameter"
        exit 1
    fi
}

function install() {
    install_zsh $*
}

function install_zsh() {
    local up=$1
    local repo_dir=$2

    if [[ "$up" == "up" ]]; then
        ln -s $repo_dir/mac_mini/zsh/zshrc ~/.zshrc
        ln -s $repo_dir/mac_mini/zsh/aliases ~/.aliases
    else
        rm -f ~/.zshrc
        rm -f ~/.aliases
    fi
}

main $*
