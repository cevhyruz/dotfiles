# shellcheck shell=sh disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# Bash-related variables that must also be visible to systemd.
#
# Sourced after config/bash/core/10-xdg.sh, which defines the XDG_* variables
# used here.
#
# Real file: config/bash/core/20-bash.sh
# Symlinked to ~/.config/environment.d/20-bash.conf, so this file is read
# by both bash (sourced with `set -a`) and systemd (environment.d).
#
# Because systemd parses it too, only these are allowed:
#   - KEY=value lines (quotes and ${VAR:-default} are fine)
#   - full-line # comments
# No export, source, command substitution, or other shell logic.


INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
HISTFILE="${XDG_STATE_HOME}/bash/history"
