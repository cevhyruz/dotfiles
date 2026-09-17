#!/bin/sh
# shellcheck shell=sh
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
#
# core/path.bash — bootstrap PATH construction; depends on lib/utils.bash's add_to_path()


# set PATH so it includes user's private bin if it exists
bin_home="${XDG_BIN_HOME:-$HOME/.local/bin}"
if [ -d "${bin_home}" ] ; then
   export PATH="$bin_home:$PATH"
fi
unset bin_home
