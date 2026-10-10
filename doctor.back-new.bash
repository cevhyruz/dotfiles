#!/usr/bin/env bash
# dotfiles-doctor.sh - check (and repair) a GNU Stow style dotfiles repo
#
# Every top-level directory in the repo is a package whose files mirror the
# target (default $HOME). The doctor compares each file with what is actually
# there and reports:
#   OK        target is the repo file (through a link, or a folded dir link)
#   MISSING   nothing at the target path yet
#   BROKEN    a dead symlink sits at the target path
#   WRONG     a symlink there points somewhere else
#   CONFLICT  a real file/dir is in the way (stow would refuse)
#   ORPHAN    a dead symlink into the repo, left over from a removed/renamed file
# It also checks that stow is installed and whether the repo has uncommitted work.
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
#       12G, 12g or 12<enter> jump to line 12, esc cancels a pending count
#       H / M / L jump to the top / middle / bottom row of the visible window
#       (not the list); 3H and 3L mean 3rd row from the top / bottom
#       / search: filter the list live (space separated terms are ANDed and match
#       status, package and path, e.g. "missing config"); enter keeps the filter,
#       esc while typing restores the old one, esc afterwards clears it
#       : or ! run a shell command on the highlighted file, see below
#       ctrl-e / ctrl-y scroll the window one row (3^E = three rows) and only move the
#       selection if it would leave the window
#       marks: space marks/unmarks the highlighted file and moves down (3<space>
#       marks three); A marks everything in view, I inverts, C clears all; clicking a
#       [ ] box toggles it. With marks, f fixes every marked file in view (one
#       confirmation) and : runs the command on each marked file
#       mouse: click a row to select it, wheel scrolls; m toggles the mouse
#       (turn it off to select text with the terminal, or hold shift)

