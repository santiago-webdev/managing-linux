#!/usr/bin/env bash

cd "$HOME" || exit

git clone git@github.com:santigo-zero/Neovim.git .config/nvim

pip install pynvim
sudo npm i -g neovim

# # Language Servers
# sudo pacman -S pyright
# sudo pacman -S bash-language-server
# sudo pacman -S lua-language-server
# sudo pacman -S deno
# sudo pacman -S vscode-css-languageserver
# sudo pacman -S vscode-html-languageserver

git clone https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
