_pick() {   # _pick ARRAY_NAME -> REPLY (empty if cancelled)
    local ref="$1[@]" n i idx rows
    local -a items=("${!ref}")
    n=${#items[@]} REPLY=
    _TUI_VSEL=0 _TUI_VTOP=0
    _tui_init
    while :; do
        rows=$(( _TUI_ROWS - 1 ))
        _tui_vp_fit "$rows" "$n"
        _tui_frame_begin
        for (( i = 0; i < rows; i++ )); do
            idx=$(( _TUI_VTOP + i ))
            _tui_row_begin $(( i + 1 ))
            if (( idx < n )); then
                (( idx == _TUI_VSEL )) && _tui_reverse
                _tui_p '%-*.*s' "$_TUI_COLS" "$_TUI_COLS" " ${items[idx]}"
                _tui_reset
            fi
            _tui_clear_eol; _tui_row_end
        done
        _tui_status "up/down: move  enter: pick  esc: cancel"
        _tui_frame_end
        _tui_key || break
        case $_TUI_KEY in
            up)    (( _TUI_VSEL-- )) ;;
            down)  (( _TUI_VSEL++ )) ;;
            enter) REPLY=${items[_TUI_VSEL]}; break ;;
            esc|q) break ;;
        esac
    done
    _tui_deinit
}

_hist_pick() {
    local -a h
    mapfile -t h < <(history | sed 's/^ *[0-9]* *//' | tac | awk '!s[$0]++')
    _pick h
    [[ -n $REPLY ]] && { READLINE_LINE=$REPLY; READLINE_POINT=${#REPLY}; }
}
bind -x '"\C-r": _hist_pick'

_rprompt() {
    local s=" $(date +%H:%M) "
    printf '\e7\e[%d;%dH\e[2m%s\e[0m\e8' "$LINES" $(( COLUMNS - ${#s} + 1 )) "$s"
}
