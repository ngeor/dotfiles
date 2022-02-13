#!/bin/bash

function install() {
    DIR=$(readlink -e $(dirname $0))
    ln -s ${DIR}/gitconfig_include ~/.gitconfig_include
    ln -s ${DIR}/bash_aliases ~/.bash_aliases
}

function uninstall() {
    rm -f ~/.gitconfig_include ~/.bash_aliases
}

if [[ "$1" == "up" ]]; then
    install
elif [[ "$1" == "down" ]]; then
    uninstall
else
    echo "Please run with up or down as first parameter"
    exit 1
fi
