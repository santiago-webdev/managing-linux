#!/usr/bin/env bash

NUSHELL_PATH=$(which nu)

echo "$NUSHELL_PATH" | sudo tee -a /etc/shells

sudo usermod -s $(which nu) $USER