_here=${BASH_SOURCE[0]%/*}; [[ $_here == "${BASH_SOURCE[0]}" ]] && _here=.
source "$_here/tui.bash"

shopt -s extglob

repo= target=$HOME check=0
only=() skip=() pkgs=()
declare -A map=() cnt=() marked=()
mv=()
it_pkg=() it_rel=() it_src=() it_tgt=() it_st=() view=()
sel=0 top=0 show_all=0 MSG= num_mode=0 cnt= mouse=1 query= LINE=
cmd_hist=() hist_file=${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-doctor/history
env_stow= env_git= git_dirty=0 stow_ok=0

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
    it_pkg+=("$1") it_rel+=("$2") it_src+=("$3") it_tgt+=("$4") it_st+=("$5")
    cnt[$5]=$(( ${cnt[$5]:-0} + 1 ))
}

scan() {
    local p tdir rel src tgt d l real k
    local -A known=() dirs=()
    it_pkg=() it_rel=() it_src=() it_tgt=() it_st=() cnt=()

    for p in "${pkgs[@]}"; do
        tdir=${map[$p]:-$target}
        while IFS= read -rd '' rel; do
            ignored "$rel" && continue
            src=$repo/$p/$rel tgt=$tdir/$rel
            classify "$src" "$tgt"
            add "$p" "$rel" "$src" "$tgt" "$ST"
            known[$tgt]=1
            dirs[${tgt%/*}]=1
        done < <(find "$repo/$p" -name .git -prune -o \( -type f -o -type l \) -printf '%P\0' | sort -z)
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
            add "-" "$REPLY" "" "$l" ORPHAN
        done
    done
    shopt -u nullglob dotglob

    # environment
    if command -v stow >/dev/null 2>&1; then stow_ok=1; env_stow="stow installed"
    else stow_ok=0; env_stow="stow not installed"; fi
    if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local -a st
        mapfile -t st < <(git -C "$repo" status --porcelain 2>/dev/null)
        git_dirty=${#st[@]}
        if (( git_dirty )); then env_git="git: $git_dirty uncommitted change(s)"; else env_git="git: clean"; fi
    else
        git_dirty=0 env_git="git: not a repository"
    fi

    # forget marks whose item no longer exists
    local -A present=()
    for k in "${it_tgt[@]}"; do present[$k]=1; done
    for k in "${!marked[@]}"; do [[ -n ${present[$k]:-} ]] || marked[$k]=; done
}

build_view() {
    local i t hay
    local -a terms=()
    view=()
    [[ -n $query ]] && read -ra terms <<<"${query,,}"
    for i in "${!it_st[@]}"; do
        if (( ! show_all )) && [[ ${it_st[i]} == OK ]]; then continue; fi
        if (( ${#terms[@]} )); then
            hay="${it_st[i]} ${it_pkg[i]} ${it_rel[i]} ${it_tgt[i]}"; hay=${hay,,}
            for t in "${terms[@]}"; do [[ $hay == *"$t"* ]] || continue 2; done
        fi
        view+=("$i")
    done
    (( sel >= ${#view[@]} )) && sel=$(( ${#view[@]} - 1 ))
    (( sel < 0 )) && sel=0
    return 0
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
        _tui_key || return 1
        case $_TUI_KEY in ''|click|rclick|mclick|wheelup|wheeldown) continue ;; esac
        break
    done
    [[ $_TUI_KEY == y ]]
}

# read_line LABEL INITIAL [HIST] [CALLBACK]
# One-line editor on the status row. Sets LINE, returns 1 if cancelled.
# HIST non-empty: up/down browse command history. CALLBACK is called with the
# buffer after every change (used for live search).
read_line() {
    local label=$1 buf=$2 hist=${3:-} cb=${4:-} hi=${#cmd_hist[@]} room disp
    LINE=
    while :; do
        [[ -n $cb ]] && "$cb" "$buf"
        room=$(( _TUI_COLS - ${#label} - 3 ))
        disp=$buf; (( ${#disp} > room )) && disp=${disp: -room}
        _tui_status "${label}${disp}_"
        _tui_key || return 1
        case $_TUI_KEY in
            enter)         LINE=$buf; return 0 ;;
            esc)           return 1 ;;
            $'\177'|$'\b') buf=${buf%?} ;;
            $'\025')       buf= ;;                                   # ctrl-u
            $'\027')       buf=${buf%%+([[:space:]])}; buf=${buf%%+([^[:space:]])} ;;  # ctrl-w
            up)   if [[ -n $hist ]] && (( hi > 0 )); then (( hi-- )); buf=${cmd_hist[hi]}; fi ;;
            down) if [[ -n $hist ]]; then
                      if (( hi < ${#cmd_hist[@]} - 1 )); then (( hi++ )); buf=${cmd_hist[hi]}
                      else hi=${#cmd_hist[@]}; buf=; fi
                  fi ;;
            space)         buf+=' ' ;;
            ''|$'\t'|click|rclick|mclick|wheelup|wheeldown) ;;
            *)             (( ${#_TUI_KEY} == 1 )) && buf+=$_TUI_KEY ;;
        esac
    done
}

search_cb() { query=$1; sel=0 top=0; build_view; draw; }

# run_command IDX: prompt for a command and run it on the marked files in view,
# or on IDX when nothing is marked
run_command() {
    local i c run p rc fails=0 label="! "
    local -a targets=("$1")
    get_marked
    if (( ${#mv[@]} )); then targets=("${mv[@]}"); label="! (${#mv[@]} marked) "; fi
    MSG="{} = repo file   {t} = target   \$SRC \$TGT \$PKG   (no placeholder: file is appended)"
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
    scan; build_view
    if (( ${#targets[@]} > 1 )); then MSG="ran on ${#targets[@]} files (${fails} failed): ${c:0:40}"
    else MSG="ran: ${c:0:50} (exit $rc)"; fi
}

is_marked()   { [[ -n ${marked[${it_tgt[$1]}]:-} ]]; }
toggle_mark() { if is_marked "$1"; then marked[${it_tgt[$1]}]=; else marked[${it_tgt[$1]}]=1; fi; }
# get_marked: indices of marked items that are in the current view -> mv
get_marked()  { local i; mv=(); for i in "${view[@]}"; do is_marked "$i" && mv+=("$i"); done; }

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
    if apply_fix "$i"; then MSG="$verb $name"; marked[$tgt]=; else MSG="could not fix $name"; fi
    scan; build_view
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
        if apply_fix "$i"; then (( ok++ )); marked[${it_tgt[i]}]=; else (( bad++ )); fi
    done
    MSG="fixed $ok of $tot"; (( bad )) && MSG+=", $bad failed (a .bak already exists?)"
    scan; build_view
}

fix_missing() {
    local i n=0
    for i in "${!it_st[@]}"; do
        [[ ${it_st[i]} == MISSING ]] || continue
        mklink "${it_src[i]}" "${it_tgt[i]}" && (( n++ ))
    done
    MSG="created $n link(s)"
    scan; build_view
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

# info ROW LABEL TEXT   (one row of the detail pane; drawn inside a frame)
info() {
    _tui_row_begin "$1"
    if [[ -n $3 ]]; then
        _tui_dim; _tui_p ' %-7s' "$2"; _tui_reset
        _tui_p '%s' "${3:0:_TUI_COLS-10}"
    fi
    _tui_clear_eol; _tui_row_end
}

detail() {
    local i=$1 now
    case ${it_st[i]} in
        OK)       now="linked correctly" ;;
        MISSING)  now="nothing there yet" ;;
        BROKEN)   now="dead link -> $(readlink -- "${it_tgt[i]}")" ;;
        WRONG)    now="link points elsewhere -> $(readlink -- "${it_tgt[i]}")" ;;
        CONFLICT) now="a real file or directory is in the way (stow would refuse)" ;;
        ORPHAN)   now="dead link into the repo -> $(readlink -- "${it_tgt[i]}")" ;;
    esac
    if [[ -n ${it_src[i]} ]]; then tilde "${it_src[i]}"; info $(( _TUI_ROWS - 4 )) source "$REPLY"
    else info $(( _TUI_ROWS - 4 )) source ""; fi
    tilde "${it_tgt[i]}"; info $(( _TUI_ROWS - 3 )) target "$REPLY"
    info $(( _TUI_ROWS - 2 )) now "$now"
}

# draw: build the whole screen as a frame. Only rows whose bytes changed since the
# last frame are written (see _tui_row_begin in tui.sh), all in a single write.
draw() {
    local rows=$(( _TUI_ROWS - 10 )) n=${#view[@]} i idx it st avail s nw num nm=0 nmv=0 k
    (( rows < 3 )) && rows=3
    (( sel < top )) && top=$sel
    (( sel >= top + rows )) && top=$(( sel - rows + 1 ))
    (( top > n - rows )) && top=$(( n - rows ))
    (( top < 0 )) && top=0

    _tui_frame_begin

    # row 1: title, filter, marks
    _tui_row_begin 1
    tilde "$repo"
    _tui_bold; _tui_p ' dotfiles doctor'; _tui_reset; _tui_dim; _tui_p '  %s' "$REPLY"; _tui_reset
    [[ -n $query ]] && { _tui_fg 220; _tui_p '   /%s' "$query"; _tui_reset; }
    for k in "${!marked[@]}"; do [[ -n ${marked[$k]} ]] && (( nm++ )); done
    for it in "${view[@]}"; do is_marked "$it" && (( nmv++ )); done
    if (( nm )); then
        _tui_fg 82; _tui_p '   %d marked' "$nm"; (( nm > nmv )) && _tui_p ' (%d hidden)' $(( nm - nmv )); _tui_reset
    fi
    _tui_clear_eol; _tui_row_end

    # row 2: environment
    _tui_row_begin 2
    _tui_p ' '
    if (( stow_ok )); then _tui_fg 82; else _tui_fg 196; fi
    _tui_p '%s' "$env_stow"; _tui_reset; _tui_p '   '
    if (( git_dirty )); then _tui_fg 220; fi
    _tui_p '%s' "$env_git"; _tui_reset
    _tui_clear_eol; _tui_row_end

    # row 3: summary
    _tui_row_begin 3
    _tui_p ' %d packages, %d files   ' "${#pkgs[@]}" $(( ${#it_st[@]} - ${cnt[ORPHAN]:-0} ))
    for st in OK MISSING BROKEN WRONG CONFLICT ORPHAN; do
        (( ${cnt[$st]:-0} )) || continue
        st_color "$st"; _tui_p '%s %d  ' "${st,,}" "${cnt[$st]}"; _tui_reset
    done
    _tui_clear_eol; _tui_row_end

    # row 4: table header
    nw=${#n}; (( nw < 2 )) && nw=2
    avail=$(( _TUI_COLS - 28 - nw - 1 ))
    _tui_row_begin 4
    _tui_p '\e[1;4m %-3s %*s %-8s %-12s %-*s\e[0m' '[ ]' "$nw" '#' STATUS PACKAGE "$(( avail + 1 ))" PATH
    _tui_clear_eol; _tui_row_end

    # list
    for (( i = 0; i < rows; i++ )); do
        idx=$(( top + i ))
        _tui_row_begin $(( 5 + i ))
        if (( idx >= n )); then
            if (( n == 0 && i == 1 )); then
                if [[ -n $query ]]; then _tui_dim; _tui_p '   no matches for "%s"  (esc clears)' "$query"
                else _tui_fg 82; _tui_p '   everything is linked and healthy'; fi
                _tui_reset
            fi
            _tui_clear_eol; _tui_row_end
            continue
        fi
        it=${view[idx]} st=${it_st[it]}
        if [[ $st == ORPHAN ]]; then s=${it_rel[it]}; else tilde "${it_tgt[it]}"; s=$REPLY; fi
        (( idx == sel )) && _tui_reverse
        if (( num_mode && idx != sel )); then num=$(( idx > sel ? idx - sel : sel - idx ))
        else num=$(( idx + 1 )); fi
        if is_marked "$it"; then _tui_p ' \e[1;32m[x]\e[22;39m'; else _tui_p ' \e[2m[ ]\e[22m'; fi
        _tui_p ' \e[2m%*d\e[22m' "$nw" "$num"
        st_color "$st"; _tui_p ' %-8s' "$st"; _tui_p '\e[39m'
        _tui_p ' %-12.12s %-*.*s' "${it_pkg[it]}" "$avail" "$avail" "$s"
        _tui_reset
        _tui_clear_eol; _tui_row_end
    done

    # divider + detail pane
    _tui_row_begin $(( _TUI_ROWS - 5 ))
    _tui_dim; _tui_hline $(( _TUI_ROWS - 5 )) 1 "$_TUI_COLS"; _tui_reset
    _tui_row_end

    if (( n )); then detail "${view[sel]}"
    else info $(( _TUI_ROWS - 4 )) "" ""; info $(( _TUI_ROWS - 3 )) "" ""; info $(( _TUI_ROWS - 2 )) "" ""; fi

    # message row + status bar
    _tui_row_begin $(( _TUI_ROWS - 1 ))
    if [[ -n $cnt ]]; then _tui_fg 220; _tui_p ' count: %s_' "$cnt"; _tui_reset
    elif [[ -n $MSG ]]; then _tui_fg 220; _tui_p ' %s' "$MSG"; _tui_reset; fi
    _tui_clear_eol; _tui_row_end
    _tui_status "j/k move  spc mark  / find  : run  f fix  F fix all  a all  n num  q quit"

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
    scan
    report
    exit
fi

trap '_tui_deinit' EXIT
trap '_tui_size; _tui_clear' WINCH
[[ -f $hist_file ]] && mapfile -t cmd_hist < <(tail -n 100 "$hist_file")
_tui_init
(( mouse )) && _tui_mouse_on
scan; build_view

while :; do
    draw
    _tui_key || break
    key=$_TUI_KEY
    [[ -z $key ]] && continue          # resize tick: just redraw
    MSG=
    n=${#view[@]}
    c=${cnt:-1}
    lr=$(( _TUI_ROWS - 10 )); (( lr < 3 )) && lr=3          # rows in the window
    vis=$(( n - top )); (( vis > lr )) && vis=$lr; (( vis < 1 )) && vis=1   # rows showing items

    case $key in
        [0-9])                         # build up a count; 0 only counts after another digit
            if [[ $key != 0 || -n $cnt ]]; then cnt+=$key; fi
            continue ;;
        esc)
            if [[ -n $cnt ]]; then cnt=; continue
            elif [[ -n $query ]]; then query=; sel=0 top=0; build_view; continue
            fi ;;
    esac

    case $key in
        up|k)       (( sel -= c )) ;;
        down|j)     (( sel += c )) ;;
        g)          if [[ -n $cnt ]]; then (( sel = cnt - 1 )); else sel=0; fi ;;
        G)          if [[ -n $cnt ]]; then (( sel = cnt - 1 )); else (( sel = n - 1 )); fi ;;
        enter)      [[ -n $cnt ]] && (( sel = cnt - 1 )) ;;
        H)          (( sel = top + (c > vis ? vis : c) - 1 )) ;;
        M)          (( sel = top + (vis - 1) / 2 )) ;;
        L)          (( sel = top + vis - (c > vis ? vis : c) )) ;;
        click)      if (( _TUI_MY >= 5 && _TUI_MY < 5 + lr )); then
                        i=$(( top + _TUI_MY - 5 ))
                        if (( i < n )); then
                            sel=$i
                            (( _TUI_MX >= 2 && _TUI_MX <= 4 )) && toggle_mark "${view[i]}"
                        fi
                    fi ;;
        $'\005')    top=$(( top + c )); (( top > n - lr )) && top=$(( n - lr )); (( top < 0 )) && top=0
                    (( sel < top )) && sel=$top ;;
        $'\031')    top=$(( top - c )); (( top < 0 )) && top=0
                    (( sel >= top + lr )) && sel=$(( top + lr - 1 )) ;;
        space)      for (( k = 0; k < c && sel < n; k++ )); do toggle_mark "${view[sel]}"; (( sel++ )); done
                    (( sel >= n )) && sel=$(( n - 1 )) ;;
        A)          for i in "${view[@]}"; do marked[${it_tgt[i]}]=1; done; MSG="marked ${#view[@]} file(s)" ;;
        I)          for i in "${view[@]}"; do toggle_mark "$i"; done ;;
        C)          marked=(); MSG="marks cleared" ;;
        wheelup)    (( sel -= 3 )) ;;
        wheeldown)  (( sel += 3 )) ;;
        m)          if (( mouse )); then mouse=0; _tui_mouse_off; MSG="mouse off (terminal selection works)"
                    else mouse=1; _tui_mouse_on; MSG="mouse on"; fi ;;
        rclick|mclick) ;;
        /)          old=$query
                    if read_line "/" "$query" "" search_cb; then query=$LINE; else query=$old; fi
                    sel=0 top=0; build_view; n=${#view[@]} ;;
        :|!)        if (( n )); then run_command "${view[sel]}"; n=${#view[@]}
                    else MSG="no file selected"; fi ;;
        n)          num_mode=$(( !num_mode )); (( num_mode )) && MSG="relative numbers" || MSG="absolute numbers" ;;
        a)          show_all=$(( !show_all )); sel=0 top=0; build_view; n=${#view[@]} ;;
        f)          get_marked
                    if (( ${#mv[@]} )); then fix_marked
                    elif (( n )); then fix_item "${view[sel]}"; fi
                    n=${#view[@]} ;;
        F)          fix_missing; n=${#view[@]} ;;
        r)          scan; build_view; MSG="rescanned"; n=${#view[@]} ;;
        q|esc)      break ;;
    esac
    cnt=
    (( sel >= n )) && sel=$(( n - 1 ))
    (( sel < 0 )) && sel=0
done
exit 0
