#!/usr/bin/env bash
# fzf-region.sh - fzf in the bottom rows of a tui.sh screen.
# Put it next to tui.sh.  Keys: f = open fzf, q = quit.

HERE=$(cd "${BASH_SOURCE[0]%/*}" && pwd)
SELF=$HERE/${BASH_SOURCE[0]##*/}
source "$HERE/tui.bash"

FZF_ROWS=${FZF_ROWS:-12}
ITEMS=(alpha bravo charlie delta echo foxtrot golf hotel india juliet kilo lima mike november)
PICKED=${PICKED:-}
TOP_ROWS=0
RESIZED=0
export FZF_ROWS PICKED

# Rows 1..TOP_ROWS belong to the TUI. One spare row sits above fzf's region so
# fzf never has to scroll the screen.
top_rows() { TOP_ROWS=$(( _TUI_ROWS - FZF_ROWS - 1 )); }

# Draw the TUI's rows. $1 = item currently highlighted in fzf (if any).
# Never touches rows below TOP_ROWS.
draw_top() {
    local sel=${1:-"(none)"} r
    for (( r = 1; r <= TOP_ROWS; r++ )); do
        _tui_row_begin "$r"
        case $r in
            1) _tui_reverse
               _tui_p '%-*.*s' "$_TUI_COLS" "$_TUI_COLS" " tui.sh | fzf region demo"
               _tui_reset ;;
            3) _tui_p '  highlighted : '; _tui_bold; _tui_p '%s' "$sel"; _tui_reset ;;
            4) _tui_p '  last picked : %s' "${PICKED:--}" ;;
            *) if (( r == TOP_ROWS )); then
                   _tui_dim; _tui_p '  f: open fzf   q: quit'; _tui_reset
               fi ;;
        esac
        _tui_clear_eol
        _tui_row_end
    done
}

paint() {
    _tui_frame_begin
    draw_top "$1"
    _tui_frame_end
}

# --focus ITEM: run by fzf on every focus change, in a separate process.
# It has no access to the parent's row cache, so it just paints the rows
# directly (bypassing the diff) and puts the cursor back where fzf left it.
if [[ ${1:-} == --focus ]]; then
    exec >/dev/tty
    _tui_size; top_rows
    _tui_frame_begin
    _tui_save
    draw_top "${2:-}"
    _tui_restore
    _tui_frame_end
    exit 0
fi

run_fzf() {
    local out saved
    saved=$(stty -g)               # whatever mode the TUI is in right now

    # hand the terminal over
    _tui_mouse_off
    _tui_show_cursor
    _tui_goto $(( TOP_ROWS + 1 )) 1
    printf '\e[J'                  # clear from the region start downward

    # stdin = item list, fzf's UI goes to /dev/tty, selection comes back on stdout
    out=$(printf '%s\n' "${ITEMS[@]}" |
        fzf --height="$FZF_ROWS" --layout=reverse --border=top --prompt='pick> ' \
            --bind "focus:execute-silent(bash '$SELF' --focus {})")

    # take it back
    stty "$saved"
    [[ -n $out ]] && PICKED=$out
    export PICKED
    _tui_hide_cursor
    _tui_mouse_on
    _tui_invalidate                # fzf and the --focus process changed the screen behind the cache
}

main() {
    command -v fzf >/dev/null || { echo "fzf not found" >&2; return 1; }

    trap '_tui_deinit' EXIT
    trap '_tui_size; top_rows; RESIZED=1' WINCH

    _tui_init
    top_rows
    _tui_mouse_on

    while :; do
        if (( RESIZED )); then RESIZED=0; _tui_clear; fi
        paint ""
        _tui_key || break
        case $_TUI_KEY in
            f) run_fzf ;;
            q) break ;;
        esac
    done
}

main
