#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# plugin-loader.sh - enable/disable plugins by symlinking them, built on tui.sh
#
# Layout:
#   plugins/            every plugin lives here (files or directories)
#   plugins/enabled/    symlinks to the enabled plugins
#
# Enabling   a plugin: creates  plugins/enabled/NAME -> ../NAME
# Disabling  a plugin: removes  plugins/enabled/NAME (only if it is a symlink)
#
# Usage: plugin-loader.sh [PLUGINS_DIR]
#   PLUGINS_DIR defaults to ./plugins next to this script.
#   TUI_LIB     env var overrides the path to tui.sh (default: next to this script).
#
# Keys: up/down j/k move   space/enter toggle   a enable all   d disable all
#       g/G first/last   r rescan   q/esc quit   mouse: click toggles, wheel moves

_PL_SELF=${BASH_SOURCE[0]}
_PL_HERE=$(cd -- "$(dirname -- "$_PL_SELF")" && pwd)

_PL_NAMES=()
_PL_SEL=0
_PL_TOP=0
_PL_MSG=
_PL_DIR=
_PL_ENABLED=

# ---------------------------------------------------------------------------
# Plugin operations
# ---------------------------------------------------------------------------

# Fill _PL_NAMES with everything in the plugins dir except enabled/ and dotfiles.
_pl_scan() {
    local f name
    _PL_NAMES=()
    shopt -s nullglob
    for f in "$_PL_DIR"/*; do
        name=${f##*/}
        [[ $name == enabled ]] && continue
        [[ -f $f || -d $f ]] || continue
        _PL_NAMES+=("$name")
    done
    shopt -u nullglob
    (( _PL_SEL >= ${#_PL_NAMES[@]} )) && _PL_SEL=$(( ${#_PL_NAMES[@]} - 1 ))
    (( _PL_SEL < 0 )) && _PL_SEL=0
}

# 0 = now enabled, 2 = something that is not a symlink is in the way, 1 = failed.
_pl_enable() {
    local link=$_PL_ENABLED/$1
    [[ -L $link ]] && return 0
    [[ -e $link ]] && return 2
    mkdir -p -- "$_PL_ENABLED" && ln -s -- "../$1" "$link"
}

# Only ever removes symlinks, never a real file that happens to live in enabled/.
_pl_disable() {
    local link=$_PL_ENABLED/$1
    [[ -L $link ]] || return 0
    rm -- "$link"
}

_pl_toggle() {
    local n=${_PL_NAMES[_PL_SEL]-} rc
    [[ -n $n ]] || return 0
    if [[ -L $_PL_ENABLED/$n ]]; then
        if _pl_disable "$n"; then _PL_MSG="disabled $n"; else _PL_MSG="could not disable $n"; fi
    else
        _pl_enable "$n"; rc=$?
        case $rc in
            0) _PL_MSG="enabled $n" ;;
            2) _PL_MSG="enabled/$n exists and is not a symlink, left alone" ;;
            *) _PL_MSG="could not enable $n" ;;
        esac
    fi
}

# _pl_set_all on|off
_pl_set_all() {
    local n fail=0
    for n in "${_PL_NAMES[@]}"; do
        if [[ $1 == on ]]; then _pl_enable "$n" || fail=1; else _pl_disable "$n" || fail=1; fi
    done
    if (( fail )); then
        _PL_MSG="some plugins could not be changed"
    elif [[ $1 == on ]]; then
        _PL_MSG="enabled all"
    else
        _PL_MSG="disabled all"
    fi
}

# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

