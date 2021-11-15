#!/usr/bin/env bash

cd "$HOME" || exit

git clone git@github.com:santigo-zero/Neovim.git .config/nvim

pip install pynvim
sudo npm i -g neovim

# Language Servers
sudo pacman -S pyright						# Python
sudo pacman -S bash-language-server			# Bash
sudo pacman -S lua-language-server			# Lua
sudo pacman -S deno							# Typescript and Javascript
sudo pacman -S vscode-css-languageserver	# CSS
sudo pacman -S vscode-html-languageserver	# HTML

git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

rm "$0" # Self delete
