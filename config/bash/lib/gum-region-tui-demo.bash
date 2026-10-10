#!/usr/bin/env bash
# gum-region.sh - gum in the bottom rows of a tui.sh screen.
# Put it next to tui.sh.  Keys: f = open gum filter, c = gum choose, q = quit.

HERE=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
source "$HERE/tui.bash"

GUM_ROWS=${GUM_ROWS:-12}      # list height passed to gum
GUM_EXTRA=3                   # prompt line + help line + spare row around the list
ITEMS=(alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november)
PICKED=
TOP_ROWS=0
RESIZED=0

# Rows 1..TOP_ROWS belong to the TUI; everything below is reserved for gum.
top_rows() { TOP_ROWS=$(( _TUI_ROWS - GUM_ROWS - GUM_EXTRA )); }

draw_top() {
    local r
    for (( r = 1; r <= TOP_ROWS; r++ )); do
        _tui_row_begin "$r"
        case $r in
            1) _tui_reverse
               _tui_p '%-*.*s' "$_TUI_COLS" "$_TUI_COLS" " tui.sh | gum region demo"
               _tui_reset ;;
            3) _tui_p '  last picked : '; _tui_bold; _tui_p '%s' "${PICKED:--}"; _tui_reset ;;
            *) if (( r == TOP_ROWS )); then
                   _tui_dim; _tui_p '  f: filter   c: choose   q: quit'; _tui_reset
               fi ;;
        esac
        _tui_clear_eol
        _tui_row_end
    done
}

paint() {
    _tui_frame_begin
    draw_top
    _tui_frame_end
}

# run_in_region CMD [ARGS...]
# Hands the bottom rows to an external command, captures its stdout in REPLY,
# then takes the terminal back. gum draws its UI on stderr/tty, so the
# selection comes back cleanly on stdout.
run_in_region() {
    local saved
    saved=$(stty -g)

    _tui_mouse_off
    _tui_show_cursor
    _tui_goto $(( TOP_ROWS + 1 )) 1
    printf '\e[J'

    REPLY=$("$@")

    stty "$saved"
    printf '\e[%d;1H\e[J' $(( TOP_ROWS + 1 ))   # wipe anything gum left behind
    _tui_hide_cursor
    _tui_mouse_on
    _tui_invalidate                             # screen changed behind the row cache
}

pick_filter() {
    printf '%s\n' "${ITEMS[@]}" > "$TMP"
    run_in_region gum filter --height="$GUM_ROWS" --placeholder='pick...' < "$TMP"
    [[ -n $REPLY ]] && PICKED=$REPLY
}

pick_choose() {
    run_in_region gum choose --height="$GUM_ROWS" "${ITEMS[@]}"
    [[ -n $REPLY ]] && PICKED=$REPLY
}

main() {
    command -v gum >/dev/null || { echo "gum not found" >&2; return 1; }

    TMP=$(mktemp)
    trap '_tui_deinit; rm -f "$TMP"' EXIT
    trap '_tui_size; top_rows; RESIZED=1' WINCH

    _tui_init
    top_rows
    _tui_mouse_on

    while :; do
        if (( RESIZED )); then RESIZED=0; _tui_clear; fi
        paint
        _tui_key || break
        case $_TUI_KEY in
            f) pick_filter ;;
            c) pick_choose ;;
            q) break ;;
        esac
    done
}

main
