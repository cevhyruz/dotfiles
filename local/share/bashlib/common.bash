# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# common.bash - Library for commonly used commands.


# check if a given command is exists
# Args [command]
# Returns:
#  0 if command exists on path, 1 otherwise
__common::command_exists() {
  command -v "${1-}" &>/dev/null 2>&1
}
__common::is_root() {
  (( EUID == 0 ))
}
 # is_tty 0 / 1 / 2 for stdin/out/err
__common::is_tty() {
  [[ -t "${1:-1}" ]]
}

# determines if the terminal supports 256 colors
# __TERM_COLORS_COUNT="$(tput colors 2>/dev/null || echo 0)"
# terminal colors state
__TERM_COLORS_SUPPORT=false

# Returns 0 if the terminal (per $TERM) supports 256+ colors
# __TERM_COLORS_COUNT is computed once at startup (see: core/envars.bash)
__util::supports_color() {
  if [[ "${COLORTERM-}" =~ ^(truecolor|24bit)$ ]]; then
    __TERM_COLOR_SUPPORT=true
    return 0
  fi
  # (( __TERM_COLORS_COUNT >= 256 ))
}
