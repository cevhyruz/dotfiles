#!/usr/bin/env bash
# dotfiles-doctor.sh - check (and repair) a GNU Stow style dotfiles repo
#
# Every top-level directory in the repo is a package whose files mirror the
# target (default $HOME). The doctor compares each file with what is actually
# there and reports:
#   OK        target is the repo file (through a link, or a folded dir link)
#   MISSING   nothing at the target path yet
#   BROKEN    a dead symlink sits at the target path
#   CONFLICT  a real file/dir is in the way (stow would refuse)
#   WRONG     a symlink there points somewhere else
#   ORPHAN    a dead symlink into the repo, left over from a removed/renamed file
# It also checks that stow is installed and whether the repo has uncommitted work.
#
# The interface opens immediately and the scan runs in the background. On the
# first scan, files appear in the list as they are discovered (package by package);
# the counts grow while it runs. Rescans (r, or after a fix) keep the old list on
# screen until the new result is complete, so the list never flickers or shrinks.
#
# Usage: dotfiles-doctor.sh [-d REPO] [-t TARGET] [-p PKG]... [-x PKG]... [-m PKG=DIR]... [-c]
#   -d REPO     repo path (default: $DOTFILES, ~/.dotfiles, then ~/dotfiles)
#   -t TARGET   where packages are linked (default: $HOME)
#   -p PKG      only check this package (repeatable)
#   -x PKG      skip this package (repeatable); dirs starting with "_" are always skipped
#   -m PKG=DIR  link this package into DIR instead (default: config=$XDG_CONFIG_HOME)
#   -c          non-interactive report, exit 1 if anything is wrong
#
# Command line (: or !): the command runs in the repo directory and gets the
#   highlighted file as {} (the repo file; for an ORPHAN the dead link), {t} for the
#   target path, and $SRC $TGT $PKG in its environment. With no placeholder the repo
#   file is appended: "bat" -> bat '<file>' (end with ; to run without the file). Up/down browse history, kept in
#   $XDG_STATE_HOME/dotfiles-doctor/history. The list is rescanned afterwards.
#
# Keys: j/k move   a show all/issues only   f fix item   F fix all MISSING
#       r rescan   q quit
#       numbers: n toggles absolute / relative (vim-style) line numbers;
#       type a count first for vim-style motions: 5j / 5k move 5 rows,
#       12G, 12g or 12<enter> jump to line 12, esc cancels a pending count.
#       While a count is pending, every visible line number that starts with the
#       typed digits is highlighted (an exact match is underlined) and gets a letter
#       label, like vim easymotion: press the letter to jump straight to that row
#       H / M / L jump to the top / middle / bottom row of the visible window
#       (not the list); 3H and 3L mean 3rd row from the top / bottom
#       / search: filter the list live (space separated terms are ANDed and match
#       status, package and path, e.g. "missing config"); the selection stays on the
#       same file (or the next one that still matches); enter keeps the filter,
#       esc while typing restores the old one and the old position, esc afterwards
#       clears it
#       : or ! run a shell command on the highlighted file, see below
#       ctrl-k info popup, drawn right below the highlighted row (below the row
#       above it if there is no room): status, package, source and target, what is at
#       the target now and what f would do. ctrl-k or esc closes it. Any other key
#       closes it and is then handled as usual, so j/k, clicks, the wheel and the
#       rest keep working while it is open.
#       ? or ctrl-/ help popup listing all keybindings, centered. Like the info popup it is
#       not modal: navigation keys (j/k, g/G, H/M/L, counts, ctrl-e/ctrl-y, the wheel) close
#       it and are then handled as usual; any other key only closes it (and is swallowed,
#       so q does not quit while help is open)
#       ctrl-e / ctrl-y scroll the view 5 rows (3^E = three rows) and only move the
#       selection if it would leave the window
#       marks: space marks/unmarks the highlighted file, the selection stays put
#       (3<space> toggles the highlighted file and the two below it); A marks everything in view, I inverts, C clears all; clicking a
#       [ ] box toggles it. With marks, f fixes every marked file in view (one
#       confirmation) and : runs the command on each marked file
#       mouse: click a row to select it; the wheel scrolls the view 5 rows per notch,
#       exactly like ctrl-e / ctrl-y; m toggles the mouse
#       (turn it off to select text with the terminal, or hold shift)
#       scrollbar: the right-most column of the list shows where the view is (only when
#       the list is longer than the window); click it to jump there, or drag the thumb
#       f, F and : are ignored while a scan is still running.
#       p groups the list by package: each package gets a header row with its file count and
#       status counts. tab or enter (or a click on the arrow) on a header or any of its files
#       folds / unfolds that package, z folds all / unfolds all, space on a header marks the
#       whole package (it has to be unfolded). Folds are ignored while a filter is active


_here=${BASH_SOURCE[0]%/*}; [[ $_here == "${BASH_SOURCE[0]}" ]] && _here=.
source "$_TUI_SOURCEPATH"

# Mouse reporting with drag support (overrides the library's): mode 1002 also reports
# motion while a button is held, and the parser hands out "drag" and "release" keys
# (the library swallows both). The loop only acts on them while the scrollbar is held.
_tui_mouse_on()  { printf '\e[?1000h\e[?1002h\e[?1006h'; }
_tui_mouse_off() { printf '\e[?1006l\e[?1002l\e[?1000l'; }
_tui_mouse_parse() {
    local c buf= final body b x y
    _TUI_KEY=
    while IFS= read -rsn1 -t 0.05 c; do
        buf+=$c
        [[ $c == [Mm] ]] && break
    done
    final=${buf: -1} body=${buf%?}
    [[ $final == [Mm] ]] || return 0
    [[ $body =~ ^[0-9]+\;[0-9]+\;[0-9]+$ ]] || return 0
    IFS=';' read -r b x y <<<"$body"
    _TUI_MX=$x _TUI_MY=$y
    if [[ $final == m ]]; then _TUI_KEY=release; return 0; fi
    if (( b & 32 )); then (( (b & 3) == 0 )) && _TUI_KEY=drag; return 0; fi
    case $(( b & 67 )) in
        0)  _TUI_KEY=click ;;
        1)  _TUI_KEY=mclick ;;
        2)  _TUI_KEY=rclick ;;
        64) _TUI_KEY=wheelup ;;
        65) _TUI_KEY=wheeldown ;;
    esac
    return 0
}

shopt -s extglob

sel_bg=24
repo= target=$HOME check=0
only=() skip=() pkgs=()
declare -A map=() cnt=() marked=()
mv=()
declare -A gcnt=() folded=()     # per-package counts ("pkg|" total, "pkg|STATUS"), folded packages
grp_name=() grp_sig=() GS=       # package of each header row, its counts, summary text
it_pkg=() it_rel=() it_src=() it_tgt=() it_st=() view=()
sel=0 top=0 show_all=0 MSG= num_mode=0 cnt= mouse=1 query= LINE= group=0
cmd_hist=() hist_file=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-doctor/history
env_stow= env_git= git_dirty=0 stow_ok=0

# draw caches: per-item rendered cells (status/package/path), the detail text of
# the selected item, and the color of each status
lab_chars=asdfhlqweruiopzxcvbnmty     # easymotion labels: no g j k, they are motions
declare -A lab_at=() lab_row=()     # label -> view index, view index -> label
declare -A st_col=([OK]=82 [MISSING]=220 [BROKEN]=196 [WRONG]=208 [CONFLICT]=201 [ORPHAN]=245)
cells=() cells_w=-1 d_i= d_now= drawn_top=0
scroll_step=5      # rows per ctrl-e / ctrl-y / wheel notch
resized=0          # set by the WINCH trap; draw() resizes and repaints on its next call
# bash restarts a blocking read after SIGWINCH, so the trap only runs when a read
# returns. Every key wait therefore uses this timeout (seconds) and resizes are seen
# within one tick, with no polling forks.
resize_tick=0.1
sb_on=0 sb_len=0 sb_pos=0 sb_rows=3 sb_grab=0 sb_drag=0   # scrollbar geometry and drag state
anchor=-1 anchor_rel=0 PROMPT=   # selection kept across filter changes; text of an active prompt

# info popup (ctrl-k). popup=1 while it is open. PL holds its "label|value" lines, built
# by popup_prepare and cached under pop_key. pop_r0/pop_h/pop_c0/pop_w is the box wanted
# for this frame (pop_h=0: none), pop_d* is the box that is actually on screen, so draw()
# knows which rows to repaint when the popup moves or closes.
popup=0 pop_key= PL=() pop_bg=235
pop_r0=0 pop_h=0 pop_c0=0 pop_w=0
pop_dr0=0 pop_dh=0 pop_dc0=0 pop_dw=0

# help popup (? / ctrl-/). Same idea as the info popup: pure state, painted by draw().
# hlp_* is the box wanted this frame, hlp_d* the box on screen.
help=0 
hlp_r0=0 hlp_h=0 hlp_c0=0 hlp_w=0
hlp_dr0=0 hlp_dh=0 hlp_dc0=0 hlp_dw=0
# "key|description" lines; a key of "#" makes the line a section title
HL=(
    ""
    "#|Move"
    ""
    " j k up down|move a row; 5j / 5k move 5 rows"
    " g G|first / last row; 12G, 12g, 12<enter> go to line 12"
    " H M L|top / middle / bottom of the window; 3H, 3L"
    " ^E ^Y wheel|scroll the view 5 rows (3^E = 3 rows)"
    " digits|start a count; matching line numbers get a jump letter"
    " n|toggle absolute / relative line numbers"
    ""
    "#|Filter"
    ""
    " /|live filter, terms are ANDed (e.g. missing config)"
    " a|show all files / issues only"
    " esc|clear the pending count, then the filter"
    ""
    "#|Marks"
    ""
    " space|mark file; on a header the whole package; 3<space>"
    " A I C|mark all in view / invert / clear marks"
    " click [ ]|toggle the mark with the mouse"
    ""
    "#|Actions"
    ""
    " f|fix highlighted file (or all marked files)"
    " F|fix all MISSING"
    " r|rescan"
    " : !|run a command; {} {t} \$SRC \$TGT \$PKG available"
    ""
    "#|Packages"
    ""
    " p|group the list by package (header rows)"
    " tab enter|fold / unfold the package of the row"
    " z|fold all / unfold all"
    ""
    "#|Other"
    ""
    " ^K|info popup for the highlighted file"
    "? ^/|this help; navigation keys close it and still work"
    " m|toggle mouse (off: terminal text selection)"
    " q|quit"
)

# background scan state: scanning=1 while a worker runs, loaded=1 once the environment
# record (or the end of a scan) has been seen (before that the environment row shows a
# placeholder). The first scan streams into the live list: scan_fd is the open read end
# of the growing output file, scan_part holds a partly read field and scan_rec the
# fields of the record being assembled.
scanning=0 loaded=0 scan_pid= scan_dir= scan_out= scan_done= scan_gen=0
scan_fd= scan_part= scan_rec=() scan_stream=0

usage() {
    sed -n '/^# Usage:/,/^# *-c /p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//' >&2
    exit "${1:-2}"
}
die() { printf '%s: %s\n' "${0##*/}" "$*" >&2; exit 2; }

