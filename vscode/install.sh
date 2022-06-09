#!/usr/bin/env bash
#
# VScode plugin installer.

declare -a extensions=(
  'vscodevim.vim'
  'malmaud.tmux'
)

for extension in "${extensions[@]}"; do
  command code --install-extension "${extension}"
done
