#!/bin/sh

#Arch
# Terminal setup
# Shell setup
# WM setup
# Tmux
# Configs

sudo pacman -S stow awesome alacritty zsh tmux fzf make neovim 

#Dmenu install
mkdir $HOME/git && cd $HOME/git
git clone https://git.suckless.org/dmenu && cd dmenu
make && make install

#AUR manual install
# https://aur.archlinux.org/packages/nerd-fonts-fira-code