tilde() { REPLY=${1/#"$HOME"/\~}; }

# ---------------------------------------------------------------------------
# Scanning
# ---------------------------------------------------------------------------

# classify SRC TGT -> ST
classify() {
    if [[ $2 -ef $1 ]]; then ST=OK
    elif [[ -L $2 ]]; then
        if [[ -e $2 ]]; then ST=WRONG; else ST=BROKEN; fi
    elif [[ -e $2 ]]; then ST=CONFLICT
    else ST=MISSING
    fi
}

# files stow would ignore by default
ignored() {
    local rel=$1 b=${1##*/}
    case $b in *'~'|'#'*'#'|'.#'*) return 0 ;; esac
    [[ $rel == */* ]] && return 1
    case $b in
        README*|LICENSE*|COPYING|.gitignore|.gitmodules|.gitattributes|.stow-local-ignore) return 0 ;;
    esac
    return 1
}

add() {
    local k
    it_pkg+=("$1") it_rel+=("$2") it_src+=("$3") it_tgt+=("$4") it_st+=("$5")
    cnt[$5]=$(( ${cnt[$5]:-0} + 1 ))
    k="$1|";   gcnt[$k]=$(( ${gcnt[$k]:-0} + 1 ))
    k="$1|$5"; gcnt[$k]=$(( ${gcnt[$k]:-0} + 1 ))
}

# scan_worker: does the slow part (find, classify, dead links, git status) and
# prints the result to stdout as NUL separated fields, in tagged records:
#   I pkg rel src tgt status      one item (6 fields), printed as soon as it is classified
#   E stow_ok stow_txt git_dirty git_txt   the environment (5 fields), printed last
# Runs in a background subshell; never touches the interface.
scan_worker() {
    local p tdir rel src tgt d l real
    local -A known=() dirs=()

    for p in "${pkgs[@]}"; do
        tdir=${map[$p]:-$target}
        while IFS= read -rd '' rel; do
            ignored "$rel" && continue
            src=$repo/$p/$rel tgt=$tdir/$rel
            classify "$src" "$tgt"
            printf '%s\0' I "$p" "$rel" "$src" "$tgt" "$ST"
            known[$tgt]=1
            dirs[${tgt%/*}]=1
        done < <(find "$repo/$p" -name .git -prune -o \( -type f -o -type l \) -printf '%P\0')
    done

    # dead links into the repo, next to the files we manage
    shopt -s nullglob dotglob
    for d in "${!dirs[@]}"; do
        [[ -d $d ]] || continue
        for l in "$d"/*; do
            [[ -L $l && ! -e $l && -z ${known[$l]:-} ]] || continue
            real=$(readlink -f -- "$l")
            [[ $real == "$repo"/* ]] || continue
            tilde "$l"
            printf '%s\0' I "-" "$REPLY" "" "$l" ORPHAN
        done
    done
    shopt -u nullglob dotglob

    # environment
    local s_ok s_txt g_dirty g_txt
    if command -v stow >/dev/null 2>&1; then s_ok=1 s_txt="stow installed"
    else s_ok=0 s_txt="stow not installed"; fi
    if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local -a gs
        mapfile -t gs < <(git -C "$repo" status --porcelain 2>/dev/null)
        g_dirty=${#gs[@]}
        if (( g_dirty )); then g_txt="git: $g_dirty uncommitted change(s)"; else g_txt="git: clean"; fi
    else
        g_dirty=0 g_txt="git: not a repository"
    fi
    printf '%s\0' E "$s_ok" "$s_txt" "$g_dirty" "$g_txt"
}

scan_clear() { it_pkg=() it_rel=() it_src=() it_tgt=() it_st=() cnt=() gcnt=(); }

scan_close() { [[ -n $scan_fd ]] && { exec {scan_fd}<&-; scan_fd=; }; return 0; }

# scan_drain FD: read what the worker has written so far and apply every complete
# record (a partial trailing field is kept in scan_part until the rest arrives).
# Returns 0 if anything was added.
scan_drain() {
    local f rc need changed=1
    while :; do
        IFS= read -r -d '' -u "$1" f; rc=$?
        if (( rc )); then scan_part+=$f; break; fi       # EOF for now: keep the partial field
        scan_rec+=("$scan_part$f"); scan_part=
        case ${scan_rec[0]} in I) need=6 ;; E) need=5 ;; *) need=1 ;; esac
        (( ${#scan_rec[@]} < need )) && continue
        case ${scan_rec[0]} in
            I) add "${scan_rec[@]:1:5}"; changed=0 ;;
            E) stow_ok=${scan_rec[1]} env_stow=${scan_rec[2]}
               git_dirty=${scan_rec[3]} env_git=${scan_rec[4]}
               loaded=1; changed=0 ;;
        esac
        scan_rec=()
    done
    return $changed
}

# scan_load FILE: replace the lists with the complete output of a finished worker.
scan_load() {
    local fd k
    exec {fd}<"$1" || return 1
    scan_clear; scan_part= scan_rec=()
    scan_drain "$fd"
    exec {fd}<&-
    cells=() d_i=; _tui_forget_sigs

    # forget marks whose item no longer exists
    local -A present=()
    for k in "${it_tgt[@]}"; do present[$k]=1; done
    for k in "${!marked[@]}"; do [[ -n ${present[$k]:-} ]] || unset 'marked[$k]'; done
    return 0
}

# scan_sync: blocking scan, for the plain report
scan_sync() { local t; t=$(mktemp) || return 1; scan_worker >"$t"; scan_load "$t"; rm -f -- "$t"; }

# scan_cancel: stop a running background scan
scan_cancel() {
    scan_close
    (( scanning )) || return 0
    pkill -P "$scan_pid" 2>/dev/null
    kill "$scan_pid" 2>/dev/null
    wait "$scan_pid" 2>/dev/null
    scanning=0
}

# scan_start: (re)start the scan in the background and return immediately. The first
# scan streams into the live list; later scans keep the current lists until poll_scan
# loads the finished result.
scan_start() {
    scan_cancel
    scan_out=$scan_dir/out.$(( ++scan_gen )) scan_done=$scan_dir/out.$scan_gen.done
    scan_stream=$(( ! loaded ))
    if (( scan_stream )); then
        scan_clear; scan_part= scan_rec=(); cells=() d_i=; _tui_forget_sigs
        : >"$scan_out"; exec {scan_fd}<"$scan_out"
    fi
    scanning=1
    (
        trap - EXIT WINCH
        scan_worker >"$scan_out"
        : >"$scan_done"
    ) </dev/null 2>/dev/null &
    scan_pid=$!
}

# poll_scan: pick up new output (streaming) or the finished result (rescan).
# Returns 0 when the lists changed, in which case the view has been rebuilt.
poll_scan() {
    (( scanning )) || return 1
    local fin=0 got=1
    [[ -e $scan_done ]] && fin=1              # check first, so the last bytes are not missed
    if (( scan_stream )); then
        scan_drain "$scan_fd" && got=0
    elif (( fin )); then
        scan_load "$scan_out"; got=0
    fi
    if (( fin )); then
        wait "$scan_pid" 2>/dev/null
        scanning=0 loaded=1; scan_close
        rm -f -- "$scan_out" "$scan_done"
        got=0
    fi
    (( got )) || build_view
    return $got
}

# scroll_view N: scroll the view N rows down (negative: up). The selection stays where
# it is unless it would leave the window, then it is pulled to the nearest edge row
# (vim's ctrl-e / ctrl-y).
scroll_view() {
    local lr=$(( _TUI_ROWS - 10 )) n=${#view[@]}
    (( lr < 3 )) && lr=3
    top=$(( top + $1 ))
    (( top > n - lr )) && top=$(( n - lr ))
    (( top < 0 )) && top=0
    (( sel < top )) && sel=$top
    (( sel >= top + lr )) && sel=$(( top + lr - 1 ))
    return 0
}

build_view() {
    local i t hay p k st s lastp=
    local -a terms=()
    view=() grp_name=() grp_sig=()
    [[ -n $query ]] && read -ra terms <<<"${query,,}"
    for i in "${!it_st[@]}"; do
        if (( ! show_all )) && [[ ${it_st[i]} == OK ]]; then continue; fi
        if (( ${#terms[@]} )); then
            hay="${it_st[i]} ${it_pkg[i]} ${it_rel[i]} ${it_tgt[i]}"; hay=${hay,,}
            for t in "${terms[@]}"; do [[ $hay == *"$t"* ]] || continue 2; done
        fi
        if (( group )); then
            p=${it_pkg[i]}
            if [[ $p != "$lastp" ]]; then          # first visible file of a package: header row
                lastp=$p
                view+=("$(( -1 - ${#grp_name[@]} ))")
                grp_name+=("$p")
                k="$p|"; s=${gcnt[$k]:-0}
                for st in OK MISSING BROKEN WRONG CONFLICT ORPHAN; do k="$p|$st"; s+=" ${gcnt[$k]:-0}"; done
                grp_sig+=("$s")
            fi
            [[ -z $query && -n ${folded[$p]-} ]] && continue
        fi
        view+=("$i")
    done
    (( sel >= ${#view[@]} )) && sel=$(( ${#view[@]} - 1 ))
    (( sel < 0 )) && sel=0
    return 0
}

# reselect ITEM: put the selection on ITEM, or on the next visible item after it
# (the last one if there is none). The view is in item order.
reselect() {
    local i
    for i in "${!view[@]}"; do
        (( view[i] >= $1 )) && { sel=$i; return 0; }
    done
    sel=$(( ${#view[@]} - 1 )); (( sel < 0 )) && sel=0
    return 0
}

# rebuild_keep [KEEP]: rebuild the view after the filter changed (set query or show_all
# first) without the selection jumping: it stays on the same item, on the same screen
# row, or moves to the next item that still matches. KEEP=1 remembers the last item
# seen across an empty result (used while typing a search).
rebuild_keep() {
    local j
    (( ${1:-0} )) || anchor=-1
    if (( ${#view[@]} )); then
        anchor=${view[sel]} anchor_rel=$(( sel - top ))
        if (( anchor < 0 )); then                  # on a header: anchor to its first file
            anchor=-1
            for (( j = sel + 1; j < ${#view[@]}; j++ )); do
                (( view[j] >= 0 )) && { anchor=${view[j]}; break; }
            done
        fi
    fi
    build_view
    if (( anchor >= 0 )); then reselect "$anchor"; top=$(( sel - anchor_rel )); else sel=0 top=0; fi
}

issues() { local n=${#it_st[@]}; echo $(( n - ${cnt[OK]:-0} )); }

# ---------------------------------------------------------------------------
# Fixing
# ---------------------------------------------------------------------------

# mklink SRC TGT: relative symlink, like stow makes
mklink() {
    local rel
    rel=$(realpath -m --relative-to="${2%/*}" "${1%/*}")/${1##*/}
    mkdir -p -- "${2%/*}" && ln -s -- "$rel" "$2"
}

confirm() {
    _tui_status "$1 [y/N]"
    while :; do
        _tui_key $resize_tick || return 1
        case $_TUI_KEY in
            '') if (( resized )); then draw; _tui_status "$1 [y/N]"; fi; continue ;;
            click|rclick|mclick|wheelup|wheeldown|drag|release) continue ;;
        esac
        break
    done
    [[ $_TUI_KEY == y ]]
}

# read_line LABEL INITIAL [HIST] [CALLBACK]
# One-line editor on the status row. Sets LINE, returns 1 if cancelled.
# HIST non-empty: up/down browse command history. CALLBACK is called with the
# buffer after every change (used for live search). While a scan is running the
# editor wakes up every 100 ms so new results are loaded as soon as they are ready.
read_line() {
    local label=$1 buf=$2 hist=${3:-} cb=${4:-} hi=${#cmd_hist[@]} room disp to
    local seen=0 lastbuf=
    LINE=
    while :; do
        (( scanning )) && poll_scan && seen=0
        # PROMPT is what draw() puts on the status row instead of the key hints, so
        # the prompt is written once per change and the hints never flash in between
        room=$(( _TUI_COLS - ${#label} - 3 ))
        disp=$buf; (( ${#disp} > room )) && disp=${disp: -room}
        PROMPT="${label}${disp}_"
        (( resized )) && draw
        if [[ -n $cb ]] && { (( ! seen )) || [[ $buf != "$lastbuf" ]]; }; then
            "$cb" "$buf"; seen=1 lastbuf=$buf
        fi
        _tui_status "$PROMPT"
        to=$resize_tick; (( scanning )) && to=0.03
        _tui_key $to || { PROMPT=; return 1; }
        case $_TUI_KEY in
            enter)         LINE=$buf; PROMPT=; return 0 ;;
            esc)           PROMPT=; return 1 ;;
            $'\177'|$'\b') buf=${buf%?} ;;
            $'\025')       buf= ;;                                   # ctrl-u
            $'\027')       buf=${buf%%+([[:space:]])}; buf=${buf%%+([^[:space:]])} ;;  # ctrl-w
            up)   if [[ -n $hist ]] && (( hi > 0 )); then (( hi-- )); buf=${cmd_hist[hi]}; fi ;;
            down) if [[ -n $hist ]]; then
                      if (( hi < ${#cmd_hist[@]} - 1 )); then (( hi++ )); buf=${cmd_hist[hi]}
                      else hi=${#cmd_hist[@]}; buf=; fi
                  fi ;;
            space)         buf+=' ' ;;
            '')            ;;
            $'\t'|click|rclick|mclick|wheelup|wheeldown|drag|release) ;;
            *)             (( ${#_TUI_KEY} == 1 )) && buf+=$_TUI_KEY ;;
        esac
    done
}

search_cb() { query=$1; rebuild_keep 1; draw; }

# run_command IDX: prompt for a command and run it on the marked files in view,
# or on IDX when nothing is marked
run_command() {
    local i c run p rc fails=0 label="! "
    local -a targets=("$1")
    get_marked
    if (( ${#mv[@]} )); then targets=("${mv[@]}"); label="! (${#mv[@]} marked) "; fi
    MSG="{} = repo file   {t} = target   \$SRC \$TGT \$PKG   (no placeholder: file is appended)"
    PROMPT="${label}_"
    draw
    read_line "$label" "" 1 || { MSG="cancelled"; return 0; }
    c=$LINE
    [[ -z ${c//[[:space:]]/} ]] && return 0

    if [[ ${cmd_hist[-1]:-} != "$c" ]]; then
        cmd_hist+=("$c")
        mkdir -p -- "${hist_file%/*}" && printf '%s\n' "$c" >>"$hist_file"
    fi

    run=$c
    for p in '{}' '{s}' '{t}'; do run=${run//\"$p\"/$p}; run=${run//\'$p\'/$p}; done
    if [[ $c != *'{}'* && $c != *'{s}'* && $c != *'{t}'* && $c != *'$SRC'* && $c != *'$TGT'* \
          && $c != *'${SRC}'* && $c != *'${TGT}'* && $c != *\; ]]; then
        run+=' "$SRC"'
    fi
    run=${run//\{\}/\"\$SRC\"}; run=${run//\{s\}/\"\$SRC\"}; run=${run//\{t\}/\"\$TGT\"}

    printf '\e[?1002l'
    _tui_deinit
    printf '\n'
    for i in "${targets[@]}"; do
        (( ${#targets[@]} > 1 )) && printf '\e[1m==> %s <==\e[0m\n' "${it_tgt[i]}"
        ( cd -- "$repo" && SRC=${it_src[i]:-${it_tgt[i]}} TGT=${it_tgt[i]} PKG=${it_pkg[i]} bash -c "$run" )
        rc=$?; (( rc )) && (( fails++ ))
    done
    if (( ${#targets[@]} > 1 )); then printf '\n[%d file(s), %d failed] press any key to return ' "${#targets[@]}" "$fails"
    else printf '\n[exit %d] press any key to return ' "$rc"; fi
    IFS= read -rsn1 _
    _tui_init
    (( mouse )) && _tui_mouse_on
    scan_start; build_view
    if (( ${#targets[@]} > 1 )); then MSG="ran on ${#targets[@]} files (${fails} failed): ${c:0:40}"
    else MSG="ran: ${c:0:50} (exit $rc)"; fi
}

is_marked()   { [[ -n ${marked[${it_tgt[$1]}]:-} ]]; }
toggle_mark() { if is_marked "$1"; then unset 'marked[${it_tgt[$1]}]'; else marked[${it_tgt[$1]}]=1; fi; }
# get_marked: indices of marked items that are in the current view -> mv
get_marked()  {
  local i
  mv=()
  for i in "${view[@]}"; do
    (( i >= 0 )) && is_marked "$i" && mv+=("$i");
  done;
}

# select_group PKG: put the selection on the header row of PKG
select_group() {
    local i
    for i in "${!view[@]}"; do
        (( view[i] < 0 )) || continue
        [[ ${grp_name[-1 - view[i]]} == "$1" ]] && { sel=$i; return 0; }
    done
    return 0
}

# fold_toggle: fold / unfold the package of the selected row; the selection ends on its header
fold_toggle() {
    local v p
    (( group )) || { MSG="grouping is off (p turns it on)"; return 0; }
    (( ${#view[@]} )) || return 0
    [[ -n $query ]] && { MSG="folding is off while a filter is active"; return 0; }
    v=${view[sel]}
    if (( v < 0 )); then p=${grp_name[-1 - v]}; else p=${it_pkg[v]}; fi
    if [[ -n ${folded[$p]-} ]]; then unset 'folded[$p]'; else folded[$p]=1; fi
    build_view; select_group "$p"
}

# fold_all: fold every package, or unfold all when everything is already folded
fold_all() {
    local v k cur any=0
    (( group )) || { MSG="grouping is off (p turns it on)"; return 0; }
    (( ${#view[@]} )) || return 0
    [[ -n $query ]] && { MSG="folding is off while a filter is active"; return 0; }
    v=${view[sel]}
    if (( v < 0 )); then cur=${grp_name[-1 - v]}; else cur=${it_pkg[v]}; fi
    for k in "${grp_name[@]}"; do [[ -n ${folded[$k]-} ]] || { any=1; break; }; done
    for k in "${grp_name[@]}"; do
        if (( any )); then folded[$k]=1; else unset 'folded[$k]'; fi
    done
    build_view; select_group "$cur"
}

# toggle_group VIDX: mark every file under the header at view index VIDX, or unmark if all are marked
toggle_group() {
    local h=$1 j i t n=${#view[@]} all=1 g=$(( -1 - ${view[$1]} ))
    if [[ -z $query && -n ${folded[${grp_name[g]}]-} ]]; then
        MSG="unfold it first (tab), so you can see what gets marked"; return 0
    fi
    for (( j = h + 1; j < n && view[j] >= 0; j++ )); do
        is_marked "${view[j]}" || { all=0; break; }
    done
    for (( j = h + 1; j < n && view[j] >= 0; j++ )); do
        i=${view[j]} t=${it_tgt[i]}
        if (( all )); then unset 'marked[$t]'; else marked[$t]=1; fi
    done
}

# apply_fix IDX: repair one item without asking. Returns 1 on failure.
apply_fix() {
    local st=${it_st[$1]} src=${it_src[$1]} tgt=${it_tgt[$1]}
    case $st in
        MISSING)      mklink "$src" "$tgt" ;;
        BROKEN|WRONG) rm -- "$tgt" && mklink "$src" "$tgt" ;;
        CONFLICT)     [[ -e $tgt.bak || -L $tgt.bak ]] && return 1
                      mv -- "$tgt" "$tgt.bak" && mklink "$src" "$tgt" ;;
        ORPHAN)       rm -- "$tgt" ;;
        *)            return 0 ;;
    esac
}

fix_item() {
    local i=$1 st=${it_st[$1]} tgt=${it_tgt[$1]} name=${it_tgt[$1]##*/} verb
    case $st in
        OK)       MSG="$name is already fine"; return ;;
        MISSING)  verb="linked" ;;
        BROKEN|WRONG)
            confirm "replace the link at $name?" || { MSG="skipped"; return; }
            verb="relinked" ;;
        CONFLICT)
            confirm "move $name to $name.bak and link it?" || { MSG="skipped"; return; }
            if [[ -e $tgt.bak || -L $tgt.bak ]]; then MSG="$name.bak already exists, not touching anything"; return; fi
            verb="backed up and linked" ;;
        ORPHAN)
            confirm "remove the dead link $name?" || { MSG="skipped"; return; }
            verb="removed" ;;
    esac
    if apply_fix "$i"; then MSG="$verb $name"; unset 'marked[$tgt]'; else MSG="could not fix $name"; fi
    scan_start; build_view
}

# fix_marked: repair every marked file in the view after one confirmation
fix_marked() {
    local i nl=0 nr=0 nb=0 nd=0 tot ok=0 bad=0 parts=
    get_marked
    for i in "${mv[@]}"; do
        case ${it_st[i]} in
            MISSING) (( nl++ )) ;;
            BROKEN|WRONG) (( nr++ )) ;;
            CONFLICT) (( nb++ )) ;;
            ORPHAN) (( nd++ )) ;;
        esac
    done
    tot=$(( nl + nr + nb + nd ))
    (( tot )) || { MSG="the marked files need no fixing"; return; }
    (( nl )) && parts+="link $nl, "
    (( nr )) && parts+="replace $nr, "
    (( nb )) && parts+="back up $nb, "
    (( nd )) && parts+="remove $nd, "
    confirm "fix $tot marked (${parts%, })?" || { MSG="skipped"; return; }
    for i in "${mv[@]}"; do
        [[ ${it_st[i]} == OK ]] && continue
        if apply_fix "$i"; then (( ok++ )); unset 'marked[${it_tgt[i]}]'; else (( bad++ )); fi
    done
    MSG="fixed $ok of $tot"; (( bad )) && MSG+=", $bad failed (a .bak already exists?)"
    scan_start; build_view
}

fix_missing() {
    local i n=0
    for i in "${!it_st[@]}"; do
        [[ ${it_st[i]} == MISSING ]] || continue
        mklink "${it_src[i]}" "${it_tgt[i]}" && (( n++ ))
    done
    MSG="created $n link(s)"
    scan_start; build_view
}

# ---------------------------------------------------------------------------
# Drawing
# ---------------------------------------------------------------------------

st_color() {
    case $1 in
        OK)       _tui_fg 82 ;;
        MISSING)  _tui_fg 220 ;;
        BROKEN)   _tui_fg 196 ;;
        WRONG)    _tui_fg 208 ;;
        CONFLICT) _tui_fg 201 ;;
        ORPHAN)   _tui_fg 245 ;;
    esac
}

# sb_calc: scrollbar geometry for the current view, in rows of the list window:
# thumb length sb_len and thumb offset sb_pos. Only on when the list is longer than the window.
sb_calc() {
    local rows=$(( _TUI_ROWS - 10 )) n=${#view[@]}
    (( rows < 3 )) && rows=3
    sb_rows=$rows
    if (( n > rows )); then
        sb_on=1
        sb_len=$(( rows * rows / n )); (( sb_len < 1 )) && sb_len=1
        sb_pos=$(( top * (rows - sb_len) / (n - rows) ))
    else
        sb_on=0 sb_len=0 sb_pos=0
    fi
}

# sb_put KIND ROW: draw one scrollbar cell in the last column (1 track, 2 thumb, 3 thumb
# while dragged). The cursor is moved there explicitly, after the row has been cleared.
sb_put() {
    _tui_p '\e[%d;%dH' "$2" "$_TUI_COLS"
    case $1 in
        1) _tui_p '\e[38;5;238m│\e[0m' ;;
        2) _tui_p '\e[38;5;244m█\e[0m' ;;
        *) _tui_p '\e[38;5;255m█\e[0m' ;;
    esac
}

# sb_to_row Y: move the view so the thumb (held at offset sb_grab) is at screen row Y.
# The selection is pulled into the window if it would fall out, like ctrl-e / ctrl-y.
sb_to_row() {
    local n=${#view[@]} span=$(( sb_rows - sb_len )) t
    (( sb_on && span > 0 )) || return 0
    t=$(( ( ($1 - 5 - sb_grab) * (n - sb_rows) + span / 2 ) / span ))
    (( t > n - sb_rows )) && t=$(( n - sb_rows ))
    (( t < 0 )) && t=0
    top=$t
    (( sel < top )) && sel=$top
    (( sel >= top + sb_rows )) && sel=$(( top + sb_rows - 1 ))
    return 0
}

# calc_labels: while a count is pending, give each visible row whose displayed line
# number starts with it a letter label (top to bottom). Sets lab_at / lab_row.
calc_labels() {
    lab_at=() lab_row=()
    [[ -n $cnt ]] || return 0
    local rows=$(( _TUI_ROWS - 10 )) n=${#view[@]} i idx num k=0
    (( rows < 3 )) && rows=3
    for (( i = 0; i < rows && top + i < n && k < ${#lab_chars}; i++ )); do
        idx=$(( top + i ))
        if (( num_mode && idx != sel )); then num=$(( idx > sel ? idx - sel : sel - idx )); else num=$(( idx + 1 )); fi
        [[ $num == "$cnt"* ]] || continue
        lab_at[${lab_chars:k:1}]=$idx lab_row[$idx]=${lab_chars:k:1}
        (( k++ ))
    done
    return 0
}

# put_num WIDTH NUM HL LABEL SELECTED: the line number field plus the one cell after
# it, which is the label chip when there is a label and a plain space otherwise.
# HL: 0 normal (dim), 1 starts with the pending count (bold cyan), 2 equals it (underlined).
put_num() {
    case $3 in
        2) _tui_p '\e[1;4;38;5;51m%*d\e[22;24;39m' "$1" "$2" ;;
        1) _tui_p '\e[1;38;5;51m%*d\e[22;39m' "$1" "$2" ;;
        *) _tui_p '\e[2m%*d\e[22m' "$1" "$2" ;;
    esac
    if [[ -n $4 ]]; then
        _tui_p '\e[27;1;30;48;5;220m%s\e[22;39;49m' "$4"
        (( $5 )) && _tui_dim
    else
        _tui_p ' '
    fi
    return 0
}

# info ROW LABEL TEXT   (one row of the detail pane; drawn inside a frame)
info() {
    _tui_row_same "$1" "$2|$3" && return 0
    _tui_row_begin "$1"
    if [[ -n $3 ]]; then
        _tui_dim; _tui_p ' %-7s' "$2"; _tui_reset
        _tui_p '%s' "${3:0:_TUI_COLS-10}"
    fi
    _tui_clear_eol; _tui_row_end
}

# now_text IDX -> REPLY: what is at the target of item IDX right now
now_text() {
    local i=$1
    case ${it_st[i]} in
        OK)       REPLY="linked correctly" ;;
        MISSING)  REPLY="nothing there yet" ;;
        BROKEN)   REPLY="dead link -> $(readlink -- "${it_tgt[i]}")" ;;
        WRONG)    REPLY="link points elsewhere -> $(readlink -- "${it_tgt[i]}")" ;;
        CONFLICT) REPLY="a real file or directory is in the way (stow would refuse)" ;;
        ORPHAN)   REPLY="dead link into the repo -> $(readlink -- "${it_tgt[i]}")" ;;
    esac
}

# detail IDX: the detail pane for the selected item. The text of the "now" line
# (which may need a readlink fork) is computed only when the selection changes.
detail() {
    local i=$1
    if [[ $i != "$d_i" ]]; then
        now_text "$i"; d_now=$REPLY
        d_i=$i
    fi
    if [[ -n ${it_src[i]} ]]; then tilde "${it_src[i]}"; info $(( _TUI_ROWS - 4 )) source "$REPLY"
    else info $(( _TUI_ROWS - 4 )) source ""; fi
    tilde "${it_tgt[i]}"; info $(( _TUI_ROWS - 3 )) target "$REPLY"
    info $(( _TUI_ROWS - 2 )) now "$d_now"
}

# group_summary G AVAIL -> GS: dim "N files" plus colored per-status counts, as many as fit
group_summary() {
    local -a v=(${grp_sig[$1]})
    local -a names=(OK MISSING BROKEN WRONG CONFLICT ORPHAN)
    local avail=$2 used piece st k
    piece="${v[0]} file"; (( v[0] != 1 )) && piece+=s
    used=${#piece}
    GS=$'\e[2m'"$piece"$'\e[22m'
    for k in 1 2 3 4 5 6; do
        (( v[k] )) || continue
        st=${names[k-1]}
        piece="  ${st,,} ${v[k]}"
        (( used + ${#piece} > avail )) && break
        used=$(( used + ${#piece} ))
        GS+=$'\e[38;5;'"${st_col[$st]}"'m'"$piece"$'\e[39m'
    done
}

# detail_group HEADER: detail pane for a package header row
detail_group() {
    local g=$(( -1 - $1 )) p
    local -a v=(${grp_sig[g]})
    p=${grp_name[g]}
    if [[ $p == - ]]; then
        info $(( _TUI_ROWS - 4 )) source ""
        info $(( _TUI_ROWS - 3 )) target ""
    else
        tilde "$repo/$p";                info $(( _TUI_ROWS - 4 )) source "$REPLY"
        tilde "${map[$p]:-$target}";     info $(( _TUI_ROWS - 3 )) target "$REPLY"
    fi
    info $(( _TUI_ROWS - 2 )) now "${v[0]} files, $(( v[0] - v[1] )) need fixing   (tab folds, space marks all)"
}

# ---------------------------------------------------------------------------
# Info popup (ctrl-k)
#
# The popup is not a modal loop: it is just state (popup=1) that draw() paints on top
# of the list, right below the selected row. The main loop closes it on any key and
# then handles that key normally, so navigation works while it is open.
# ---------------------------------------------------------------------------

# popup_prepare IDX: build PL ("label|value" lines) for item IDX. Cached under pop_key,
# so the stat/readlink forks only happen when the item (or its status) changes.
popup_prepare() {
    local i=$1 st=${it_st[$1]} src=${it_src[$1]} tgt=${it_tgt[$1]}
    local key="$i/$st/$tgt" name=${tgt##*/} fix now size mtime
    [[ $key == "$pop_key" ]] && return 0
    pop_key=$key

    case $st in
        OK)           fix="nothing to do" ;;
        MISSING)      fix="f creates the link" ;;
        BROKEN|WRONG) fix="f replaces the link" ;;
        CONFLICT)     fix="f moves it to $name.bak, then links" ;;
        ORPHAN)       fix="f removes the dead link" ;;
    esac
    now_text "$i"; now=$REPLY

    PL=("status|$st" "package|${it_pkg[i]}")
    if [[ -n $src ]]; then tilde "$src"; PL+=("source|$REPLY"); fi
    tilde "$tgt"; PL+=("target|$REPLY" "now|$now")
    if [[ -n $src && -f $src ]]; then
        read -r size mtime < <(stat -L -c '%s %Y' -- "$src" 2>/dev/null)
        if [[ -n $size ]]; then
            printf -v mtime '%(%F %T)T' "$mtime"
            PL+=("repo|$size bytes, modified $mtime")
        fi
    fi
    if [[ $st == CONFLICT && -f $tgt ]]; then
        read -r size mtime < <(stat -c '%s %Y' -- "$tgt" 2>/dev/null)
        if [[ -n $size ]]; then
            printf -v mtime '%(%F %T)T' "$mtime"
            PL+=("there|$size bytes, modified $mtime")
        fi
    fi
    if is_marked "$i"; then PL+=("marked|yes"); else PL+=("marked|no"); fi
    PL+=("fix|$fix")
}

# popup_geom SELROW: where the box goes -> pop_r0 pop_h pop_c0 pop_w (pop_h=0: no room).
# Right below the selected screen row; above it when it does not fit below; pushed
# against the bottom as a last resort. Never covers the header or the status row.
popup_geom() {
    local selrow=$1 h=$(( ${#PL[@]} + 2 )) maxr=$(( _TUI_ROWS - 1 ))
    (( h > _TUI_ROWS - 5 )) && h=$(( _TUI_ROWS - 5 ))
    if (( h < 3 )); then pop_h=0; return 0; fi
    pop_h=$h
    if (( selrow + h <= maxr )); then pop_r0=$(( selrow + 1 ))
    elif (( selrow - h >= 5 )); then pop_r0=$(( selrow - h ))
    else pop_r0=$(( maxr - h + 1 )); fi
    pop_c0=4
    pop_w=$(( _TUI_COLS - pop_c0 - 1 ))         # keep the scrollbar column free
    (( pop_w > 76 )) && pop_w=76
    (( pop_w < 24 )) && { pop_w=24 pop_c0=1; }
    return 0
}

# popup_forget FIRST COUNT: make draw() rebuild these screen rows from scratch (used for
# the rows the popup covered, which hold popup pixels the row caches know nothing about)
popup_forget() {
    local r
    for (( r = $1; r < $1 + $2; r++ )); do _TUI_SIG[r]= _TUI_DYN[r]= _TUI_PREV[r]=; done
}

# popup_draw: paint the box (pop_r0 pop_h pop_c0 pop_w) from PL, inside the current frame.
# Each box row goes through the row cache, so an unchanged popup costs no output.
popup_draw() {
    local r0=$pop_r0 h=$pop_h c0=$pop_c0 w=$pop_w
    local inner=$(( w - 2 )) vw=$(( w - 12 )) nl=$(( h - 2 )) k r lab val pad off bar

    # top border
    _tui_repeat $(( inner - 7 )) '─'; bar=$REPLY
    _tui_row_begin "$r0"; _tui_p '\e[%d;%dH' "$r0" "$c0"
    _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '┌─ info %s┐' "$bar"
    _tui_reset; _tui_row_end

    # one line per fact: border, space, 7 wide label, space, value, space, border
    for (( k = 0; k < nl; k++ )); do
        r=$(( r0 + 1 + k ))
        lab=${PL[k]%%|*} val=${PL[k]#*|}
        if (( ${#val} > vw )); then off=$(( ${#val} - vw + 1 )); val="…${val:off}"; fi
        printf -v pad '%*s' $(( vw - ${#val} )) ''
        _tui_row_begin "$r"; _tui_p '\e[%d;%dH' "$r" "$c0"
        _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '│\e[39m '
        _tui_dim; _tui_p '%-7s' "$lab"; _tui_p '\e[22m '
        if [[ $lab == status ]]; then st_color "$val"; else _tui_p '\e[39m'; fi
        _tui_p '%s%s\e[39m ' "$val" "$pad"
        _tui_fg 75; _tui_p '│'
        _tui_reset; _tui_row_end
    done

    # bottom border with the hint
    _tui_repeat $(( inner - 17 )) '─'; bar=$REPLY
    r=$(( r0 + h - 1 ))
    _tui_row_begin "$r"; _tui_p '\e[%d;%dH' "$r" "$c0"
    _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '└%s any key closes ─┘' "$bar"
    _tui_reset; _tui_row_end

    pop_dr0=$r0 pop_dh=$h pop_dc0=$c0 pop_dw=$w
}

# help_geom: centered box -> hlp_r0 hlp_h hlp_c0 hlp_w (hlp_h=0: no room)
help_geom() {
    local total=${#HL[@]} h
    h=$(( total + 2 )); (( h > _TUI_ROWS - 2 )) && h=$(( _TUI_ROWS - 2 ))
    if (( h < 3 )); then hlp_h=0; return 0; fi
    hlp_h=$h
    hlp_r0=$(( (_TUI_ROWS - 1 - h) / 2 + 1 ))     # never covers the status row
    hlp_w=$(( _TUI_COLS - 2 )); (( hlp_w > 80 )) && hlp_w=80
    (( hlp_w < 30 )) && hlp_w=30
    hlp_c0=$(( (_TUI_COLS - hlp_w) / 2 + 1 )); (( hlp_c0 < 1 )) && hlp_c0=1
    return 0
}

# help_draw: paint the help box inside the current frame (rows go through the row cache)
help_draw() {
    local r0=$hlp_r0 h=$hlp_h c0=$hlp_c0 w=$hlp_w
    local inner=$(( w - 2 )) vw=$(( w - 19 )) nl=$(( h - 2 )) k r lab val bar hint
    hint=" any key closes ─"

    _tui_repeat $(( inner - 7 )) '─'; bar=$REPLY
    _tui_row_begin "$r0"; _tui_p '\e[%d;%dH' "$r0" "$c0"
    _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '┌─ help %s┐' "$bar"
    _tui_reset; _tui_row_end

    for (( k = 0; k < nl; k++ )); do
        r=$(( r0 + 1 + k ))
        lab=${HL[k]%%|*} val=${HL[k]#*|}
        _tui_row_begin "$r"; _tui_p '\e[%d;%dH' "$r" "$c0"
        _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '│\e[39m '
        if [[ $lab == '#' ]]; then
            _tui_bold; _tui_fg 220; _tui_p '%-*.*s' $(( w - 4 )) $(( w - 4 )) "$val"; _tui_p '\e[22;39m'
        else
            _tui_fg 51; _tui_p '%-14.14s' "$lab"; _tui_p '\e[39m '
            _tui_p '%-*.*s' "$vw" "$vw" "$val"
        fi
        _tui_p ' '; _tui_fg 75; _tui_p '│'
        _tui_reset; _tui_row_end
    done

    _tui_repeat $(( inner - ${#hint} )) '─'; bar=$REPLY
    r=$(( r0 + h - 1 ))
    _tui_row_begin "$r"; _tui_p '\e[%d;%dH' "$r" "$c0"
    _tui_bg "$pop_bg"; _tui_fg 75; _tui_p '└%s%s┘' "$bar" "$hint"
    _tui_reset; _tui_row_end

    hlp_dr0=$r0 hlp_dh=$h hlp_dc0=$c0 hlp_dw=$w
}

# draw: build the whole screen as a frame. Only rows whose bytes changed since the
# last frame are written (see _tui_row_begin in tui.bash), all in a single write.
# List rows additionally skip all building work when their signature is unchanged.
draw() {
    local full=0
    if (( resized )); then resized=0 full=1; _tui_size; cells=() d_i=; fi
    local rows=$(( _TUI_ROWS - 10 )) n=${#view[@]} i idx it st avail s nw num nm=0 nmv=0 mk hl lbl sbc cell d r g gn fold sig
    (( rows < 3 )) && rows=3
    (( sel < top )) && top=$sel
    (( sel >= top + rows )) && top=$(( sel - rows + 1 ))
    (( top > n - rows )) && top=$(( n - rows ))
    (( top < 0 )) && top=0

    sb_calc
    calc_labels
    _tui_frame_begin

    # part of the same atomic frame, reset the drawn help box too.
    if (( full )); then _tui_clear; drawn_top=$top; pop_dh=0 hlp_dh=0; fi
    # info popup: work out where the box goes this frame. If the box on screen is not

    # the one wanted now (closed, moved, resized), the rows it covered are forgotten so
    # they get repainted below, before anything else is drawn
    pop_h=0
    if (( popup && n && view[sel] >= 0 )); then
        popup_prepare "${view[sel]}"
        popup_geom $(( 5 + sel - top ))
    fi
    if (( pop_dh )) && { (( ! pop_h )) || (( pop_r0 != pop_dr0 || pop_h != pop_dh || pop_c0 != pop_dc0 || pop_w != pop_dw )); }; then
        popup_forget "$pop_dr0" "$pop_dh"
        pop_dh=0
    fi

    # help popup: same bookkeeping as the info popup
    hlp_h=0
    (( help )) && help_geom
    if (( hlp_dh )) && { (( ! hlp_h )) || (( hlp_r0 != hlp_dr0 || hlp_h != hlp_dh || hlp_c0 != hlp_dc0 || hlp_w != hlp_dw )); }; then
        popup_forget "$hlp_dr0" "$hlp_dh"
        hlp_dh=0
    fi

    for it in "${view[@]}"; do
      (( it >= 0 )) && [[ -n ${marked[${it_tgt[it]}]-} ]] && (( nmv++ ));
    done
    
    # row 1: title, filter, marks
    nm=${#marked[@]} nmv=0
    if (( nm )); then
        for it in "${view[@]}"; do [[ -n ${marked[${it_tgt[it]}]-} ]] && (( nmv++ )); done
    fi
    if ! _tui_row_same 1 "$query|$nm|$nmv"; then
        _tui_row_begin 1
        tilde "$repo"
        _tui_bold; _tui_p ' dotfiles doctor'; _tui_reset; _tui_dim; _tui_p '  %s' "$REPLY"; _tui_reset
        [[ -n $query ]] && { _tui_fg 220; _tui_p '   /%s' "$query"; _tui_reset; }
        if (( nm )); then
            _tui_fg 82; _tui_p '   %d marked' "$nm"; (( nm > nmv )) && _tui_p ' (%d hidden)' $(( nm - nmv )); _tui_reset
        fi
        _tui_clear_eol; _tui_row_end
    fi

    # row 2: environment
    if ! _tui_row_same 2 "$loaded|$stow_ok|$env_stow|$git_dirty|$env_git"; then
        _tui_row_begin 2
        if (( loaded )); then
            _tui_p ' '
            if (( stow_ok )); then _tui_fg 82; else _tui_fg 196; fi
            _tui_p '%s' "$env_stow"; _tui_reset; _tui_p '   '
            if (( git_dirty )); then _tui_fg 220; fi
            _tui_p '%s' "$env_git"; _tui_reset
        fi
        _tui_clear_eol; _tui_row_end
    fi

    # row 3: summary (counts grow while the first scan streams in)
    if ! _tui_row_same 3 "$loaded|${#pkgs[@]}|${#it_st[@]}|${cnt[*]}"; then
        _tui_row_begin 3
        _tui_p ' %d packages, %d files   ' "${#pkgs[@]}" $(( ${#it_st[@]} - ${cnt[ORPHAN]:-0} ))
        for st in OK MISSING BROKEN WRONG CONFLICT ORPHAN; do
            (( ${cnt[$st]:-0} )) || continue
            st_color "$st"; _tui_p '%s %d  ' "${st,,}" "${cnt[$st]}"; _tui_reset
        done
        _tui_clear_eol; _tui_row_end
    fi

    # row 4: table header
    nw=${#n}; (( nw < 2 )) && nw=2
    avail=$(( _TUI_COLS - 28 - nw - 1 ))
    if ! _tui_row_same 4 "$nw|$avail"; then
        _tui_row_begin 4
      # _tui_hline $(( _TUI_ROWS - 5 )) 1 "$_TUI_COLS"; _tui_reset
      # _tui_hline "$__TUI_ROWS" 1 "$_TUI_COLS"; "8"
        # _tui_p '\e[1;4m %-3s %*s %-8s %-12s %-*s\e[0m' '[ ]' "$nw" '#' STATUS PACKAGE "$(( avail + 1 ))" PATH
        _tui_hline 4 1 "$_TUI_COLS"
        _tui_clear_eol; _tui_row_end

    fi

    # list (cached cells are only valid for one column width)
    (( avail != cells_w )) && { cells=(); cells_w=$avail; }

    # the window scrolled: let the terminal move the rows and shift the caches along,
    # so only the newly revealed rows and the old/new selection are redrawn
    d=$(( top - drawn_top ))
    if (( d != 0 && d > -rows && d < rows )); then _tui_scroll 5 $(( 4 + rows )) "$d"; fi
    drawn_top=$top

    # list loop
    for (( i = 0; i < rows; i++ )); do
        idx=$(( top + i ))
        if (( idx >= n )); then
            _tui_row_same $(( 5 + i )) "-/$n/$query/$i/$scanning" && continue
            _tui_row_begin $(( 5 + i ))
            if (( n == 0 && i == 1 )); then
                if [[ -n $query ]]; then _tui_dim; _tui_p '   no matches for "%s"  (esc clears)' "$query"
                elif (( ! scanning )); then _tui_fg 82; _tui_p '   everything is linked and healthy'; fi
                _tui_reset
            fi
            _tui_clear_eol; _tui_row_end
            continue
        fi
        it=${view[idx]}
        if (( num_mode && idx != sel )); then num=$(( idx > sel ? idx - sel : sel - idx ))
        else num=$(( idx + 1 )); fi
        # while a count is pending, line numbers that start with it are highlighted
        # and the first ones get a letter label (see calc_labels)
        hl=0 lbl=
        if [[ -n $cnt && $num == "$cnt"* ]]; then
            hl=1; [[ $num == "$cnt" ]] && hl=2
            lbl=${lab_row[$idx]-}
        fi
        # scrollbar cell of this row: 0 none, 1 track, 2 thumb, 3 thumb being dragged
        sbc=0
        if (( sb_on )); then
            if (( i >= sb_pos && i < sb_pos + sb_len )); then sbc=$(( 2 + sb_drag )); else sbc=1; fi
        fi
        if (( it < 0 )); then                       # package header row
            g=$(( -1 - it )) gn=${grp_name[-1 - it]}
            fold=0; [[ -z $query && -n ${folded[$gn]-} ]] && fold=1
            sig="H/$g/$fold/$(( idx == sel ))/$nw/$avail/$sbc/$gn/${grp_sig[g]}"
        else
            mk=0; [[ -n ${marked[${it_tgt[it]}]-} ]] && mk=1
            sig="$it/$(( idx == sel ))/$mk/$nw/$avail/$sbc"
        fi
        _tui_row_state $(( 5 + i )) "$sig" "$num/$hl/$lbl"
        case $? in
            0) continue ;;
            1) # only the line number, its highlight or its label changed: patch that field
               _tui_p '\e[%d;6H' $(( 5 + i )); (( idx == sel )) && _tui_reverse
               put_num "$nw" "$num" "$hl" "$lbl" $(( idx == sel )); _tui_reset
               _tui_row_dirty $(( 5 + i ))
               continue ;;
        esac

        if (( it < 0 )); then
            s=$gn; [[ $s == - ]] && s="(orphans)"
            group_summary "$g" "$avail"
            _tui_row_begin $(( 5 + i ))
            (( idx == sel )) && _tui_reverse
            if (( fold )); then _tui_p ' \e[1;38;5;75m ▸ \e[22;39m'; else _tui_p ' \e[1;38;5;75m ▾ \e[22;39m'; fi
            _tui_p ' '; put_num "$nw" "$num" "$hl" "$lbl" $(( idx == sel ))
            _tui_p '\e[1;38;5;75m%-21.21s\e[22;39m %s' "$s" "$GS"
            _tui_reset; _tui_clear_eol
            (( sbc )) && sb_put "$sbc" $(( 5 + i ))
            _tui_row_end
            continue
        fi

        cell=${cells[it]-}
        if [[ -z $cell ]]; then
            st=${it_st[it]}
            if [[ $st == ORPHAN ]]; then s=${it_rel[it]}; else tilde "${it_tgt[it]}"; s=$REPLY; fi
            printf -v cell ' \e[38;5;%sm%-8s\e[39m %-12.12s %-*.*s' \
                "${st_col[$st]}" "$st" "${it_pkg[it]}" "$avail" "$avail" "$s"
            cells[it]=$cell
        fi

        _tui_row_begin $(( 5 + i ))
        (( idx == sel )) && _tui_reverse
        if (( mk )); then _tui_p ' \e[1;32m[x]\e[22;39m'; else _tui_p ' \e[2m[ ]\e[22m'; fi
        _tui_p ' '; put_num "$nw" "$num" "$hl" "$lbl" $(( idx == sel )); _tui_p '%s' "${cell:1}"
        _tui_reset; _tui_clear_eol
        (( sbc )) && sb_put "$sbc" $(( 5 + i ))
        _tui_row_end
    done

    # divider + detail pane
    if ! _tui_row_same $(( _TUI_ROWS - 5 )) "$_TUI_COLS"; then
        _tui_row_begin $(( _TUI_ROWS - 5 ))
        _tui_dim; _tui_hline $(( _TUI_ROWS - 5 )) 1 "$_TUI_COLS"; _tui_reset
        _tui_row_end
    fi

    if (( n )); then
        if (( view[sel] >= 0 )); then
          detail "${view[sel]}";
        else detail_group "${view[sel]}";
        fi
    else
      info $(( _TUI_ROWS - 4 )) "" ""; info $(( _TUI_ROWS - 3 )) "" ""; info $(( _TUI_ROWS - 2 )) "" "";
    fi

    # message row + status bar
    if ! _tui_row_same $(( _TUI_ROWS - 1 )) "$cnt|$MSG"; then
        _tui_row_begin $(( _TUI_ROWS - 1 ))
        if [[ -n $cnt ]]; then _tui_fg 220; _tui_p ' count: %s_' "$cnt"; _tui_reset
        elif [[ -n $MSG ]]; then _tui_fg 220; _tui_p ' %s' "$MSG"; _tui_reset; fi
        _tui_clear_eol; _tui_row_end
    fi

    # popups go on top of everything except the status bar
    (( pop_h )) && popup_draw
    (( hlp_h )) && help_draw

    _tui_status "${PROMPT:-j/k move  spc mark  / find  : run  f fix  F fix all  ^K info  ? help  a all  n num  q quit}"

    _tui_frame_end
}

# ---------------------------------------------------------------------------
# Plain report (-c)
# ---------------------------------------------------------------------------

report() {
    local i st
    tilde "$repo"; printf 'repo: %s\n%s\n%s\n' "$REPLY" "$env_stow" "$env_git"
    for i in "${!it_st[@]}"; do
        st=${it_st[i]}
        [[ $st == OK ]] && continue
        tilde "${it_tgt[i]}"
        printf '%-9s %-12s %s\n' "$st" "${it_pkg[i]}" "$REPLY"
    done
    printf '%d packages, %d files, %d issue(s)\n' "${#pkgs[@]}" $(( ${#it_st[@]} - ${cnt[ORPHAN]:-0} )) "$(issues)"
    (( $(issues) == 0 ))
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

while getopts ':d:t:p:x:m:ch' o; do
    case $o in
        d) repo=$OPTARG ;;
        t) target=$OPTARG ;;
        p) only+=("$OPTARG") ;;
        x) skip+=("$OPTARG") ;;
        m) [[ $OPTARG == ?*=?* ]] || usage; map[${OPTARG%%=*}]=${OPTARG#*=} ;;
        c) check=1 ;;
        h) usage 0 ;;
        *) usage ;;
    esac
done

if [[ -z $repo ]]; then
    for d in "${DOTFILES:-}" "$HOME/.dotfiles" "$HOME/dotfiles"; do
        [[ -n $d && -d $d ]] && { repo=$d; break; }
    done
fi
[[ -d $repo ]] || die "dotfiles repo not found, pass one with -d"
repo=$(cd -- "$repo" && pwd -P)
[[ -n ${map[config]+x} ]] || map[config]=${XDG_CONFIG_HOME:-$HOME/.config}

if (( ${#only[@]} )); then
    for p in "${only[@]}"; do [[ -d $repo/$p ]] || die "no such package: $p"; done
    pkgs=("${only[@]}")
else
    for d in "$repo"/*/; do
        d=${d%/} d=${d##*/}
        [[ $d == _* ]] && continue
        [[ " ${skip[*]} " == *" $d "* ]] && continue
        pkgs+=("$d")
    done
fi
(( ${#pkgs[@]} )) || die "no packages found in $repo"

if (( check )) || [[ ! -t 0 ]]; then
    scan_sync
    report
    exit
fi

scan_dir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-doctor.XXXXXX") || die "cannot create a temp directory"
cleanup() {
    printf '\e[?1002l'
    _tui_deinit
    scan_cancel
    [[ -n $scan_dir ]] && rm -rf -- "$scan_dir"
}
trap cleanup EXIT

# Start scanning before the screen is touched, so the terminal keeps showing the
# shell until there is something to draw (like fzf). The worker runs while the
# history loads; then wait, at most 250 ms, for the first row to exist, and only
# then switch to the alternate screen. The first frame already has files in it.
scan_start
[[ -f $hist_file ]] && mapfile -t cmd_hist < <(tail -n 100 "$hist_file")
build_view
deadline=$(( ${EPOCHREALTIME/[.,]/} + 250000 ))
while (( scanning && ${#view[@]} == 0 && ${EPOCHREALTIME/[.,]/} < deadline )); do
    poll_scan
    (( ${#view[@]} )) || sleep 0.005
done

_tui_init
trap 'resized=1' WINCH
(( mouse )) && _tui_mouse_on

last=0

# Main loop

while :; do
    (( scanning )) && poll_scan           # pick up new results as soon as they are ready
    # draw unless more input is already waiting (held keys), but never starve
    # the screen for more than 50 ms. EPOCHREALTIME needs bash 5.
    now=${EPOCHREALTIME/[.,]/}
    if ! _tui_pending || (( now - last > 50000 )); then draw; last=$now; fi

    to=$resize_tick; (( scanning )) && to=0.03   # wake up regularly: this is also how a resize is noticed
    _tui_key $to || break
    key=$_TUI_KEY
    if [[ -z $key ]]; then                # timeout or resize tick: just redraw
        continue
    fi
    if [[ $key == drag || $key == release ]]; then    # only meaningful while the scrollbar is held
        if (( sb_drag )); then
            [[ $key == drag ]] && sb_to_row "$_TUI_MY"
            [[ $key == release ]] && sb_drag=0
        fi
        continue
    fi
    MSG=
    # the info popup is not modal: any key closes it and is then handled like normal,
    # except ctrl-k (toggle) and esc, which only close it
    if (( popup )); then
        popup=0
        [[ $key == $'\013' || $key == esc ]] && continue
        if [[ $key == '?' || $key == $'\037' ]]; then help=1; continue; fi
    fi

    # help's own key handling, consumes every key, so nothing leaks through the list.
    if (( help )); then
        help=0
        case $key in
            # navigation: help closes, the key is handled by the list below
            [0-9]|up|down|j|k|g|G|H|M|L|$'\005'|$'\031'|wheelup|wheeldown|enter|click) ;;
            # anything else only closes it
            *) continue ;;
        esac
    fi

    n=${#view[@]}
    c=${cnt:-1}
    lr=$(( _TUI_ROWS - 10 )); (( lr < 3 )) && lr=3          # rows in the window
    vis=$(( n - top )); (( vis > lr )) && vis=$lr; (( vis < 1 )) && vis=1   # rows showing items

    if [[ -n $cnt && ${#key} -eq 1 ]]; then       # easymotion: a label letter jumps to its row
       calc_labels
       if [[ -n ${lab_at["$key"]-} ]]; then sel=${lab_at["$key"]}; cnt=; continue; fi
    fi

    case $key in
       [0-9])                         # build up a count; 0 only counts after another digit
           if [[ $key != 0 || -n $cnt ]]; then cnt+=$key; fi
           continue ;;
       esc)
           if [[ -n $cnt ]]; then cnt=; continue
           elif [[ -n $query ]]; then query=; rebuild_keep; continue
           fi ;;
       f|F|:|'!')                     # these act on the list: wait for a running scan
           if (( scanning )); then MSG="still scanning, try again in a moment"; cnt=; continue; fi ;;
    esac

    case $key in

        # help popup (ctrl-?)
        #
        # NOTE: Most terminals can't send a distintc 'ctrl-?', because it arrives
        # as '0x7f', the same byte as 'backspace'
        $'\037'|'?')  help=1 popup=0 ;;

        up|k)       (( sel -= c )) ;;
        down|j)     (( sel += c )) ;;
        g)          if [[ -n $cnt ]]; then (( sel = cnt - 1 )); else sel=0; fi ;;
        G)          if [[ -n $cnt ]]; then (( sel = cnt - 1 )); else (( sel = n - 1 )); fi ;;
        enter)      if [[ -n $cnt ]]; then (( sel = cnt - 1 ))
                    elif (( n && view[sel] < 0 )); then fold_toggle; n=${#view[@]}; fi ;;
        H)          (( sel = top + (c > vis ? vis : c) - 1 )) ;;
        M)          (( sel = top + (vis - 1) / 2 )) ;;
        L)          (( sel = top + vis - (c > vis ? vis : c) )) ;;
        click)      if (( sb_on && _TUI_MX == _TUI_COLS && _TUI_MY >= 5 && _TUI_MY < 5 + sb_rows )); then
                        # scrollbar: grab the thumb where it was hit, or centre it on the click
                        if (( _TUI_MY >= 5 + sb_pos && _TUI_MY < 5 + sb_pos + sb_len )); then
                            sb_grab=$(( _TUI_MY - 5 - sb_pos ))
                        else
                            sb_grab=$(( sb_len / 2 ))
                        fi
                        sb_drag=1; sb_to_row "$_TUI_MY"
                    elif (( _TUI_MY >= 5 && _TUI_MY < 5 + lr )); then
                        i=$(( top + _TUI_MY - 5 ))
                        if (( i < n )); then
                            sel=$i
                            if (( view[i] < 0 )); then
                                (( _TUI_MX >= 2 && _TUI_MX <= 4 )) && { fold_toggle; n=${#view[@]}; }
                            else
                                (( _TUI_MX >= 2 && _TUI_MX <= 4 )) && toggle_mark "${view[i]}"
                            fi
                        fi
                    fi ;;
        $'\005')    scroll_view "${cnt:-$scroll_step}" ;;
        $'\031')    scroll_view "-${cnt:-$scroll_step}" ;;
        $'\013')    if (( n && view[sel] >= 0 )); then popup=1 pop_key=; else MSG="no file selected"; fi ;;
        space)      for (( k = 0; k < c && sel + k < n; k++ )); do
                        v=${view[sel + k]}
                        if (( v >= 0 )); then toggle_mark "$v"
                        elif (( c == 1 )); then toggle_group $(( sel + k )); fi
                    done ;;
        A)          k=0; for i in "${view[@]}"; do (( i >= 0 )) || continue; marked[${it_tgt[i]}]=1; (( k++ )); done
                    MSG="marked $k file(s)" ;;
        I)          for i in "${view[@]}"; do (( i >= 0 )) && toggle_mark "$i"; done ;;
        C)          marked=(); MSG="marks cleared" ;;
        wheelup)    scroll_view "-$scroll_step" ;;
        wheeldown)  scroll_view "$scroll_step" ;;
        m)          if (( mouse )); then mouse=0; _tui_mouse_off; MSG="mouse off (terminal selection works)"
                    else mouse=1; _tui_mouse_on; MSG="mouse on"; fi ;;
        rclick|mclick) ;;
        /)          old=$query old_sel=$sel old_top=$top anchor=-1
                    if read_line "/" "$query" "" search_cb; then
                        query=$LINE; build_view              # keep the selection the search left us on
                    else
                        query=$old; build_view; sel=$old_sel top=$old_top    # back to where we were
                        (( sel >= ${#view[@]} )) && sel=$(( ${#view[@]} - 1 )); (( sel < 0 )) && sel=0
                    fi
                    n=${#view[@]} ;;
        :|!)        if (( n && view[sel] >= 0 )); then run_command "${view[sel]}"; n=${#view[@]}
                    else MSG="no file selected"; fi ;;
        n)          num_mode=$(( !num_mode )); (( num_mode )) && MSG="relative numbers" || MSG="absolute numbers" ;;
        a)          show_all=$(( !show_all )); rebuild_keep; n=${#view[@]} ;;
        p)          group=$(( !group )); rebuild_keep; n=${#view[@]}
                    (( group )) && MSG="grouped by package" || MSG="flat list" ;;
        $'\t')      fold_toggle; n=${#view[@]} ;;
        z)          fold_all; n=${#view[@]} ;;
        f)          get_marked
                    if (( ${#mv[@]} )); then fix_marked
                    elif (( n && view[sel] >= 0 )); then fix_item "${view[sel]}"
                    elif (( n )); then MSG="select a file, or mark some first (space on a header marks the package)"; fi
                    n=${#view[@]} ;;
        F)          fix_missing; n=${#view[@]} ;;
        r)          scan_start; build_view; MSG="rescanning"; n=${#view[@]} ;;
        q|esc)      break ;;
    esac
    cnt=
    (( sel >= n )) && sel=$(( n - 1 ))
    (( sel < 0 )) && sel=0
done
exit 0
