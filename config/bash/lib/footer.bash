_FOOTER_ROW=0                                      # screen row of the bar as last drawn

_TUI_STATUS_BG=234    # dark blue
_TUI_STATUS_FG=255   # white

_footer_draw() {            # no argument: WINCH. Argument 1: from the prompt hook

    printf '\e[?2026h'

    local t left pad at_prompt=${1:-0}
    printf -v t '%((%a, %b-%d) %I:%M %p)T' -1
    _tui_on_resize
printf '%s arg=%s rows=%s cols=%s stty=%s\n' "$EPOCHREALTIME" "${1:-winch}" "$_TUI_ROWS" "$_TUI_COLS" "$(stty size </dev/tty)" >> /tmp/footer.log
    printf '\e7\e[r\e8'                            # release the region, cursor stays put
    # printf '\eD\e[A'                               # cursor off the last row (scrolls if it was on it)
    printf '\eD\e[1K\e[J\e[A'    # step down, erase that row and everything below, step back up
    _tui_save
    # (absolute-row wipe block removed)
    (( at_prompt )) && printf '\e[J'
    if (( _FOOTER_ROW && _FOOTER_ROW != _TUI_ROWS && _FOOTER_ROW <= _TUI_ROWS )); then
        printf '\e[%d;1H\e[2K' "$_FOOTER_ROW"      # wipe the bar left at the previous size
    fi
    (( at_prompt )) && printf '\e[J'               # prompt hook only: nothing is below the prompt
    printf '\e[1;%dr' $(( _TUI_ROWS - 1 ))
    _tui_invalidate

    left="${DIRSTACK[@]}"
    pad=$(( _TUI_COLS - 2 - ${#t} - ${#left} ))
    if (( pad < 2 )); then
        left=${left:0:_TUI_COLS - 2 - ${#t} - 3}…
        pad=1
        (( ${#left} + ${#t} + 3 > _TUI_COLS )) && { left=; pad=$(( _TUI_COLS - 2 - ${#t} )); }
    fi
    printf -v pad '%*s' "$pad" ''
    _tui_status "$left$pad$t "

    _FOOTER_ROW=$_TUI_ROWS
    _tui_restore

  printf '\e[?2026l'

}

_footer_prompt() { _footer_draw 1; }

footer_on() {
    printf '\n\e[A'
    ::post_command _footer_prompt
    bind '"\e[0n": redraw-current-line'    # terminal's DSR reply repaints the prompt
    trap '_footer_winch' WINCH
    _footer_draw
}

_footer_winch() {
    _footer_draw
    [[ -n ${AT_PROMPT:-} ]] && printf '\e[5n'   # only while sitting at a prompt
}

footer_off() {
    ::remove_post_command _footer_prompt
    bind -r '\e[0n'
    trap - WINCH
    printf '\e7\e[r\e[%d;1H\e[2K\e8' "${_FOOTER_ROW:-$LINES}"   # clear the bar where it really is
    _FOOTER_ROW=0
}

_footer_fullscreen() {                 # run a full-screen program with the region released
    printf '\e7\e[r\e8'                # \e7/\e8 because \e[r homes the cursor
    command "$@"
    local rc=$?
    _footer_draw                       # bar and region back immediately
    return $rc
}
nvim()  { _footer_fullscreen nvim "$@"; }
vim()   { _footer_fullscreen vim "$@"; }
less()  { _footer_fullscreen less "$@"; }
htop()  { _footer_fullscreen htop "$@"; }
man()   { _footer_fullscreen man "$@"; }


# Replace clear with a version that erases only rows above the footer.
# \e[1J erases from the top of the screen through the cursor, so put the cursor
# on the last row above the footer:
clear() {
    _tui_on_resize
    printf '\e[%d;%dH\e[1J\e[3J\e[H' $(( _TUI_ROWS - 1 )) "$_TUI_COLS"
}

