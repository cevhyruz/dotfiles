#!/bin/sh
# shellcheck shell=sh
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
#
# core/path.bash — bootstrap PATH construction; depends on lib/utils.bash's add_to_path()


core_paths=(
 "${HOME}/.local/experimental/bin"     # experimental scripts
 "${XDG_BIN_HOME:-${HOME}/.local/bin}" # my private bin
)

__path_prepend "${core_paths[@]}"
export PATH

unset core_paths
