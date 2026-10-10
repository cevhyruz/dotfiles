# lib/theme.bash - theme loading and application
# Everything (prompt, git, tig, ls, less, man) only ever emits ANSI slots
# 0-15. A theme re-defines what those 16 slots (and default fg/bg) look like,
# so all of them change together.
#
# A theme file (themes/<name>.bash) defines:
#   THEME_DARK_PALETTE / THEME_LIGHT_PALETTE   16 hex colors, RRGGBB, slots 0-15
#   THEME_{DARK,LIGHT}_{BG,FG,CURSOR}          hex colors
#   THEME_ROLE                                 role -> ANSI slot (0-15)
#
# Requires core/term.bash. Bash >= 4.3.
#
# Usage:  __theme::init [name]
# Env:    THEME_NAME=default   THEME_VARIANT=dark|light|auto
#         THEME_RESET_ON_EXIT=1 to restore the terminal's own colors on exit

: "${THEME_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/bash/themes}"

declare -ga THEME_PALETTE=()
declare -gA THEME_ROLE=() THEME_SGR=() THEME_PS1=() THEME_RL=()
THEME_BG=
THEME_FG=
THEME_CURSOR=
THEME_APPLIED=0

# Sets REPLY to "dark" or "light".
# "auto" asks GNOME (one subprocess, ~10-20ms) - leave THEME_VARIANT at
# dark/light if startup time matters.
__theme::variant() {
  case ${THEME_VARIANT:-dark} in
    light)
      REPLY=light ;;
    auto)
      REPLY=dark
      if command -v gsettings >/dev/null 2>&1; then
        local scheme
        scheme=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
        [[ -n $scheme && $scheme != *dark* ]] && REPLY=light
      fi
      ;;
    *)
      REPLY=dark ;;
  esac
}