# Keep the selection inside the visible list window.
_pl_clamp() {
    local h=$(( _TUI_ROWS - 3 )) count=${#_PL_NAMES[@]}
    (( h < 1 )) && h=1
    (( _PL_SEL < 0 )) && _PL_SEL=0
    (( _PL_SEL >= count )) && _PL_SEL=$(( count - 1 ))
    (( _PL_SEL < 0 )) && _PL_SEL=0
    (( _PL_SEL < _PL_TOP )) && _PL_TOP=$_PL_SEL
    (( _PL_SEL >= _PL_TOP + h )) && _PL_TOP=$(( _PL_SEL - h + 1 ))
    (( _PL_TOP > count - h )) && _PL_TOP=$(( count - h ))
    (( _PL_TOP < 0 )) && _PL_TOP=0
}

# Row 1 top border, rows 2..ROWS-2 list, row ROWS-1 bottom border, row ROWS status.
_pl_draw() {
    local count=${#_PL_NAMES[@]} inner=$(( _TUI_COLS - 2 ))
    local r i n on_count=0 sel on line pad fill t sig status

    _pl_clamp
    for n in "${_PL_NAMES[@]}"; do
        [[ -L $_PL_ENABLED/$n ]] && (( on_count++ ))
    done

    _tui_frame_begin

    # top border with title
    sig="$_TUI_COLS:top:$on_count:$count"
    if ! _tui_row_same 1 "$sig"; then
        t=" plugins ${on_count}/${count} enabled "
        fill=$(( _TUI_COLS - 3 - ${#t} ))
        (( fill < 0 )) && fill=0
        _tui_repeat "$fill" '─'
        _tui_row_begin 1
        _tui_fg 39; _tui_p '┌─%s%s┐' "$t" "$REPLY"; _tui_reset
        _tui_row_end
    fi

    # list rows
    for (( r = 2; r <= _TUI_ROWS - 2; r++ )); do
        i=$(( _PL_TOP + r - 2 ))
        sel=0 on=0 line=
        if (( i < count )); then
            n=${_PL_NAMES[i]}
            if [[ -L $_PL_ENABLED/$n ]]; then on=1; line=" [x] $n"; else line=" [ ] $n"; fi
            (( i == _PL_SEL )) && sel=1
        elif (( count == 0 && r == 2 )); then
            line=" no plugins found in $_PL_DIR"
        fi
        sig="$_TUI_COLS:$sel:$on:$line"
        _tui_row_same "$r" "$sig" && continue

        line=${line:0:inner}
        _tui_repeat $(( inner - ${#line} )) ' '
        pad=$REPLY

        _tui_row_begin "$r"
        _tui_fg 39; _tui_p '│'; _tui_reset
        if (( sel )); then _tui_reverse; elif (( on )); then _tui_fg 82; fi
        _tui_p '%s%s' "$line" "$pad"
        _tui_reset
        _tui_fg 39; _tui_text "$r" "$_TUI_COLS" '│'; _tui_reset
        _tui_row_end
    done

    # bottom border
    r=$(( _TUI_ROWS - 1 ))
    if ! _tui_row_same "$r" "$_TUI_COLS:bottom"; then
        _tui_repeat $(( _TUI_COLS - 2 )) '─'
        _tui_row_begin "$r"
        _tui_fg 39; _tui_p '└%s┘' "$REPLY"; _tui_reset
        _tui_row_end
    fi

    status="space: toggle  a: all on  d: all off  r: rescan  q: quit"
    [[ -n $_PL_MSG ]] && status="$_PL_MSG  |  $status"
    _tui_status "$status"

    _tui_frame_end
}

# ---------------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------------

_pl_move() {
    local count=${#_PL_NAMES[@]}
    _PL_SEL=$(( _PL_SEL + $1 ))
    (( _PL_SEL >= count )) && _PL_SEL=$(( count - 1 ))
    (( _PL_SEL < 0 )) && _PL_SEL=0
}

_pl_main() {
    local resized=0 i

    _PL_DIR=${1:-$_PL_HERE/plugins}
    _PL_DIR=${_PL_DIR%/}
    _PL_ENABLED=$_PL_DIR/enabled

    if [[ ! -d $_PL_DIR ]]; then
        printf 'plugin-loader: no such directory: %s\n' "$_PL_DIR" >&2
        return 1
    fi

    _pl_scan

    trap '_tui_deinit' EXIT
    trap 'exit 130' INT TERM
    trap 'resized=1' WINCH
    _tui_init
    _tui_mouse_on

    while :; do
        if (( resized )); then
            resized=0
            _tui_size
            _tui_clear
        fi

        # a key is already waiting: handle it before drawing
        _tui_pending || _pl_draw
        _tui_key || break
        [[ -n $_TUI_KEY ]] && _PL_MSG=

        case $_TUI_KEY in
            up|k)          _pl_move -1 ;;
            down|j)        _pl_move 1 ;;
            wheelup)       _pl_move -3 ;;
            wheeldown)     _pl_move 3 ;;
            g)             _PL_SEL=0 ;;
            G)             _pl_move "${#_PL_NAMES[@]}" ;;
            space|enter)   _pl_toggle ;;
            a)             _pl_set_all on ;;
            d)             _pl_set_all off ;;
            r)             _pl_scan; _tui_forget_sigs; _PL_MSG="rescanned" ;;
            click)
                i=$(( _PL_TOP + _TUI_MY - 2 ))
                if (( _TUI_MY >= 2 && _TUI_MY <= _TUI_ROWS - 2 && i < ${#_PL_NAMES[@]} )); then
                    _PL_SEL=$i
                    _pl_toggle
                fi
                ;;
            q|esc)         break ;;
        esac
    done
}

# ---------------------------------------------------------------------------
# Entry point (only when executed, never when sourced)
# ---------------------------------------------------------------------------

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    # _PL_TUI=${TUI_LIB:-$_PL_HERE/tui.sh}
    # if [[ ! -r $_PL_TUI ]]; then
    #     printf 'plugin-loader: cannot find tui.sh at %s (set TUI_LIB)\n' "$_PL_TUI" >&2
    #     exit 1
    # fi
    # # shellcheck source=/dev/null
    # source "$_PL_TUI"
    _pl_main "$@"
fi
