#!/usr/bin/env bash
#
# Dotfiles installer.

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
DOT_BASH="${DOTFILES}/Bash"

function main() {
  __make_bash_template
  __make_git_template
}

# search and replace, then save a file copy.
function __expand() {
  local -r search="$1"
  local -r replace="$2"
  local -r location="$3"
  local -r destination="$4"

  sed "s|{{${search}}}|${replace}|" \
    "${location}" > "${destination}"
}

function __make_bash_template() {
  __expand \
    "DOTFILES" "${DOTFILES}" \
    "${DOT_BASH}/.bashrc.template" \
    "${HOME}/.bashrc"
}

function __make_git_template() {
  __expand \
    "DOTFILES" "${DOTFILES}" \
    "${DOTFILES}/Git/.gitconfig.template" \
    "${HOME}/.gitconfig"
}

main
