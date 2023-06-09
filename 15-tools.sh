#!/usr/bin/env bash

# Rustup
# https://rustup.rs/
if [[ ! $(command -v rustup) ]]
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  # rustup default stable
  # rustup self upgrade-data
fi

cargo install stylua
cargo install fnm
cargo install paru

# SDKMAN!
# https://sdkman.io/install
if [[ ! $(command -v sdk) ]]
then
  curl -s "https://get.sdkman.io?rcupdate=false" | bash
fi

source "${HOME}/.local/lib/sdkman/bin/sdkman-init.sh" # SDKMAN!

echo 'Installing java'
sdk install java

echo 'Installing maven'
sdk install maven
