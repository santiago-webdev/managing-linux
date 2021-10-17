#!/usr/bin/env bash

cd $HOME

git clone git@github.com:santigo-zero/Neovim.git .config/nvim

pip install pynvim
sudo npm i -g neovim

# Language Servers
sudo npm i -g pyright						# Python
sudo pacman -S bash-language-server			# Bash
sudo pacman -S lua-language-server			# Lua

git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

rm $0 # Self delete
