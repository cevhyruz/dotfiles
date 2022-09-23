#!/usr/bin/env bash
# shellcheck disable=SC2155
#
# VScode plugin installer.

declare -a installed=()
declare -a failed=()

declare -a extensions=(
  # syntax highlighting
  'malmaud.tmux'
  'duniul.dircolors'
  'evgeniypeshkov.syntax-highlighter'

  # utilities
  'vscodevim.vim'
  'Shan.code-settings-sync'
  'ryuta46.multi-command'

  # visual aesthetics
  'emmanuelbeziat.vscode-great-icons'
  'PKief.material-icon-theme'

  # linters
  'timonwong.shellcheck'
  'sumneko.lua'
)

function install_plugin() {
  echo -e "Installing..\n"
  for extension in "${extensions[@]}"; do
    if command code --install-extension "${extension}" &> /dev/null; then
       printf  "%b\n" " \e[38;5;35m[\u2713]\e[0m ${extension}"
       installed+=("${extension}")
     else
       printf  "%b\n" " \e[38;5;203m[\u2715]\e[0m ${extension}"
       failed+=("${extension}")
    fi
  done
  echo -e "\n${#installed[@]} plugin installed, ${#failed[@]} failed."
  echo -e "\nTo update all plugins, run: ${BASH_SOURCE[0]} --force"
  if [[ "${#failed}" -gt 0 ]]; then
    return 1
  fi
}

install_plugin "$@"
