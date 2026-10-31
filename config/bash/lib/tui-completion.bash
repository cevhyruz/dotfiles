# tui-completion.bash - Tab completion rendered as a live-filtered grid under the prompt.
#
# Needs tui.bash (for _tui_key). Source this from an interactive shell only:
#   [[ $- == *i* ]] && source ~/path/to/lib/tui-completion.bash
#
# Keys inside the grid:
#   Tab / Down / Ctrl-N     next item            Shift-Tab / Up / Ctrl-P   previous item
#   Right / Left            next / previous column
#   type                    narrow the list      Backspace / Ctrl-U        undo typing / reset
#   Enter                   insert the choice    Esc / Ctrl-C              cancel

declare -F _tui_key >/dev/null || source "${BASH_SOURCE[0]%/*}/tui.bash"

_PICK_QUERY=

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# _common_prefix ARRAY_NAME -> REPLY: longest prefix shared by all items
_common_prefix() {
    local ref="$1[@]" p s
    local -a a=("${!ref}")
    p=${a[0]-}
    for s in "${a[@]:1}"; do
        while [[ $s != "$p"* ]]; do p=${p%?}; done
    done
    REPLY=$p
}

# internal: sets ncols R cwid vis from items/n/h/maxw/avail (uses the caller's locals)
# Fills the height first (up to h rows), then adds columns; each column has its own width.
_pick_grid_layout() {
    local c idx cw total
    cwid=() ncols=1 R=1 vis=0
    (( n )) || return 0
    ncols=$(( (n + h - 1) / h ))
    while :; do
        R=$(( (n + ncols - 1) / ncols ))
        ncols=$(( (n + R - 1) / R ))               # no empty trailing column
        cwid=() total=0
        for (( c = 0; c < ncols; c++ )); do
            cw=0
            for (( idx = c * R; idx < (c + 1) * R && idx < n; idx++ )); do
                (( ${#items[idx]} > cw )) && cw=${#items[idx]}
            done
            (( cw > maxw )) && cw=$maxw
            cwid[c]=$cw
            (( total += cw + 2 ))
        done
        (( total <= avail || ncols == 1 )) && break
        (( ncols-- ))
    done
    (( cwid[0] > avail - 2 )) && cwid[0]=$(( avail - 2 ))
    vis=$R
    (( vis > h )) && vis=$h
    return 0
}

# ---------------------------------------------------------------------------
# The picker
# ---------------------------------------------------------------------------

# _pick_grid ARRAY_NAME [MAXROWS=8] [MAXW=40] [GAP=1] [QUERY=] -> REPLY, _PICK_QUERY
# Draws below the prompt with relative cursor moves only. The grid starts at the cursor
# column and uses the width to the right of it. REPLY is empty if cancelled;
# _PICK_QUERY holds whatever was typed.
_pick_grid() {
    local ref="$1[@]" h=${2:-8} maxw=${3:-40} gap=${4:-1} q=${5-}
    local -a all=("${!ref}") items=() cwid=()
    local n0=${#all[@]} n=0 minq=${#q} reserve need i c r idx srow ncols=1 R=1 vis=0
    local old _e col avail vtop=0 sel=0 line cell buf dirty=1 it brk=0 oldtrap

    REPLY= _PICK_QUERY=$q
    (( n0 )) || return 1
    (( gap < 1 )) && gap=1
    (( h > LINES - gap - 3 )) && h=$(( LINES - gap - 3 ))
    (( h < 1 )) && return 1
    reserve=$(( n0 < h ? n0 : h ))                 # most rows the grid can ever use

    old=$(stty -g </dev/tty)
    stty -echo -icanon -isig min 1 time 0 </dev/tty   # -isig: Ctrl-C arrives as a key

    # safety net for a real SIGINT (e.g. kill -INT): set a flag so cleanup still runs
    oldtrap=$(trap -p INT)
    trap 'brk=1' INT

    printf '\e[6n' >/dev/tty                       # where is the cursor?
    IFS='[;' read -rsdR -t 1 _e _ col </dev/tty
    : "${col:=1}"
    (( col > COLUMNS - 29 )) && col=$(( COLUMNS - 29 ))   # keep at least 30 cells
    (( col < 1 )) && col=1
    avail=$(( COLUMNS - col + 1 ))

    # reserve room below the prompt (scrolls if needed), then go back up
    need=$(( gap + 1 + reserve ))
    for (( i = 0; i < need; i++ )); do printf '\n' >/dev/tty; done
    printf '\e[%dA\e[%dG\e[?25l' "$need" "$col" >/dev/tty

    while :; do
        if (( dirty )); then
            items=()
            for it in "${all[@]}"; do [[ $it == "$q"* ]] && items+=("$it"); done
            n=${#items[@]} sel=0 vtop=0 dirty=0
            _pick_grid_layout
        fi
        if (( n )); then
            srow=$(( sel % R ))
            (( srow < vtop )) && vtop=$srow
            (( srow >= vtop + vis )) && vtop=$(( srow - vis + 1 ))
        fi

        # header: typed text, a cursor block, and the match counter
        printf -v cell '\e[%dB\e[%dG\e[0;1m» %.*s\e[7m \e[0;2m  %d/%d\e[0m\e[K\e[%dA' \
            "$gap" "$col" $(( avail - 14 )) "$q" "$n" "$n0" "$gap"
        buf=$cell
        for (( r = 0; r < reserve; r++ )); do
            line=
            if (( r < vis )); then
                for (( c = 0; c < ncols; c++ )); do
                    idx=$(( c * R + vtop + r ))
                    (( vtop + r < R && idx < n )) || break
                    printf -v cell ' %-*.*s ' "${cwid[c]}" "${cwid[c]}" "${items[idx]}"
                    if (( idx == sel )); then line+=$'\e[0;7m'$cell
                    else line+=$'\e[0;48;5;235;38;5;250m'$cell; fi
                done
            elif (( r == 0 && n == 0 )); then
                line=$'\e[2m no matches'
            fi
            printf -v cell '\e[%dB\e[%dG\e[K%s\e[0m\e[%dA' \
                $(( gap + 1 + r )) "$col" "$line" $(( gap + 1 + r ))
            buf+=$cell
        done
        printf '%s' "$buf" >/dev/tty               # one write per redraw

        _tui_key </dev/tty || break
        (( brk )) && break
        case $_TUI_KEY in
            down|$'\t'|$'\016')                    # next (wraps)
                (( n )) && (( sel = sel < n - 1 ? sel + 1 : 0 )) ;;
            up|$'\020'|$'\e')                      # previous; shift-tab arrives as a bare ESC
                (( n )) && (( sel = sel > 0 ? sel - 1 : n - 1 )) ;;
            right)
                (( n )) || continue
                if (( sel + R < n )); then (( sel += R ))
                elif (( (n - 1) / R > sel / R )); then sel=$(( n - 1 )); fi ;;
            left)
                (( sel >= R )) && (( sel -= R )) ;;
            enter)
                (( n )) && { REPLY=${items[sel]}; break; } ;;
            esc|$'\003') break ;;
            $'\177'|$'\b')                         # backspace, never below the original word
                (( ${#q} > minq )) && { q=${q%?}; dirty=1; } ;;
            $'\025')                               # ctrl-u: back to the original word
                q=${q:0:minq}; dirty=1 ;;
            space)
                q+=' '; dirty=1 ;;
            *)
                if (( ${#_TUI_KEY} == 1 )) && [[ $_TUI_KEY != [[:cntrl:]] ]]; then
                    q+=$_TUI_KEY; dirty=1
                fi ;;
        esac
    done

    # erase the header and grid rows, put the cursor back on the prompt line
    buf=
    for (( r = 0; r <= reserve; r++ )); do
        printf -v cell '\e[%dB\e[%dG\e[K\e[%dA' $(( gap + r )) "$col" $(( gap + r ))
        buf+=$cell
    done
    printf '%s\e[%dG\e[?25h' "$buf" "$col" >/dev/tty

    stty "$old" </dev/tty                          # tty first, then the trap
    if [[ -n $oldtrap ]]; then eval "$oldtrap"; else trap - INT; fi
    _PICK_QUERY=$q
    return 0
}

# ---------------------------------------------------------------------------
# Tab binding
# ---------------------------------------------------------------------------

_tui_tab() {
    local head=${READLINE_LINE:0:READLINE_POINT} tail=${READLINE_LINE:READLINE_POINT}
    local word=${head##*[[:space:]]} prefix sfx=' ' cp partial=0
    prefix=${head%"$word"}
    local -a items=()
    if [[ $prefix =~ ^[[:space:]]*$ && $word != */* ]]; then
        [[ -n $word ]] || return                   # empty line: leave Tab alone
        mapfile -t items < <(compgen -c -- "$word" | sort -u)
    else
        mapfile -t items < <(compgen -f -- "$word")
    fi
    case ${#items[@]} in
        0) return ;;
        1) REPLY=${items[0]} ;;
        *) _common_prefix items; cp=$REPLY
           _pick_grid items 8 40 1 "$word"
           if [[ -z $REPLY ]]; then                # cancelled: keep the longer of prefix / typed text
               (( ${#_PICK_QUERY} > ${#cp} )) && cp=$_PICK_QUERY
               (( ${#cp} > ${#word} )) || return
               REPLY=$cp partial=1 sfx=
           fi ;;
    esac
    (( partial )) || { [[ -d $REPLY ]] && sfx=/; } # check before quoting
    printf -v REPLY '%q' "$REPLY"
    READLINE_LINE=$prefix$REPLY$sfx$tail
    READLINE_POINT=$(( ${#prefix} + ${#REPLY} + ${#sfx} ))
}

bind -x '"\t": _tui_tab'
