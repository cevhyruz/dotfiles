#!/usr/bin/env bash
#
# VScode plugin installer.

declare -a extensions=(
  'vscodevim.vim'
  'malmaud.tmux'
  'shan.code-settings-sync'
  'ryuta46.multi-command'
  'emmanuelbeziat.vscode-great-icons'
  'pkief.material-icon-theme'
)

function install() {
  for extension in "${extensions[@]}"; do
    command code --install-extension "$@" "${extension}"
  done
}

install "$@"
