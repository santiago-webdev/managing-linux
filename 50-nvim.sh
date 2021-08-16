#!/usr/bin/env bash

cd $HOME

git clone git@github.com:santigo-zero/Neovim.git .config/nvim

pip install pynvim
sudo npm i -g neovim

rm $0 # Self delete
