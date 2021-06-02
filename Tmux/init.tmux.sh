#!/usr/bin/env bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Init file for tmux

#source util.bash

# Tmux::get_opts() Get option value at runtime {{{1
# Args: [source file] [tmux option]
# Outputs: option value
# Returns: 0 if the option has value, 1 otherwise
function Util::get_opts() {
  # shellcheck disable=SC2002
  cat "${1}" | grep "${2}" | awk '{print $4}'
}

# get user option's @theme value
# return: [@theme name]
function Util::get_theme() {
  localrc_path="${TMUX_LOCALRC}/local.tmuxrc"
  opts_path="${TMUX_COMPONENT_DIR}/options.tmux"

  if [[ $(Util::get_opts "${TMUX_LOCALRC}/local.tmuxrc" "@theme") ]]; then
    THEME="$(Util::get_opts "${localrc_path}" "@theme")"
  else
    # default theme
    THEME="$(Util::get_opts "${opts_path}" "@theme")"
  fi

  printf "%s" "${THEME}"
}

function Util::source_files() {
  local FILES
  for FILES in $1; do
    tmux source-file "${FILES}"
  done
  unset FILES
}

function theme() {
  tmux source-file "${TMUX_THEME_DIR}/$(Util::get_theme).tmux"
}

function plug() {
  Util::source_files "${TMUX_PLUG_DIR}/*"
}

function component() {
  Util::source_files "${TMUX_COMPONENT_DIR}/*"
}

function Tmux::main() {
  Util::source_files "${TMUX_DIR}/*.tmux"
  theme
}

Tmux::main