__theme::load() {
  local name=${1:-${THEME_NAME:-default}} v role i code
  if [[ ! -r $THEME_DIR/$name.bash ]]; then
    printf 'theme: %s.bash not found in %s\n' "$name" "$THEME_DIR" >&2
    return 1
  fi
  source "$THEME_DIR/$name.bash" || return

  __theme::variant
  v=${REPLY^^}

  local pal=THEME_${v}_PALETTE[@] bg=THEME_${v}_BG fg=THEME_${v}_FG cur=THEME_${v}_CURSOR
  THEME_PALETTE=("${!pal}")
  THEME_BG=${!bg}
  THEME_FG=${!fg}
  THEME_CURSOR=${!cur:-$THEME_FG}

  if (( ${#THEME_PALETTE[@]} != 16 )) || [[ -z $THEME_BG || -z $THEME_FG ]]; then
    printf 'theme: %s (%s) needs a 16-color palette plus BG and FG\n' "$name" "${REPLY}" >&2
    return 1
  fi

  # Precompute SGR strings per role, once, so prompts don't fork or loop.
  #   THEME_SGR  raw escape, for printf / echo -e
  #   THEME_PS1  \[ \] wrapped, for text placed literally in PS1
  #   THEME_RL   \001 \002 wrapped, for values that PS1 expands from a
  #              variable (bash does not decode \[ \] inside those)
  THEME_SGR=()
  THEME_PS1=()
  THEME_RL=()
  for role in "${!THEME_ROLE[@]}"; do
    i=${THEME_ROLE[$role]}
    (( code = i < 8 ? 30 + i : 90 + i - 8 ))
    THEME_SGR[$role]=$'\e['$code'm'
    THEME_PS1[$role]='\[\e['$code'm\]'
    THEME_RL[$role]=$'\001\e['$code$'m\002'
  done
  THEME_SGR[reset]=$'\e[0m'
  THEME_PS1[reset]='\[\e[0m\]'
  THEME_RL[reset]=$'\001\e[0m\002'

  # No color support: make every style empty so prompts print plain text.
  if (( TERM_COLORS < 8 )); then
    for role in "${!THEME_SGR[@]}"; do
      THEME_SGR[$role]=
      THEME_PS1[$role]=
      THEME_RL[$role]=
    done
  fi
}

# Sets REPLY to a truecolor SGR for a RRGGBB hex. $1 = 38 (fg) or 48 (bg).
# Preview-only: the rest of the theme stays on ANSI slots, but a cursor color
# is not one of the 16 slots, so a swatch of it has to be truecolor.
__theme::hex_sgr() { # {{{1
  local hex=$2
  printf -v REPLY '\e[%d;2;%d;%d;%dm' "$1" \
    "$(( 16#${hex:0:2} ))" "$(( 16#${hex:2:2} ))" "$(( 16#${hex:4:2} ))"
}

# Show bg/fg/cursor hex values and a mock prompt line with the cursor drawn
# at the end of the input and over a character.
__theme::preview_cursor() { # {{{1
  local rst=$'\e[0m' bg fg cur under

  printf 'bg %s   fg %s   cursor %s\n' "$THEME_BG" "$THEME_FG" "$THEME_CURSOR"
  (( TERM_IS_CONSOLE )) && return 0   # the console has no truecolor


  __theme::hex_sgr 48 "$THEME_BG";     bg=$REPLY
  __theme::hex_sgr 38 "$THEME_FG";     fg=$REPLY
  __theme::hex_sgr 48 "$THEME_CURSOR"; cur=$REPLY
  __theme::hex_sgr 38 "$THEME_BG";     under=$REPLY   # text color under a block cursor

  printf '%s%s  $ ls -la %s %s%s          %s\n' \
    "$bg" "$fg" "$cur" "$bg" "$fg" "$rst"
  printf '%s%s  $ ls %s%s-%s%sla            %s\n' \
    "$bg" "$fg" "$cur" "$under" "$bg" "$fg" "$rst"
}

# Preview the active theme: the 16 ANSI slots as swatches (with hex), the
# default bg/fg/cursor, and each role grouped by the slot it maps to.
__theme::preview() { # {{{1
  (( TERM_COLORS >= 8 )) || {
    printf 'theme: terminal has no color support\n' >&2
    return 1
  }

  local i start bg role rst=$'\e[0m' variant
  __theme::variant; variant=$REPLY

  printf 'theme: %s   variant: %s\n\n' "${THEME_NAME:-default}" "$variant"

  # Slots 0-7, then 8-15: swatch row, slot-number row, hex row.
  for start in 0 8; do
    for (( i = start; i < start + 8; i++ )); do
      (( bg = i < 8 ? 40 + i : 100 + i - 8 ))
      printf '\e[%dm        %s' "$bg" "$rst"
    done
    printf '\n'
    for (( i = start; i < start + 8; i++ )); do
      printf '%-8s' "$i"
    done
    printf '\n'
    for (( i = start; i < start + 8; i++ )); do
      printf '%-8s' "${THEME_PALETTE[i]:-?}"
    done
    printf '\n\n'
  done

  # printf 'bg %s   fg %s   cursor %s\n\n' "$THEME_BG" "$THEME_FG" "$THEME_CURSOR"
__theme::preview_cursor; printf '\n'

  # Roles, ordered by the slot they map to.
  printf 'roles:\n'
  for (( i = 0; i < 16; i++ )); do
    (( bg = i < 8 ? 40 + i : 100 + i - 8 ))
    for role in "${!THEME_ROLE[@]}"; do
      [[ ${THEME_ROLE[$role]} == "$i" ]] || continue
      printf '  \e[%dm   %s %s%-8s%s slot %d\n' \
        "$bg" "$rst" "${THEME_SGR[$role]}" "$role" "$rst" "$i"
    done
  done
}

# Redefine the terminal's palette. One printf, no subprocesses.
__theme::apply() {
  (( TERM_COLORS >= 16 )) || return 0
  [[ -t 1 ]] || return 0
  # Over SSH the sequences would recolor the *local* terminal; tmux needs
  # passthrough wrapping. Skip both.
  [[ -z ${SSH_CONNECTION:-} && -z ${TMUX:-} ]] || return 0

  local out= seq hex i
  for i in "${!THEME_PALETTE[@]}"; do
    hex=${THEME_PALETTE[i]}
    if (( TERM_IS_CONSOLE )); then
      # The console has no default fg/bg sequence: they are slots 0 and 7.
      (( i == 0 )) && hex=$THEME_BG
      (( i == 7 )) && hex=$THEME_FG
      printf -v seq '\e]P%X%s' "$i" "$hex"
    else
      printf -v seq '\e]4;%d;#%s\a' "$i" "$hex"
    fi
    out+=$seq
  done
  if (( ! TERM_IS_CONSOLE )); then
    printf -v seq '\e]10;#%s\a\e]11;#%s\a\e]12;#%s\a' "$THEME_FG" "$THEME_BG" "$THEME_CURSOR"
    out+=$seq
  fi
  printf '%s' "$out"
  THEME_APPLIED=1
}

# Give the terminal its own colors back.
__theme::reset() {
  (( THEME_APPLIED )) || return 0
  if (( TERM_IS_CONSOLE )); then
    printf '\e]R'
  else
    printf '\e]104\a\e]110\a\e]111\a\e]112\a'
  fi
  THEME_APPLIED=0
}

# we have the terminal title being set as the base prompt
#
__theme::get_current_prompt() {
:;
}

# Prepend __theme::prompt to PROMPT_COMMAND (string or array), once.
__theme::prompt_hook() {
  [[ -n ${THEME_PROMPT_HOOKED:-} ]] && return 0

  THEME_PROMPT_HOOKED=1
  if [[ ${PROMPT_COMMAND@a} == *a* ]]; then
    PROMPT_COMMAND=(__theme::prompt_handle "${PROMPT_COMMAND[@]}")
  else
    PROMPT_COMMAND="__theme::prompt_handle${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi
}


__theme::init() {
  __theme::load "$@" || return
  __theme::apply

  # initialize theme handlers
  __theme::export_env_handle

  if [[ ${THEME_RESET_ON_EXIT:-0} == 1 ]]; then
    trap '__theme::reset' EXIT
  fi

  return 0
}


# Reserved functions used in theme writing

# environment that is needed to be setup to support colors
# for example man/less colors, expressed as ANSI slots so they follow the theme.
# runs after the __theme::apply
__theme::export_env_handle() { :; }

# Runs before every prompt. Must be first in PROMPT_COMMAND so $? is still the
# exit status of the command you just ran; it hands $? on unchanged.
# this is where theme author chooses/setup prompt segments from the library.
__theme::prompt_handle() { :; }

# Theme handle for showing theme-specific information
# TODO: not yet implemented
__theme::info_handle() { :; }

# theme handle for the theme-specific main
__theme::main_handle() { :; }
