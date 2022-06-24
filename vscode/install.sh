#!/usr/bin/env bash
#
# VScode plugin installer.

declare -a extensions=(
  'vscodevim.vim'
  'malmaud.tmux'
  'shan.code-settings-sync'
)

for extension in "${extensions[@]}"; do
  command code --install-extension "${extension}"
done
