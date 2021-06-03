#!/usr/bin/env bash
#
# Dotfiles installer.

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

DOT_BASH="${DOTFILES}/Bash"
BASH_CONFIG_FILE=".bashrc"

function _bash_make_template() {
  sed \
    "s|{{DOTFILES}}|${DOTFILES}|" \
    "${DOT_BASH}/template/bash_profile.template.bash" >"${HOME}/${BASH_CONFIG_FILE}"
}

function main() {
  _bash_make_template
}

main
