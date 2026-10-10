#!/usr/bin/env bash
# tetris.sh - Tetris in pure bash, built on tui.sh
#
# Put it next to tui.sh and run:  ./tetris.sh
# Needs bash 5+ (EPOCHREALTIME is used for gravity timing, so held keys
# can never stall the falling piece).
#
# Keys: left/right (a/d) move, up (w/x) rotate, z rotate back,
#       down (s) soft drop, space hard drop, p pause, r restart, q quit

_here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
# shellcheck source=tui.sh
source "${BASH_SOURCE[0]%/*}/tui.bash"

if [[ -z ${EPOCHREALTIME:-} ]]; then
    echo "tetris.sh needs bash 5+ (EPOCHREALTIME)" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Constants and state
# ---------------------------------------------------------------------------

BW=10 BH=20                      # board size in cells
TT_WIDTH=41                      # board (22) + gap (3) + side panel (16)
TT_MIN_COLS=42 TT_MIN_ROWS=24

TT_SHAPE=()                      # [piece*4+rot] = "x0 y0 x1 y1 x2 y2 x3 y3"
TT_CELL=() TT_GHOST=()           # [piece+1] = rendered cell strings
TT_EMPTY= TT_TOP= TT_BOT=
TT_COLOR=(51 21 208 226 46 129 196)   # I J L O S T Z

BOARD=() BAG=() OVL=()
CUR=0 ROT=0 PX=0 PY=0 NEXT=0
SCORE=0 LINES=0 LEVEL=1 STATE=play
NEXT_FALL=0

# ---------------------------------------------------------------------------
# Setup: precompute all rotations and cell strings
# ---------------------------------------------------------------------------

_tetris_setup() {
    local -a base=(
        "4 0,1 1,1 2,1 3,1"      # I
        "3 0,0 0,1 1,1 2,1"      # J
        "3 2,0 0,1 1,1 2,1"      # L
        "0 1,0 2,0 1,1 2,1"      # O (never rotates)
        "3 1,0 2,0 0,1 1,1"      # S
        "3 1,0 0,1 1,1 2,1"      # T
        "3 0,0 1,0 1,1 2,1"      # Z
    )
    local -a parts cs
    local p r i n x y cell col

    for p in 0 1 2 3 4 5 6; do
        read -ra parts <<<"${base[p]}"
        n=${parts[0]}
        cs=()
        for cell in "${parts[@]:1}"; do
            cs+=("${cell%,*}" "${cell#*,}")
        done
        for r in 0 1 2 3; do
            TT_SHAPE[p*4+r]="${cs[*]}"
            if (( n )); then
                # rotate clockwise inside the n x n box: (x,y) -> (n-1-y, x)
                for (( i = 0; i < 8; i += 2 )); do
                    x=${cs[i]} y=${cs[i+1]}
                    cs[i]=$(( n - 1 - y )) cs[i+1]=$x
                done
            fi
        done
        col=${TT_COLOR[p]}
        printf -v 'TT_CELL[p+1]'  '\e[48;5;%dm  \e[0m' "$col"
        printf -v 'TT_GHOST[p+1]' '\e[38;5;%dm▒▒\e[0m' "$col"
    done

    printf -v TT_EMPTY '\e[38;5;238m· \e[0m'
    _tui_repeat 11 '─'; TT_TOP="┌─ TETRIS ${REPLY}┐"
    _tui_repeat $(( BW * 2 )) '─'; TT_BOT="└${REPLY}┘"
}

# ---------------------------------------------------------------------------
# Game logic
# ---------------------------------------------------------------------------

# _tetris_fits PIECE ROT X Y: true if the piece fits there
_tetris_fits() {
    local -a c=(${TT_SHAPE[$1*4+$2]})
    local i x y
    for (( i = 0; i < 8; i += 2 )); do
        x=$(( $3 + c[i] )) y=$(( $4 + c[i+1] ))
        (( x < 0 || x >= BW || y < 0 || y >= BH )) && return 1
        (( BOARD[y*BW+x] )) && return 1
    done
    return 0
}

