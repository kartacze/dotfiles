#!/bin/bash
#
# Has to be run from dotfiles folder

mkdir ~/.config/i3/
cp ./.config/i3/config ~/.config/i3/config


# tmux 
# clone TPM - Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp ./.tmux.conf ~/.tmux.conf
