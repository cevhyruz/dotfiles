# drawer-nav.bash - key bindings and a navigable file list for drawer.bash
# Source it AFTER drawer.bash (it replaces _drawer_draw and _drawer_prompt).
#
#   Alt-d   toggle the drawer
#   Alt-e   move focus into the drawer:
#             j / k / Ctrl-N / Ctrl-P / arrows   move       g / G   first / last
#             Enter / l / right   open a directory (browse only) or insert a file
#             h / left / backspace   parent directory
#             i   insert the highlighted name at the cursor
#             c   put `cd <browsed dir>` on the command line (press Enter to run it)
#             Esc / q / Ctrl-C   back to the shell

declare -F drawer_on >/dev/null || source "${BASH_SOURCE[0]%/*}/drawer.bash"

_DRAWER_FOCUS=0
_DRAWER_DIR=$PWD
_DRAWER_ITEMS=()

# list state lives in the library's viewport variables _TUI_VSEL / _TUI_VTOP
_drawer_load() {
    [[ -d $_DRAWER_DIR ]] || _DRAWER_DIR=$PWD
    mapfile -t _DRAWER_ITEMS < <(cd -- "$_DRAWER_DIR" 2>/dev/null && ls -1Ap --group-directories-first)
    _TUI_VSEL=0 _TUI_VTOP=0
}

_drawer_draw() {
    local w=$_DRAWER_W r idx txt
    (( _DRAWER_FOCUS )) || _drawer_load

    _tui_frame_begin
    _tui_save
    for (( r = 1; r <= _TUI_ROWS; r++ )); do
        idx=$(( _TUI_VTOP + r - 4 ))
        case $r in
            1) txt=" drawer" ;;
            2) txt=" ${_DRAWER_DIR/#$HOME/\~}" ;;
            3) txt= ;;
            *) txt=" ${_DRAWER_ITEMS[idx]-}" ;;
        esac
        _tui_goto "$r" 1
        _tui_bg 235
        case $r in
            1) _tui_bold; _tui_fg 220 ;;
            2) _tui_fg 75 ;;
            *) _tui_fg 250 ;;
        esac
        (( _DRAWER_FOCUS && r >= 4 && idx == _TUI_VSEL && idx < ${#_DRAWER_ITEMS[@]} )) && _tui_reverse
        _tui_p '%-*.*s' $(( w - 1 )) $(( w - 1 )) "$txt"
        _tui_reset
        _tui_fg 240; _tui_p '│'; _tui_reset
    done
    _tui_restore
    _tui_frame_end
}

# every new prompt starts browsing from the shell's directory again
_drawer_prompt() { _DRAWER_DIR=$PWD; _drawer_sync 1; }

# _drawer_insert NAME: put a quoted path at the cursor
_drawer_insert() {
    local p=$1
    [[ $_DRAWER_DIR == "$PWD" ]] || p=${_DRAWER_DIR%/}/$p
    printf -v p '%q ' "$p"
    READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$p${READLINE_LINE:READLINE_POINT}
    READLINE_POINT=$(( READLINE_POINT + ${#p} ))
}

drawer_focus() {
    (( _DRAWER_ON )) || return 0
    local rows=$(( _TUI_ROWS - 3 )) n old name
    old=$(stty -g </dev/tty)
    stty -echo -icanon -isig min 1 time 0 </dev/tty
    _DRAWER_FOCUS=1
    printf '\e[?25l'
    while :; do
        n=${#_DRAWER_ITEMS[@]}
        _tui_vp_fit "$rows" "$n"
        _drawer_draw
        _tui_key </dev/tty || break
        name=${_DRAWER_ITEMS[_TUI_VSEL]-}
        case $_TUI_KEY in
            j|down|$'\016') (( _TUI_VSEL++ )) ;;
            k|up|$'\020')   (( _TUI_VSEL-- )) ;;
            g)              _TUI_VSEL=0 ;;
            G)              _TUI_VSEL=$(( n - 1 )) ;;
            enter|l|right)
                if [[ $name == */ ]]; then
                    _DRAWER_DIR=${_DRAWER_DIR%/}/${name%/}; _drawer_load
                elif [[ -n $name ]]; then
                    _drawer_insert "$name"; break
                fi ;;
            h|left|$'\177'|$'\b')
                _DRAWER_DIR=${_DRAWER_DIR%/*}; [[ -n $_DRAWER_DIR ]] || _DRAWER_DIR=/
                _drawer_load ;;
            i)  [[ -n $name ]] && { _drawer_insert "${name%/}"; break; } ;;
            c)  printf -v READLINE_LINE 'cd %q' "$_DRAWER_DIR"
                READLINE_POINT=${#READLINE_LINE}; break ;;
            esc|q|$'\003') break ;;
        esac
    done
    _DRAWER_FOCUS=0
    printf '\e[?25h'
    stty "$old" </dev/tty
    _drawer_draw
}

bind -x '"\ed": drawer_toggle'
bind -x '"\ee": drawer_focus'
