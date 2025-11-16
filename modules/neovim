#!/usr/bin/env bash

run_module_installation() {
  echo "Downloading latest Neovim AppImage via curl"
  curl -sLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  chmod u+x nvim-linux-x86_64.appimage
  sudo mv -v nvim-linux-x86_64.appimage /usr/local/bin/nvim
  echo "Neovim updated successfully"
}
