# lib/separator.bash - rule lines before and after command output.
# Needs core/hooks.bash. Width follows the terminal via $COLUMNS.

shopt -s checkwinsize   # keep COLUMNS current after resizes

# Rebuild the cached line only when the width changes (no forks).
__sep::build() {
  local w=${COLUMNS:-80} ch='─'
  (( TERM_IS_CONSOLE )) && ch='-'
  [[ $w == "${__sep_w-}" ]] && return 0
  __sep_w=$w
  printf -v __sep_line '%*s' "$w" ''
  __sep_line=${__sep_line// /$ch}
}

# Dim the muted color further. SEP_DIM=0 turns it off.
SEP_DIM=${SEP_DIM-1}

__sep::print() {
  __sep::build
  local style=${THEME_SGR[muted]-}
  (( SEP_DIM )) && style=$'\e[2m'$style
  printf '%s%s%s\n' "$style" "$__sep_line" "${THEME_SGR[reset]-}"
}

# True when HOOK_CMD is something the user typed, not shell plumbing,
# and not a command that wipes the screen.
__sep::is_user_cmd() {
  case ${HOOK_CMD-} in
    '' | __* | _exec_* | ::* | PROMPT_COMMAND* | *'$?'* ) return 1 ;;
    clear | clear\ * | reset | reset\ * | 'tput clear'* | 'tput reset'* ) return 1 ;;
  esac
  return 0
}

__sep::before() {
  __sep::is_user_cmd || return 0
  SEP_CMD_RAN=1
  # __sep::print
}

# __sep::after is unchanged: it only prints if SEP_CMD_RAN was set.

# After the output, only if a command ran (the DEBUG trap never fires on an empty Enter).
__sep::after() {
  [[ -n ${SEP_CMD_RAN-} ]] || return 0
  unset SEP_CMD_RAN
  printf '\n'
  __sep::print
}

::pre_command  __sep::before
::post_command __sep::after
