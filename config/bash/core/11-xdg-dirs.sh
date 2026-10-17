# shellcheck shell=sh
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# XDG directory setup (logic only, bash-sourced).
#
# Sourced after config/bash/core/10-xdg.sh, which defines the XDG_* variables
# used here. NOT symlinked into environment.d: this file contains logic
# (if/for/mkdir/export) that systemd can't parse.

# Runtime directory (session-scoped, tmpfs-backed)
# Usually already set by the system (systemd/pam_systemd); only fall back
# if genuinely unset, and warn since a missing XDG_RUNTIME_DIR can indicate
# a non-standard login path.
if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
  export XDG_RUNTIME_DIR="/tmp/${USER}-runtime"
  mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null
  chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null
fi

# Ensure the user-level directories actually exist
for dir in "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$XDG_BIN_HOME"; do
  [ -d "$dir" ] || mkdir -p "$dir"
done

