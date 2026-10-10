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
# Keys: j/k move   a show all/issues only   f fix item   F fix all MISSING
#       r rescan   q quit

_here=${BASH_SOURCE[0]%/*}; [[ $_here == "${BASH_SOURCE[0]}" ]] && _here=.
source "$_here/tui.bash"

repo= target=$HOME check=0
only=() skip=() pkgs=()
declare -A map=() cnt=()
it_pkg=() it_rel=() it_src=() it_tgt=() it_st=() view=()
sel=0 top=0 show_all=0 MSG=
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
    local p tdir rel src tgt d l real
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
}

build_view() {
    local i
    view=()
    for i in "${!it_st[@]}"; do
        (( show_all )) || [[ ${it_st[i]} != OK ]] && view+=("$i")
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
        [[ -n $_TUI_KEY ]] && break
    done
    [[ $_TUI_KEY == y ]]
}

fix_item() {
    local i=$1 st=${it_st[$1]} src=${it_src[$1]} tgt=${it_tgt[$1]} name=${it_tgt[$1]##*/}
    case $st in
        OK)
            MSG="$name is already fine"; return ;;
        MISSING)
            if mklink "$src" "$tgt"; then MSG="linked $name"; else MSG="could not link $name"; fi ;;
        BROKEN|WRONG)
            confirm "replace the link at $name?" || { MSG="skipped"; return; }
            if rm -- "$tgt" && mklink "$src" "$tgt"; then MSG="relinked $name"; else MSG="could not relink $name"; fi ;;
        CONFLICT)
            confirm "move $name to $name.bak and link it?" || { MSG="skipped"; return; }
            if [[ -e $tgt.bak || -L $tgt.bak ]]; then MSG="$name.bak already exists, not touching anything"; return; fi
            if mv -- "$tgt" "$tgt.bak" && mklink "$src" "$tgt"; then MSG="backed up and linked $name"
            else MSG="could not fix $name"; fi ;;
        ORPHAN)
            confirm "remove the dead link $name?" || { MSG="skipped"; return; }
            if rm -- "$tgt"; then MSG="removed $name"; else MSG="could not remove $name"; fi ;;
    esac
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

# info ROW LABEL TEXT
info() {
    _tui_goto "$1" 1; _tui_clear_eol
    [[ -z $3 ]] && return 0
    _tui_dim; printf ' %-7s' "$2"; _tui_reset
    printf '%s' "${3:0:_TUI_COLS-10}"
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

draw() {
    local rows=$(( _TUI_ROWS - 10 )) n=${#view[@]} i idx it st avail s
    (( rows < 3 )) && rows=3
    (( sel < top )) && top=$sel
    (( sel >= top + rows )) && top=$(( sel - rows + 1 ))
    (( top > n - rows )) && top=$(( n - rows ))
    (( top < 0 )) && top=0

    _tui_goto 1 1; _tui_clear_eol
    tilde "$repo"
    _tui_bold; printf ' dotfiles doctor'; _tui_reset; _tui_dim; printf '  %s' "$REPLY"; _tui_reset

    _tui_goto 2 1; _tui_clear_eol; printf ' '
    if (( stow_ok )); then _tui_fg 82; else _tui_fg 196; fi
    printf '%s' "$env_stow"; _tui_reset; printf '   '
    if (( git_dirty )); then _tui_fg 220; fi
    printf '%s' "$env_git"; _tui_reset

    _tui_goto 3 1; _tui_clear_eol
    printf ' %d packages, %d files   ' "${#pkgs[@]}" $(( ${#it_st[@]} - ${cnt[ORPHAN]:-0} ))
    for st in OK MISSING BROKEN WRONG CONFLICT ORPHAN; do
        (( ${cnt[$st]:-0} )) || continue
        st_color "$st"; printf '%s %d  ' "${st,,}" "${cnt[$st]}"; _tui_reset
    done

    _tui_dim; _tui_hline 4 1 "$_TUI_COLS"; _tui_hline $(( _TUI_ROWS - 5 )) 1 "$_TUI_COLS"; _tui_reset
    _tui_p 'status package' '[ ]' "$nw"

    avail=$(( _TUI_COLS - 24 ))
    for (( i = 0; i < rows; i++ )); do
        idx=$(( top + i ))
        _tui_goto $(( 5 + i )) 1; _tui_clear_eol
        if (( idx >= n )); then
            if (( n == 0 && i == 1 )); then
                _tui_fg 82; printf '   everything is linked and healthy'; _tui_reset
            fi
            continue
        fi
        it=${view[idx]} st=${it_st[it]}
        if [[ $st == ORPHAN ]]; then s=${it_rel[it]}; else tilde "${it_tgt[it]}"; s=$REPLY; fi
        (( idx == sel )) && _tui_reverse
        st_color "$st"; printf ' %-8s' "$st"; printf '\e[39m'
        printf ' %-12.12s %-*.*s' "${it_pkg[it]}" "$avail" "$avail" "$s"
        _tui_reset
    done

    if (( n )); then detail "${view[sel]}"
    else info $(( _TUI_ROWS - 4 )) "" ""; info $(( _TUI_ROWS - 3 )) "" ""; info $(( _TUI_ROWS - 2 )) "" ""; fi

    _tui_goto $(( _TUI_ROWS - 1 )) 1; _tui_clear_eol
    [[ -n $MSG ]] && { _tui_fg 220; printf ' %s' "$MSG"; _tui_reset; }
    _tui_status "j/k move  f fix  F fix all missing  a all/issues  r rescan  q quit"
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
_tui_init
scan; build_view

while :; do
    draw
    _tui_key || break
    MSG=
    n=${#view[@]}
    case $_TUI_KEY in
        up|k)   (( sel > 0 )) && (( sel-- )) ;;
        down|j) (( sel < n - 1 )) && (( sel++ )) ;;
        g)      sel=0 ;;
        G)      (( sel = n > 0 ? n - 1 : 0 )) ;;
        a)      show_all=$(( !show_all )); sel=0 top=0; build_view ;;
        f)      (( n )) && fix_item "${view[sel]}" ;;
        F)      fix_missing ;;
        r)      scan; build_view; MSG="rescanned" ;;
        q|esc)  break ;;
    esac
done
exit 0