# 7-bag randomizer -> REPLY
_tetris_bag() {
    local i j t n
    if (( ${#BAG[@]} == 0 )); then
        BAG=(0 1 2 3 4 5 6)
        for (( i = 6; i > 0; i-- )); do
            j=$(( RANDOM % (i + 1) ))
            t=${BAG[i]} BAG[i]=${BAG[j]} BAG[j]=$t
        done
    fi
    n=${#BAG[@]}
    REPLY=${BAG[n-1]}
    unset "BAG[$(( n - 1 ))]"
}

# _tetris_msg ROW TEXT: centered reverse-video message over a board row
_tetris_msg() {
    local t=$2 pad s
    pad=$(( (BW * 2 - ${#t}) / 2 ))
    printf -v s '%*s%-*s' "$pad" '' $(( BW * 2 - pad )) "$t"
    OVL[$1]=$'\e[7m'$s$'\e[0m'
}

_tetris_spawn() {
    CUR=$NEXT
    _tetris_bag; NEXT=$REPLY
    ROT=0 PX=3 PY=0
    if ! _tetris_fits "$CUR" "$ROT" "$PX" "$PY"; then
        STATE=over
        _tetris_msg 8  "GAME OVER"
        _tetris_msg 9  "score $SCORE"
        _tetris_msg 11 "r  restart"
        _tetris_msg 12 "q  quit"
    fi
}

_tetris_new() {
    local i
    BOARD=() BAG=() OVL=()
    for (( i = 0; i < BW * BH; i++ )); do BOARD[i]=0; done
    SCORE=0 LINES=0 LEVEL=1 STATE=play
    _tetris_bag; NEXT=$REPLY
    _tetris_spawn
}

# _tetris_try DX DY DROT: move/rotate if it fits
_tetris_try() {
    local nr=$(( (ROT + $3 + 4) % 4 )) nx=$(( PX + $1 )) ny=$(( PY + $2 ))
    if _tetris_fits "$CUR" "$nr" "$nx" "$ny"; then
        ROT=$nr PX=$nx PY=$ny
        return 0
    fi
    return 1
}

# _tetris_rotate DIR (1 = clockwise, -1 = back), with simple wall/floor kicks
_tetris_rotate() {
    local nr=$(( (ROT + $1 + 4) % 4 )) k dy
    (( CUR == 3 )) && return 0
    for dy in 0 -1; do
        for k in 0 -1 1 -2 2; do
            if _tetris_fits "$CUR" "$nr" $(( PX + k )) $(( PY + dy )); then
                ROT=$nr PX=$(( PX + k )) PY=$(( PY + dy ))
                return 0
            fi
        done
    done
    return 1
}

_tetris_clear_lines() {
    local y x full n=0 src dst
    local -a keep=() nb=()
    for (( y = BH - 1; y >= 0; y-- )); do
        full=1
        for (( x = 0; x < BW; x++ )); do
            (( BOARD[y*BW+x] )) || { full=0; break; }
        done
        if (( full )); then n=$(( n + 1 )); else keep+=("$y"); fi
    done
    (( n )) || return 0

    dst=$(( BH - 1 ))
    for src in "${keep[@]}"; do
        for (( x = 0; x < BW; x++ )); do nb[dst*BW+x]=${BOARD[src*BW+x]}; done
        dst=$(( dst - 1 ))
    done
    for (( ; dst >= 0; dst-- )); do
        for (( x = 0; x < BW; x++ )); do nb[dst*BW+x]=0; done
    done
    BOARD=("${nb[@]}")

    local -a pts=(0 100 300 500 800)
    SCORE=$(( SCORE + pts[n] * LEVEL ))
    LINES=$(( LINES + n ))
    LEVEL=$(( LINES / 10 + 1 ))
}

_tetris_interval() {
    local ms=$(( 800 - (LEVEL - 1) * 70 ))
    (( ms < 70 )) && ms=70
    REPLY=$(( ms * 1000 ))
}

_tetris_reset_timer() {
    _tetris_interval
    NEXT_FALL=$(( ${EPOCHREALTIME//[.,]/} + REPLY ))
}

_tetris_lock() {
    local -a c=(${TT_SHAPE[CUR*4+ROT]})
    local i idx
    for (( i = 0; i < 8; i += 2 )); do
        idx=$(( (PY + c[i+1]) * BW + PX + c[i] ))
        BOARD[idx]=$(( CUR + 1 ))
    done
    _tetris_clear_lines
    _tetris_spawn
    _tetris_reset_timer
}

_tetris_gravity() { _tetris_try 0 1 0 || _tetris_lock; }

_tetris_hard_drop() {
    while _tetris_try 0 1 0; do SCORE=$(( SCORE + 2 )); done
    _tetris_lock
}

# Returns 1 when the player wants to quit.
_tetris_handle() {
    local k=$_TUI_KEY
    [[ $k == [qQ] ]] && return 1
    if [[ $k == [rR] ]]; then
        _tetris_new
        _tetris_reset_timer
        return 0
    fi
    case $STATE in
        over) return 0 ;;
        pause)
            if [[ $k == [pP] ]]; then
                STATE=play OVL=()
                _tetris_reset_timer
            fi
            return 0 ;;
    esac
    case $k in
        left|a)   _tetris_try -1 0 0 ;;
        right|d)  _tetris_try 1 0 0 ;;
        up|w|x)   _tetris_rotate 1 ;;
        z)        _tetris_rotate -1 ;;
        down|s)
            if _tetris_try 0 1 0; then SCORE=$(( SCORE + 1 )); else _tetris_lock; fi ;;
        space)    _tetris_hard_drop ;;
        p|P)      STATE=pause; _tetris_msg 9 "PAUSED" ;;
    esac
    return 0
}

# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

# _tetris_panel Y -> REPLY: side panel text for board row Y
_tetris_panel() {
    local y=$1 r x i
    local d=$'\e[2m' b=$'\e[1m' n=$'\e[0m'
    local -a nc m
    REPLY=
    case $y in
        0) REPLY="${d}SCORE${n}" ;;
        1) REPLY="${b}${SCORE}${n}" ;;
        3) REPLY="${d}LEVEL${n}" ;;
        4) REPLY="${b}${LEVEL}${n}" ;;
        6) REPLY="${d}LINES${n}" ;;
        7) REPLY="${b}${LINES}${n}" ;;
        9) REPLY="${d}NEXT${n}" ;;
        10|11)
            r=$(( y - 10 ))
            nc=(${TT_SHAPE[NEXT*4]}) m=()
            for (( i = 0; i < 8; i += 2 )); do
                if (( nc[i+1] == r )); then x=${nc[i]}; m[x]=1; fi
            done
            for (( x = 0; x < 4; x++ )); do
                if [[ -n ${m[x]-} ]]; then REPLY+=${TT_CELL[NEXT+1]}; else REPLY+="  "; fi
            done ;;
        13) REPLY="${b}←→${n}   move" ;;
        14) REPLY="${b}↑${n}    rotate" ;;
        15) REPLY="${b}z${n}    rotate back" ;;
        16) REPLY="${b}↓${n}    soft drop" ;;
        17) REPLY="${b}spc${n}  hard drop" ;;
        18) REPLY="${b}p${n}    pause" ;;
        19) REPLY="${b}q${n}    quit" ;;
    esac
}

