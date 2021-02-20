#!/usr/bin/env bash

[[ -f "${1}" ]] && source "${1}"

function Tmux::main() {
  theme
  plug
  component
}

function theme() {
  tmux source-file "${TMUX_THEME_DIR}/$(Util::get_theme).tmux"
}

function plug() {
  Util::source_files "${TMUX_PLUG_DIR}/*";
}

function component() {
  Util::source_files "${TMUX_COMPONENT_DIR}/*";
}


Tmux::main "${@}";
