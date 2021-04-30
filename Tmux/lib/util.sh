#!/usr/bin/env bash
#
# ---------------------------------------------------------------------------
# File:        util.conf
# Description: helper functions for tmux config
# ---------------------------------------------------------------------------

# get option value at runtime.
# param: [source] [option]
# return: option value
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
