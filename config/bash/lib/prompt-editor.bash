# lib/prompt-editor.bash - TUI to enable, reorder and recolor prompt segments
#
# Requires: tui.sh, core/hooks.bash, lib/theme.bash (with __theme::roles_handle and
#           __theme::compile_roles), lib/prompt.bash, and a theme whose main_handle
#           builds PS1 from THEME_SEGMENTS (see themes/default.bash). Bash >= 4.4.
#
# It does not draw its own prompt. The preview runs YOUR __theme::prompt_handle and
# __theme::main_handle inside a subshell and expands the resulting PS1, so what you see
# is the real prompt with real git/python/node data, and nothing leaks into your shell
# until you save.
#
#   prompt_edit       open the editor (segments pane / colors pane, Tab switches)
#
# What is edited, and how it is stored (${XDG_CONFIG_HOME:-~/.config}/bash/prompt.conf):
#   segment order      THEME_SEGMENTS=(...)           read by main_handle
#   segment on/off     THEME_GIT=0, THEME_PYTHON=0... the toggles prompt.bash already has
#   segment option     one env knob per segment (THEME_GIT_UNTRACKED, ...), see _PE_KNOB
#   role colors        _PE_ROLE_OVR=([git]=3 ...)     role -> ANSI slot 0-15, applied by
#                                                     __theme::roles_handle after the theme loads
#
# bashrc order:
#   source lib/theme.bash; source lib/prompt.bash; source lib/prompt-editor.bash
#   __pe::load_conf
#   __theme::init
#
# The cwd segment lives in the header line of main_handle, so it is not listed here.

[[ -n ${_PE_LOADED:-} ]] && return 0
_PE_LOADED=1

: "${_PE_CONF:=${XDG_CONFIG_HOME:-$HOME/.config}/bash/prompt.conf}"
_PE_DEFAULT_SEGMENTS=(SHLVL PY NODE GIT TIME EXIT ERRLOG)

declare -gA _PE_ROLE_OVR           # no "=()": keeps overrides if the conf was sourced first
declare -gA _PE_ROLE_BASE=() _PE_SAMPLE=()
# segment key -> toggle variable (default THEME_<KEY>)
declare -gA _PE_TOG=([PY]=THEME_PYTHON)
# segment key -> its one editable env option, and a regex a value must match
declare -gA _PE_KNOB=([GIT]=THEME_GIT_UNTRACKED [SHLVL]=THEME_SHLVL_BASE [ERRLOG]=THEME_ERRLOG_FILE)
declare -gA _PE_KNOB_RE=(
  [THEME_GIT_UNTRACKED]='^(normal|no|all)$'
  [THEME_SHLVL_BASE]='^[0-9]+$'
  [THEME_ERRLOG_FILE]='^/[^[:cntrl:]]*$'
)

_PE_KEYS=() _PE_ROLES=() _PE_PV=()
_PE_PANE=0 _PE_SEL=(0 0) _PE_TOP=(0 0) _PE_N=0 _PE_LROWS=3
_PE_RC=0 _PE_DIRTY=0 _PE_SAVED=0 _PE_QUIT=0 _PE_HELP=0 _PE_MSG= _PE_CUR=

# ---------------------------------------------------------------------------
# Startup: apply saved config (call before __theme::init)
# ---------------------------------------------------------------------------

# Reserved theme hook (see lib/theme.bash): runs right after the theme file is sourced,
# before role colors are compiled. THEME_ROLE is pristine here, so remember it as the
# base, then apply the saved overrides.
__theme::roles_handle() {
  local r
  _PE_ROLE_BASE=()
  for r in "${!THEME_ROLE[@]}"; do _PE_ROLE_BASE[$r]=${THEME_ROLE[$r]}; done
  for r in "${!_PE_ROLE_OVR[@]}"; do
    [[ -n ${THEME_ROLE[$r]+x} ]] && THEME_ROLE[$r]=${_PE_ROLE_OVR[$r]}
  done
  return 0
}

