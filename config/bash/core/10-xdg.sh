#!/bin/sh
# shellcheck shell=sh
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Set up xdg based dirs spec (POSIX)
#
# https://specifications.freedesktop.org/basedir/latest/


# user-specific data files should be written
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# user-specific configuration files
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# user-specific state data
# contains state data that should persists between (application) restarts,
# but that is not important or portable enough to the user that it should be
# stored in $XDG_DATA_HOME
#
#  - action history (logs, history, recently used files, ...)
#  - current state of the application that can be reused on restart (view, layout, open files, undo history, ...)
#
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# user-specific executable files
# De facto standard, not part of the formal spec, but universal convention ---
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"

# set of preference ordered base dirs relative to which data files should be
# searched.
# export XDG_DATA_DIRS="/usr/local/share/:/usr/share/"

# set of preference ordered base dirs relative to which configuration files
# should be searched
# export XDG_CONFIG_DIRS="/etc/xdg"

# user-specifc non-essential (cached) data should be written
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# user-specific runtime files and other file objects should be placed
# export XDG_RUNTIME_DIR=

# --- for user-specific directories ---
# see config/user-dirs.dirs

# XDG_DESKTOP_DIR="$HOME/Desktop"
# XDG_DOWNLOAD_DIR="$HOME/Downloads"
# XDG_TEMPLATES_DIR="$HOME/Templates"
# XDG_PUBLICSHARE_DIR="$HOME/Public"
# XDG_DOCUMENTS_DIR="$HOME/Documents"
# XDG_MUSIC_DIR="$HOME/Music"
# XDG_PICTURES_DIR="$HOME/Pictures"
# XDG_VIDEOS_DIR="$HOME/Videos"

# --- Runtime directory (session-scoped, tmpfs-backed) ---
# Usually already set by the system (systemd/pam_systemd); only fall back
# if genuinely unset, and warn since a missing XDG_RUNTIME_DIR can indicate
# a non-standard login path.
if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
  export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"
  mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null
  chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null
fi


# --- Ensure the user-level directories actually exist ---
for dir in "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$XDG_BIN_HOME"; do
  [ -d "$dir" ] || mkdir -p "$dir"
done
