#!/bin/bash

function install() {
    DIR=$(readlink -e $(dirname $0))
    ln -s ${DIR}/aliases ~/.aliases
    ln -s ${DIR}/bashrc ~/.bashrc
    ln -s $(realpath ${DIR}/../vimrc) ~/.vimrc

    # add the gitconfig_include if it is not there
    git config -l | grep include
    if [[ $? -ne 0 ]]; then
        git config --global include.path $(realpath ${DIR}/../gitconfig_include)
    else
        echo "git config already has includes, skipping"
    fi

    ln -s ${DIR}/vscode/keybindings.json ~/.config/Code/User/
    ln -s ${DIR}/vscode/settings.json ~/.config/Code/User/
}

function uninstall() {
    rm -f ~/.aliases
    rm -f ~/.bashrc
    rm -f ~/.vimrc
    git config --global --unset include.path
    rm -f ~/.config/Code/User/keybindings.json
    rm -f ~/.config/Code/User/settings.json
}

if [[ "$1" == "up" ]]; then
    install
elif [[ "$1" == "down" ]]; then
    uninstall
else
    echo "Please run with up or down as first parameter"
    exit 1
fi