_tetris_draw() {
    local ox oy idx y x i v g gy line
    local -a view c

    if (( _TUI_ROWS < TT_MIN_ROWS || _TUI_COLS < TT_MIN_COLS )); then
        _tui_clear
        _tui_text 1 1 "Terminal too small (need ${TT_MIN_COLS}x${TT_MIN_ROWS})"
        return 0
    fi

    ox=$(( (_TUI_COLS - TT_WIDTH) / 2 + 1 ))
    oy=$(( (_TUI_ROWS - 1 - (BH + 2)) / 2 + 1 ))

    # Overlay the ghost and the falling piece on a copy of the board.
    view=("${BOARD[@]}")
    if [[ $STATE == pause ]]; then
        view=()                                    # hide the board while paused
    elif [[ $STATE == play ]]; then
        c=(${TT_SHAPE[CUR*4+ROT]})
        gy=$PY
        while _tetris_fits "$CUR" "$ROT" "$PX" $(( gy + 1 )); do gy=$(( gy + 1 )); done
        for (( i = 0; i < 8; i += 2 )); do
            view[(gy + c[i+1]) * BW + PX + c[i]]=$(( -(CUR + 1) ))
        done
        for (( i = 0; i < 8; i += 2 )); do
            view[(PY + c[i+1]) * BW + PX + c[i]]=$(( CUR + 1 ))
        done
    fi

    _tui_frame_begin
    for (( idx = 0; idx < BH + 2; idx++ )); do
        _tui_row_begin $(( oy + idx ))
        (( ox > 1 )) && _tui_p '\e[%dC' $(( ox - 1 ))
        if (( idx == 0 )); then
            line=$TT_TOP
        elif (( idx == BH + 1 )); then
            line=$TT_BOT
        else
            y=$(( idx - 1 ))
            if [[ -n ${OVL[y]-} ]]; then
                line="│${OVL[y]}│"
            else
                line="│"
                for (( x = 0; x < BW; x++ )); do
                    v=${view[y*BW+x]:-0}
                    if (( v > 0 )); then
                        line+=${TT_CELL[v]}
                    elif (( v < 0 )); then
                        g=$(( -v )); line+=${TT_GHOST[g]}
                    else
                        line+=$TT_EMPTY
                    fi
                done
                line+="│"
            fi
            _tetris_panel "$y"
            line+="   $REPLY"
        fi
        _tui_p '%s' "$line"
        _tui_clear_eol
        _tui_row_end
    done
    _tui_status "arrows/wasd: move  space: drop  p: pause  r: restart  q: quit"
    _tui_frame_end
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

_tetris_resize() { _tui_size; _tui_clear; }

_tetris_play() {
    local now remain t

    trap '_tui_deinit' EXIT
    trap '_tetris_resize' WINCH
    trap 'exit 130' INT TERM
    _tui_init
    _tetris_setup
    _tetris_new
    _tetris_reset_timer

    while :; do
        # With a key already waiting, skip the redraw and handle it first.
        _tui_pending || _tetris_draw

        if [[ $STATE == play ]]; then
            now=${EPOCHREALTIME//[.,]/}
            remain=$(( NEXT_FALL - now ))
            if (( remain <= 0 )); then
                _tetris_gravity
                _tetris_reset_timer
                continue
            fi
            printf -v t '%d.%06d' $(( remain / 1000000 )) $(( remain % 1000000 ))
            _tui_key "$t" || break
        else
            _tui_key || break
        fi

        [[ -z $_TUI_KEY ]] && continue            # tick or resize
        _tetris_handle || break
    done
}

_tetris_main() {
    _tetris_play
    _tui_deinit
    trap - EXIT
    printf 'Game over. Score: %d  Lines: %d  Level: %d\n' "$SCORE" "$LINES" "$LEVEL"
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    _tetris_main
fi
