# drawer.bash - a left-side drawer next to the live shell (pure bash + tui.bash)
#
# How it works: the terminal's left/right margins (DECSLRM, mode ?69) confine the shell's
# output to the columns right of the drawer, and `stty cols` tells readline the narrower
# width. The drawer is drawn in the reserved columns with absolute cursor moves.
#
# Needs a terminal with DECSLRM: xterm, kitty, foot, WezTerm, iTerm2, Konsole (recent).
# NOT supported: VTE terminals (GNOME Terminal, Tilix, ...) and tmux. See drawer_on.
#
#   drawer_on / drawer_off / drawer_toggle

declare -F _tui_goto >/dev/null || source "${BASH_SOURCE[0]%/*}/tui.bash"

_DRAWER_W=${_DRAWER_W:-28}       # drawer width in columns (includes the border)
_DRAWER_ON=0
_DRAWER_FULL=0                   # real terminal width

# Ask the terminal whether DECSLRM is supported (DECRQM reply: ESC [ ? 69 ; 1|2 $ y)
_drawer_supported() {
    local r old
    old=$(stty -g </dev/tty)
    stty -echo -icanon min 1 time 0 </dev/tty
    printf '\e[?69$p' >/dev/tty
    IFS= read -rsd y -t 0.3 r </dev/tty
    stty "$old" </dev/tty
    [[ $r == *'69;1$'* || $r == *'69;2$'* ]]
}

# Fill the drawer. Replace the lines below to show whatever you like.
_drawer_draw() {
    local w=$_DRAWER_W r txt
    local -a L=()
    mapfile -t L < <(ls -1Ap --group-directories-first 2>/dev/null)

    _tui_frame_begin
    _tui_save
    for (( r = 1; r <= _TUI_ROWS; r++ )); do
        case $r in
            1) txt=" drawer" ;;
            2) txt=" ${PWD/#$HOME/\~}" ;;
            3) txt= ;;
            *) txt=" ${L[r-4]-}" ;;
        esac
        _tui_goto "$r" 1
        _tui_bg 235
        case $r in
            1) _tui_bold; _tui_fg 220 ;;
            2) _tui_fg 75 ;;
            *) _tui_fg 250 ;;
        esac
        _tui_p '%-*.*s' $(( w - 1 )) $(( w - 1 )) "$txt"
        _tui_reset
        _tui_fg 240; _tui_p '│'; _tui_reset
    done
    _tui_restore
    _tui_frame_end
}

# Resize and prompt hook. Argument 1 = called from the prompt (cursor is at column 1).
_drawer_sync() {
    local want
    _tui_on_resize
    # our own `stty cols` also raises WINCH; anything else is a real resize
    (( _TUI_COLS == _DRAWER_FULL - _DRAWER_W )) || _DRAWER_FULL=$_TUI_COLS
    want=$(( _DRAWER_FULL - _DRAWER_W ))
    (( _TUI_COLS == want )) || stty cols "$want" </dev/tty

    # margins home the cursor, so save and restore it around them
    printf '\e7\e[?69h\e[%d;%ds\e8' $(( _DRAWER_W + 1 )) "$_DRAWER_FULL"
    (( ${1:-0} )) && printf '\e[%dG' $(( _DRAWER_W + 1 ))
    _drawer_draw
}

_drawer_prompt() { _drawer_sync 1; }

# Give the whole terminal back (for full-screen programs) without forgetting the drawer.
_drawer_release() {
    printf '\e[1;%ds\e[?69l' "$_DRAWER_FULL"
    stty cols "$_DRAWER_FULL" </dev/tty
}

drawer_on() {
    (( _DRAWER_ON )) && return 0
    if [[ -n ${TMUX:-} ]]; then
        echo "tmux has no left/right margins. Use a real split instead:" >&2
        echo "  tmux split-window -hbd -l $_DRAWER_W 'while :; do clear; ls -Ap; sleep 2; done'" >&2
        return 1
    fi
    if ! _drawer_supported; then
        echo "this terminal does not support left/right margins (DECSLRM)" >&2
        return 1
    fi
    shopt -s checkwinsize
    _DRAWER_FULL=$COLUMNS _DRAWER_ON=1
    PROMPT_COMMAND="_drawer_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
    trap '_drawer_sync' WINCH
    printf '\n\e[A'
    _drawer_sync 1
}

drawer_off() {
    local r
    (( _DRAWER_ON )) || return 0
    PROMPT_COMMAND=${PROMPT_COMMAND//_drawer_prompt;/}
    PROMPT_COMMAND=${PROMPT_COMMAND//_drawer_prompt/}
    trap - WINCH
    _drawer_release
    printf '\e7'
    for (( r = 1; r <= LINES; r++ )); do printf '\e[%d;1H\e[%dX' "$r" "$_DRAWER_W"; done
    printf '\e8'
    _DRAWER_ON=0
}

drawer_toggle() { if (( _DRAWER_ON )); then drawer_off; else drawer_on; fi; }

# Full-screen programs draw with absolute positions, which would land on the drawer.
_drawer_fullscreen() {
    local rc
    (( _DRAWER_ON )) && _drawer_release
    command "$@"; rc=$?
    (( _DRAWER_ON )) && _drawer_sync 1
    return $rc
}
nvim()  { _drawer_fullscreen nvim "$@"; }
vim()   { _drawer_fullscreen vim "$@"; }
less()  { _drawer_fullscreen less "$@"; }
htop()  { _drawer_fullscreen htop "$@"; }
man()   { _drawer_fullscreen man "$@"; }
