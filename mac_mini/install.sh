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
    install_fish $*
    install_zsh $*
    install_gitconfig_include $*
    install_default_key_binding $*
}

function install_fish() {
    local up=$1
    local repo_dir=$2

    if [[ "$up" == "up" ]]; then
        mkdir -p ~/.config/fish
        ln -s $repo_dir/mac_mini/fish/conf.d ~/.config/fish/
        ln -s $repo_dir/mac_mini/fish/functions ~/.config/fish/
    else
        rm -rf ~/.config/fish/conf.d
        rm -rf ~/.config/fish/functions
    fi
}

function install_zsh() {
    local up=$1
    local repo_dir=$2

    if [[ "$up" == "up" ]]; then
        ln -s $repo_dir/mac_mini/zsh/zshrc ~/.zshrc
    else
        rm -f ~/.zshrc
    fi
}

function install_gitconfig_include() {
    local up=$1
    local repo_dir=$2

    if [[ "$up" == "up" ]]; then
        ln -s $repo_dir/gitconfig_include ~/.gitconfig_include
    else
        rm -f ~/.gitconfig_include
    fi
}

function install_default_key_binding() {
    local up=$1
    local repo_dir=$2

    if [[ "$up" == "up" ]]; then
        mkdir -p ~/Library/KeyBindings
        ln -s $repo_dir/DefaultKeyBinding.dict ~/Library/KeyBindings/
    else
        rm -f ~/Library/KeyBindings/DefaultKeyBinding.dict
    fi
}

main $*