__pe::load_conf() { [[ -r $_PE_CONF ]] && source "$_PE_CONF"; return 0; }

# ---------------------------------------------------------------------------
# Model
# ---------------------------------------------------------------------------

__pe::on() {   # KEY: is the segment enabled?
  local var=${_PE_TOG[$1]:-THEME_$1}
  [[ ${!var:-1} == 1 ]]
}

# Segment loader: THEME_SEGMENTS order first, then any THEME_<X>_SEG variable that
# prompt.bash defines but the order list does not mention (added disabled).
__pe::discover() {
  local k v var
  local -A seen=()
  local -a vars
  _PE_KEYS=()
  [[ -n ${THEME_SEGMENTS[@]+x} ]] || THEME_SEGMENTS=("${_PE_DEFAULT_SEGMENTS[@]}")
  for k in "${THEME_SEGMENTS[@]}"; do
    [[ -n ${seen[$k]+x} ]] || { seen[$k]=1; _PE_KEYS+=("$k"); }
  done
  mapfile -t vars < <(compgen -A variable THEME_)
  for v in "${vars[@]}"; do
    [[ $v == THEME_*_SEG ]] || continue
    k=${v#THEME_}; k=${k%_SEG}
    [[ $k == CWD || -n ${seen[$k]+x} ]] && continue
    seen[$k]=1; _PE_KEYS+=("$k")
    var=${_PE_TOG[$k]:-THEME_$k}; printf -v "$var" 0
  done
  mapfile -t _PE_ROLES < <(
    for k in "${!THEME_ROLE[@]}"; do printf '%02d %s\n' "$((10#${THEME_ROLE[$k]}))" "$k"; done | sort | cut -d' ' -f2
  )
}

# Sets REPLY to $1 without readline markers and SGR escapes.
__pe::plain() {
  local s=${1//[$'\001\002']/} pre rest
  while [[ $s == *$'\e['* ]]; do
    pre=${s%%$'\e['*}; rest=${s#*$'\e['}; s=$pre${rest#*m}
  done
  REPLY=$s
}

# Sets REPLY to $1 reduced to printable text and SGR (color) sequences. Drops OSC strings
# (BEL or ST terminated), other CSI sequences, CR and readline markers, so nothing in the
# prompt can move the cursor, clear the row or swallow text inside the preview.
__pe::clean() {
  local s=${1//[$'\001\002\r']/} out= rest params final a b
  while [[ $s == *$'\e'* ]]; do
    out+=${s%%$'\e'*}; s=${s#*$'\e'}
    case $s in
      '['*)
        rest=${s#\[}; params=${rest%%[!0-9;:?]*}
        final=${rest:${#params}:1}; s=${rest:${#params}+1}
        [[ $final == m ]] && out+=$'\e['$params'm'
        ;;
      ']'*)
        rest=${s#\]}; a=${rest%%$'\a'*}; b=${rest%%$'\e\\'*}
        if (( ${#a} <= ${#b} )); then
          if [[ $a != "$rest" ]]; then s=${rest:${#a}+1}; else s=$rest; fi
        else
          s=${rest:${#b}+2}
        fi
        ;;
      *) s=${s:1} ;;
    esac
  done
  REPLY=$out$s
}

# Re-run the real prompt pipeline and cache the result for drawing.
__pe::rebuild() {
  local p k v
  local TERM_TITLE_PS1= TMUX=          # main_handle reads these: no window title / OSC 133 in the preview
  __theme::compile_roles
  CMD_DURATION=2.3s                                   # so the time segment has something to show
  { (exit "$_PE_RC"); __theme::prompt_handle; } >/dev/null 2>&1
  THEME_SEGMENTS=("${_PE_KEYS[@]}")
  __theme::main_handle >/dev/null 2>&1
  { p=${PS1@P}; } 2>/dev/null
  __pe::clean "$p"
  mapfile -t _PE_PV <<<"$REPLY"
  for k in "${_PE_KEYS[@]}"; do
    v=THEME_${k}_SEG
    __pe::plain "${!v-}"
    _PE_SAMPLE[$k]=${REPLY# }
  done
}

__pe::save() {
  local k var role
  mkdir -p "${_PE_CONF%/*}" || { _PE_MSG="cannot create ${_PE_CONF%/*}"; return 1; }
  {
    printf '# generated by prompt_edit - overwritten on save\n'
    printf 'declare -ga THEME_SEGMENTS=(%s)\n' "${_PE_KEYS[*]}"
    for k in "${_PE_KEYS[@]}"; do
      var=${_PE_TOG[$k]:-THEME_$k}
      __pe::on "$k" && printf '%s=1\n' "$var" || printf '%s=0\n' "$var"
    done
    for var in "${_PE_KNOB[@]}"; do
      [[ -n ${!var:-} ]] && printf '%s=%q\n' "$var" "${!var}"
    done
    printf 'declare -gA _PE_ROLE_OVR=('
    for role in "${!_PE_ROLE_OVR[@]}"; do printf '[%s]=%s ' "$role" "${_PE_ROLE_OVR[$role]}"; done
    printf ')\n'
  } > "$_PE_CONF" || { _PE_MSG="save failed"; return 1; }
  _PE_DIRTY=0 _PE_SAVED=1
  _PE_MSG="saved to $_PE_CONF"
}

# ---------------------------------------------------------------------------
# Actions
# ---------------------------------------------------------------------------

__pe::count() { if (( _PE_PANE == 0 )); then _PE_N=${#_PE_KEYS[@]}; else _PE_N=${#_PE_ROLES[@]}; fi; }

__pe::toggle() {
  local key=${_PE_KEYS[_TUI_VSEL]} var
  var=${_PE_TOG[$key]:-THEME_$key}
  if __pe::on "$key"; then printf -v "$var" 0; else printf -v "$var" 1; fi
  _PE_DIRTY=1; __pe::rebuild
}

__pe::move() {   # +1 / -1
  local s=$_TUI_VSEL t=$(( _TUI_VSEL + $1 )) k
  (( t < 0 || t >= ${#_PE_KEYS[@]} )) && return 0
  k=${_PE_KEYS[s]}; _PE_KEYS[s]=${_PE_KEYS[t]}; _PE_KEYS[t]=$k
  _TUI_VSEL=$t _PE_DIRTY=1
  __pe::rebuild
}

__pe::cb_knob() {
  [[ $1 =~ ${_PE_KNOB_RE[$_PE_CUR]} ]] && printf -v "$_PE_CUR" %s "$1"
  __pe::rebuild; __pe::draw
}

__pe::edit_knob() {
  local key=${_PE_KEYS[_TUI_VSEL]} var old
  var=${_PE_KNOB[$key]-}
  [[ -n $var ]] || { _PE_MSG="$key has no options"; return 0; }
  old=${!var-}; _PE_CUR=$var
  if _tui_readline "$var: " "$old" '' __pe::cb_knob; then
    if [[ $_TUI_LINE =~ ${_PE_KNOB_RE[$var]} ]]; then
      printf -v "$var" %s "$_TUI_LINE"
      [[ $_TUI_LINE != "$old" ]] && _PE_DIRTY=1
    else
      printf -v "$var" %s "$old"; _PE_MSG="invalid value for $var"
    fi
  else
    printf -v "$var" %s "$old"
  fi
  __pe::rebuild
}

__pe::role_set() {   # ROLE SLOT
  THEME_ROLE[$1]=$2
  if [[ $2 == "${_PE_ROLE_BASE[$1]-}" ]]; then unset "_PE_ROLE_OVR[$1]"; else _PE_ROLE_OVR[$1]=$2; fi
  __pe::rebuild
}

__pe::role_step() {   # +1 / -1
  local role=${_PE_ROLES[_TUI_VSEL]}
  __pe::role_set "$role" $(( (THEME_ROLE[$role] + $1 + 16) % 16 ))
  _PE_DIRTY=1
}

__pe::role_reset() {
  local role=${_PE_ROLES[_TUI_VSEL]}
  [[ -n ${_PE_ROLE_BASE[$role]+x} ]] || return 0
  __pe::role_set "$role" "${_PE_ROLE_BASE[$role]}"; _PE_DIRTY=1
}

__pe::cb_slot() {
  [[ $1 =~ ^[0-9]{1,2}$ ]] && (( 10#$1 <= 15 )) && __pe::role_set "$_PE_CUR" "$((10#$1))" && { __pe::draw; return 0; }
  __pe::draw
}

__pe::edit_slot() {
  local role=${_PE_ROLES[_TUI_VSEL]} old
  old=${THEME_ROLE[$role]}; _PE_CUR=$role
  if _tui_readline "$role slot 0-15: " "$old" '' __pe::cb_slot; then
    if [[ $_TUI_LINE =~ ^[0-9]{1,2}$ ]] && (( 10#$_TUI_LINE <= 15 )); then
      __pe::role_set "$role" "$((10#$_TUI_LINE))"
      [[ ${THEME_ROLE[$role]} != "$old" ]] && _PE_DIRTY=1
    else
      __pe::role_set "$role" "$old"; _PE_MSG="slot must be 0-15"
    fi
  else
    __pe::role_set "$role" "$old"
  fi
}

# Dump what the preview is working from, to help debug a preview that looks wrong.
__pe::debug() {
  local f=${TMPDIR:-/tmp}/prompt-editor.debug
  { declare -p PS1 TERM_TITLE_PS1 TERM_COLORS TERM_IS_CONSOLE THEME_SEGMENTS THEME_CWD_SEG _PE_PV
    printf 'expanded: '; printf '%q\n' "${PS1@P}"; } > "$f" 2>&1
  _PE_MSG="debug info written to $f"
}

__pe::switch() {
  _PE_SEL[_PE_PANE]=$_TUI_VSEL _PE_TOP[_PE_PANE]=$_TUI_VTOP
  _PE_PANE=$(( 1 - _PE_PANE ))
  _TUI_VSEL=${_PE_SEL[_PE_PANE]} _TUI_VTOP=${_PE_TOP[_PE_PANE]}
}

# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

_PE_HELPTXT=(
  "#|both panes"
  "tab|switch segments / colors"
  "j k|move (arrows, wheel, click)"
  "g G|first / last"
  "x|preview a failed command"
  "s|save to prompt.conf"
  "D|write preview debug info to a file"
  "q|quit"
  "#|segments"
  "space|enable / disable (or click [x])"
  "J K|move segment down / up"
  "e|edit the segment's option"
  "#|colors"
  "h l|previous / next ANSI slot"
  "c|type a slot number (0-15)"
  "u|reset to the theme's slot"
)

__pe::draw() {
  local last=$(( _TUI_ROWS - 1 )) i r idx s n key role slot base box hint
  local var kv k1 k2 l1 l2 on mod
  __pe::count; n=$_PE_N
  _PE_LROWS=$(( _TUI_ROWS - 9 )); (( _PE_LROWS < 1 )) && _PE_LROWS=1
  _tui_vp_fit "$_PE_LROWS" "$n"

  _tui_frame_begin
  _tui_resize_check && _tui_clear
  _tui_popup_hide help
  (( _PE_HELP )) && _tui_popup_geom_center help ${#_PE_HELPTXT[@]} 62
  _tui_popup_sync help

  if ! _tui_row_same 1 "t|$_PE_PANE|$_PE_DIRTY|$_TUI_COLS"; then
    _tui_row_begin 1
    _tui_bold; _tui_fg 39; _tui_p ' prompt editor  '; _tui_reset
    (( _PE_PANE == 0 )) && _tui_reverse; _tui_p ' segments '; _tui_reset; _tui_p ' '
    (( _PE_PANE == 1 )) && _tui_reverse; _tui_p ' colors '; _tui_reset
    (( _PE_DIRTY )) && { _tui_fg 220; _tui_p '  ● unsaved'; _tui_reset; }
    _tui_clear_eol; _tui_row_end
  fi
  if ! _tui_row_same 2 "l|$_PE_RC|$_TUI_COLS"; then
    _tui_row_begin 2
    _tui_dim; _tui_p ' preview  (last exit status: %s)' "$_PE_RC"; _tui_reset
    _tui_clear_eol; _tui_row_end
  fi
  for (( i = 0; i < 2; i++ )); do
    r=$(( 3 + i ))
    _tui_row_same "$r" "p|$i|$_TUI_COLS|${_PE_PV[i]-}" && continue
    _tui_row_begin "$r"; _tui_p '  %s' "${_PE_PV[i]-}"; _tui_reset; _tui_clear_eol; _tui_row_end
  done
  for r in 5 $(( last - 2 )); do
    _tui_row_same "$r" "d|$_TUI_COLS" && continue
    _tui_row_begin "$r"; _tui_dim; _tui_hline "$r" 1 "$_TUI_COLS"; _tui_reset; _tui_clear_eol; _tui_row_end
  done

  for (( i = 0; i < _PE_LROWS; i++ )); do
    r=$(( 6 + i )) idx=$(( _TUI_VTOP + i ))
    if (( idx >= n )); then
      _tui_row_same "$r" "e|$_TUI_COLS" && continue
      _tui_row_begin "$r"; _tui_clear_eol; _tui_row_end
      continue
    fi
    s=0; (( idx == _TUI_VSEL )) && s=1
    if (( _PE_PANE == 0 )); then
      key=${_PE_KEYS[idx]}
      on=0; __pe::on "$key" && on=1
      _tui_row_same "$r" "0|$idx|$s|$on|$key|${_PE_SAMPLE[$key]-}|$_TUI_COLS" && continue
      box='[ ]'; (( on )) && box='[x]'
      _tui_row_begin "$r"
      (( s )) && _tui_reverse
      (( on )) || _tui_dim
      k1=${_PE_SAMPLE[$key]-}
      _tui_p ' %s %-8.8s  %s' "$box" "$key" "${k1:0:_TUI_COLS-18}"
      _tui_clear_eol; _tui_reset; _tui_row_end
    else
      role=${_PE_ROLES[idx]}; slot=${THEME_ROLE[$role]}; base=${_PE_ROLE_BASE[$role]-$slot}
      _tui_row_same "$r" "1|$idx|$s|$slot|$base|$role|$_TUI_COLS" && continue
      mod=' '; [[ $slot != "$base" ]] && mod='*'
      _tui_row_begin "$r"
      (( s )) && _tui_reverse
      _tui_p ' \e[38;5;%sm███\e[39m %-8.8s slot %2d %s' "$slot" "$role" "$slot" "$mod"
      _tui_clear_eol; _tui_reset; _tui_row_end
    fi
  done

  k1= k2= l1=- l2=-
  if (( n )); then
    if (( _PE_PANE == 0 )); then
      key=${_PE_KEYS[_TUI_VSEL]}
      k1=${_PE_SAMPLE[$key]-}; k1=${k1:-(empty)}
      var=${_PE_TOG[$key]:-THEME_$key}; k2="$var=${!var:-1}"
      kv=${_PE_KNOB[$key]-}; [[ -n $kv ]] && k2+="   $kv=${!kv-}"
      l1=now l2=env
    else
      role=${_PE_ROLES[_TUI_VSEL]}
      k1="$role -> slot ${THEME_ROLE[$role]} (theme: ${_PE_ROLE_BASE[$role]-?})"
      k2="#${THEME_PALETTE[${THEME_ROLE[$role]}]-?}"
      l1=role l2=slot
    fi
  fi
  _tui_kv_row $(( last - 1 )) "$l1" "$k1"
  _tui_kv_row "$last" "$l2" "$k2"

  _tui_popup_draw help ' keys ' _PE_HELPTXT 8 114 cut

  if (( _PE_PANE == 0 )); then
    hint='space toggle  J/K move  e option  x fail  tab colors  s save  ? help  q quit'
  else
    hint='h/l slot  c type  u reset  x fail  tab segments  s save  ? help  q quit'
  fi
  _tui_status "${_TUI_PROMPT:-${_PE_MSG:-$hint}}"
  _tui_frame_end
}

# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------

__pe::handle() {
  local n y x idx
  _PE_MSG=
  __pe::count; n=$_PE_N
  case $_TUI_KEY in
    '?')        _PE_HELP=1 ;;
    $'\t')      __pe::switch ;;
    x)          (( _PE_RC = _PE_RC ? 0 : 1 )); __pe::rebuild ;;
    D)          __pe::debug ;;
    s)          __pe::save ;;
    q)          if (( ! _PE_DIRTY )) || _tui_confirm 'quit without saving?'; then _PE_QUIT=1; fi ;;
    wheelup)    _tui_vp_scroll -3 "$_PE_LROWS" "$n" ;;
    wheeldown)  _tui_vp_scroll 3 "$_PE_LROWS" "$n" ;;
    click)      y=$_TUI_MY x=$_TUI_MX
                if (( n && y >= 6 && y < 6 + _PE_LROWS )); then
                  idx=$(( _TUI_VTOP + y - 6 ))
                  if (( idx < n )); then
                    _TUI_VSEL=$idx
                    (( _PE_PANE == 0 && x >= 2 && x <= 4 )) && __pe::toggle
                  fi
                fi ;;
  esac
  (( n )) || return 0
  case $_TUI_KEY in
    j|down)  (( _TUI_VSEL < n - 1 )) && (( _TUI_VSEL++ )) ;;
    k|up)    (( _TUI_VSEL > 0 )) && (( _TUI_VSEL-- )) ;;
    g)       _TUI_VSEL=0 ;;
    G)       _TUI_VSEL=$(( n - 1 )) ;;
  esac
  if (( _PE_PANE == 0 )); then
    case $_TUI_KEY in
      space|enter) __pe::toggle ;;
      J)           __pe::move 1 ;;
      K)           __pe::move -1 ;;
      e)           __pe::edit_knob ;;
    esac
  else
    case $_TUI_KEY in
      l|right)     __pe::role_step 1 ;;
      h|left)      __pe::role_step -1 ;;
      c|enter)     __pe::edit_slot ;;
      u)           __pe::role_reset ;;
    esac
  fi
  return 0
}

# Runs in a subshell: returns 0 if something was saved, 2 if not.
__pe::run() {
  shopt -s promptvars
  __pe::discover
  __pe::rebuild
  trap '_tui_deinit' EXIT
  _tui_trap_resize
  _tui_init
  _tui_mouse_on
  _TUI_REDRAW=__pe::draw
  while :; do
    _tui_pending || __pe::draw
    _tui_key "$_TUI_TICK" || break
    [[ -z $_TUI_KEY ]] && continue
    if (( _PE_HELP )); then _PE_HELP=0; continue; fi
    __pe::handle
    (( _PE_QUIT )) && break
  done
  return $(( _PE_SAVED ? 0 : 2 ))
}

__pe::need_tui() {
  local f
  declare -F _tui_init >/dev/null && return 0
  for f in "${TUI_SH:-}" "${_TUI_SOURCEPATH:-}"; do
    [[ -n $f && -r $f ]] && { source "$f"; break; }
  done
  declare -F _tui_init >/dev/null || { printf 'prompt_edit: tui.sh not loaded (set TUI_SH)\n' >&2; return 1; }
}

prompt_edit() {
  [[ -t 0 && -t 1 ]] || { printf 'prompt_edit: needs a terminal\n' >&2; return 1; }
  __pe::need_tui || return 1
  ( __pe::run )
  (( $? == 0 )) || return 0
  # Saved: pick the changes up in this shell the same way theme() does.
  __pe::load_conf
  __theme::init "${THEME_NAME:-default}"
}
