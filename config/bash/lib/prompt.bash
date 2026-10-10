# lib/prompt.bash - dynamic prompt pieces: git segment and exit-status arrow
#
# Requires core/term.bash and lib/theme.bash (after __theme::init). Bash >= 4.4.
#
# PS1 stays static and only references two variables that are refreshed
# before every prompt by __theme::prompt (registered in PROMPT_COMMAND):
#
#   ${THEME_GIT_SEG}   ":branch ^1 v2 +!?"  (empty outside a repo)
#   ${THEME_ARROW}     color of the prompt arrow: ok/error from last exit status
#
# Bash does not re-expand or re-decode a variable's *value*, so a branch named
# 'x/$(rm -rf ~)' is shown literally instead of executed. \001 and \002 are
# readline's non-printing markers (what \[ and \] turn into).
#
# Git flags:  = conflicts   + staged   ! unstaged   ? untracked   $ stash
#             (a count follows $ when there is more than one stash)
#             ↑n ahead   ↓n behind   (^n / vn on the Linux console)
#             merge / rebase / cherry-pick / revert / bisect shown after the
#             branch name when one of those is in progress
#
# ${THEME_PY_SEG}    " venvname py3.12"  (empty with no active venv and no
#                     .python-version file found from cwd upward)
#
# pyenv/uv note: activating a venv (uv or plain venv/virtualenv) makes the
# activate script prepend its own "(venvname) " to PS1, which would show
# twice alongside THEME_PY_SEG. Export VIRTUAL_ENV_DISABLE_PROMPT=1 (once,
# e.g. in core/) so the activate script leaves PS1 alone.
#
# ${THEME_NODE_SEG}  " node20.11.0"  (empty with no nvm-active node and no
#                     .nvmrc file found from cwd upward)
#                     If .nvmrc pins a plain version (not "lts/*" etc) and it
#                     doesn't match the active nvm version, "!=<pinned>" is
#                     appended in the warn color as a reminder to `nvm use`.
#
# nvm note: this reads $NVM_BIN (which nvm exports on `nvm use`/`nvm install`
# and on shell init via its own auto-use hook, if you have one configured),
# not `node -v`, so no fork is needed. If you open a shell in a directory
# with an .nvmrc and don't use nvm's auto-use hook, NVM_BIN still reflects
# whatever version nvm last activated, and the "!=<pinned>" marker will
# point out the mismatch.
#
# ${THEME_EXIT_SEG}  " x127"  (empty after a successful command; "x1" on the
#                     Linux console, "✗1" elsewhere). Signal exits (128+n,
#                     e.g. 130 for Ctrl-C) show as their raw number, same as
#                     $? itself - no extra fork to look up the signal name.
#
# ${THEME_TIME_SEG}  " 2.34s" / " 1m05s" / " 1h02m" - how long the last
#                     command took, once it clears THEME_TIME_MIN_MS. Empty
#                     when no command ran (an empty Enter, unlike the exit
#                     code, does not repeat a stale duration) and empty on
#                     bash < 5.0, which has no fork-free high-res clock.
#
# Timing mechanism: a DEBUG trap fires before every top-level simple command
# and records $EPOCHREALTIME (a bash 5.0+ builtin variable - no fork).
# __theme::prompt reads it back, computes the delta with pure integer bash
# arithmetic (no date/bc fork), and resets the "a command ran" flag so the
# next empty Enter shows nothing. functrace is intentionally left off, so
# the trap does not fire for commands *inside* our own functions (git, etc)
# - only for what you actually type at the prompt.
#
# Env: THEME_GIT=0                  disable the git segment
#      THEME_GIT_UNTRACKED=no       skip untracked files (much faster in huge repos)
#      THEME_PYTHON=0               disable the python segment
#      THEME_NODE=0                 disable the node segment
#      THEME_EXIT=0                 disable the exit code segment (arrow color still changes)
#      THEME_TIME=0                 disable the duration segment (skips installing the trap)
#      THEME_TIME_MIN_MS=1000       minimum duration, in milliseconds, worth showing


THEME_GIT_SEG=
THEME_PY_SEG=
THEME_NODE_SEG=
THEME_ERRLOG_SEG=
THEME_SHLVL_SEG=
THEME_EXIT_SEG=
THEME_TIME_SEG=
THEME_ARROW=


# Features
# [] can edit prompt segments on demand (like icd)
# [] compact mode (like COLUMN < 80) drop low priority segments
# [] chpwd hook: bash has none, but [[ $PWD != $THEME_LAST_PWD ]] in the prompt
#    function gives you one. Useful things to trigger from it:
#     - Auto nvm use when entering a directory with .nvmrc. Your node segment
#       already detects the mismatch, so this would fix it.
#     - Auto-activate or deactivate a venv.
#     - A short ls after cd.
# [] Git identity check: if you juggle personal and client repos, show a marker
#    when user.email isn't the expected one. Read it from .git/config with a
#    file read, not git config.
# [] Layout switching:
#    - if the path is longer than half the terminal or any rules, then move the
#      segments to their own line instead of overflowing.

# [] Git status extras
#    - submodule dirty
#    - show a tag when $gitdir contains /worktree/, since branch name alone doesn't
#      tell you you're in a secondary worktree
#    - Last commit age 'git log -1 --format=%ct' compared against EPOCHSECONDS
#    - Unpushed/no-upstream state: you already parse branch.ab. A missing branch.ab
#      line means no upstream is set, which is worth a small marker.
#    - Latest tag or describe: show v1.2.0+5 style info. It costs another
#      git call, so cache it.
#

# [] Config level behavior (bash-wide)
#    - prompt profile (plain, minimal, full)

# [] Bash
#    - Option indicators: show -x, -u, or -e when $- contains x, u, or e.

# [] Reboot required: [[ -f /var/run/reboot-required ]]. Ubuntu creates it after
#    kernel updates, and nobody notices it otherwise.
# [] Pending updates: /var/lib/update-notifier/updates-available is a text
#    file you can read.
#
# [] Task count (TODO/FIXME)
# [] Clock
# [] SSH indicator
# [] sudo marker
# [] read-only directory marker
# [] Fish-style abbreviation: ~/p/s/components/auth (shorten all but the last segment).
#    PROMPT_DIRTRIM can't do this, but it's a pure-bash loop over ${PWD//\// }.
# [] background jobs
# [] vi/emacs indicator
# [] Transient prompt?

# Sets REPLY to the colored git segment, or to '' outside a repository.
__prompt::git() {  # {{{1
  REPLY=
  [[ ${THEME_GIT:-1} == 1 ]] || return 0

  local out line ab xy rc branch= oid= ahead=0 behind=0 stash=0
  local staged=0 unstaged=0 untracked=0 conflicts=0
  local -a opts=(--porcelain=v2 --branch --untracked-files="${THEME_GIT_UNTRACKED:-normal}")

  # One git call: branch, upstream ahead/behind, file states and stash count.
  # OPTIONAL_LOCKS=0 stops a prompt refresh from fighting other git commands.
  # --show-stash needs git >= 2.35; older git exits 129 (usage error), so
  # remember that once and stop asking.
  [[ -n ${THEME_GIT_NO_STASH:-} ]] || opts+=(--show-stash)
  out=$(GIT_OPTIONAL_LOCKS=0 git status "${opts[@]}" 2>/dev/null); rc=$?
  if (( rc == 129 )) && [[ -z ${THEME_GIT_NO_STASH:-} ]]; then
    THEME_GIT_NO_STASH=1
    unset 'opts[-1]'
    out=$(GIT_OPTIONAL_LOCKS=0 git status "${opts[@]}" 2>/dev/null); rc=$?
  fi
  (( rc == 0 )) || return 0

  while IFS= read -r line; do
    case $line in
      '# branch.head '*) branch=${line#'# branch.head '} ;;
      '# branch.oid '*)  oid=${line#'# branch.oid '} ;;
      '# stash '*)       stash=${line#'# stash '} ;;
      '# branch.ab '*)
        ab=${line#'# branch.ab '}
        ahead=${ab%% *};  ahead=${ahead#+}
        behind=${ab##* }; behind=${behind#-}
        ;;
      '1 '* | '2 '*) # changed / renamed: XY = staged, unstaged
        xy=${line:2:2}
        [[ ${xy:0:1} != . ]] && staged=1
        [[ ${xy:1:1} != . ]] && unstaged=1
        ;;
      'u '*) conflicts=1 ;;
      '? '*) untracked=1 ;;
    esac
  done <<<"$out"

  [[ $branch == '(detached)' ]] && branch=${oid:0:7}
  [[ -n $branch ]] || return 0

  # One extra fork, only while inside a repo. Checked via files in .git/
  # rather than another git command, since these are just file tests.
  local gitdir op=
  gitdir=$(git rev-parse --git-dir 2>/dev/null)
  if [[ -n $gitdir ]]; then
    if   [[ -f $gitdir/MERGE_HEAD ]];                              then op=merge
    elif [[ -f $gitdir/CHERRY_PICK_HEAD ]];                        then op=cherry-pick
    elif [[ -f $gitdir/REVERT_HEAD ]];                             then op=revert
    elif [[ -d $gitdir/rebase-merge || -d $gitdir/rebase-apply ]]; then op=rebase
    elif [[ -f $gitdir/BISECT_LOG ]];                              then op=bisect
    fi
  fi

  local up=↑ down=↓ r=${THEME_RL[reset]} seg flags=
  (( TERM_IS_CONSOLE )) && { up='^'; down='v'; }

  seg=":${THEME_RL[git]}${branch}${r}"

  [[ -n $op ]] && seg+=" ${THEME_RL[error]}${op}${r}"
  (( ahead ))  && seg+=" ${THEME_RL[arg]}${up}${ahead}${r}"
  (( behind )) && seg+=" ${THEME_RL[arg]}${down}${behind}${r}"

  (( conflicts )) && flags+="${THEME_RL[error]}="
  (( staged ))    && flags+="${THEME_RL[ok]}+"
  (( unstaged ))  && flags+="${THEME_RL[warn]}!"
  (( untracked )) && flags+="${THEME_RL[muted]}?"

  if (( stash )); then
    flags+="${THEME_RL[stash]:-${THEME_RL[arg]}}*"
    (( stash > 1 )) && flags+=$stash
  fi

  [[ -n $flags ]] && seg+=" ${flags}${r}"

  REPLY=$seg
}

# Sets REPLY to the colored python segment, or to '' when there is nothing
# to show. No forks: $VIRTUAL_ENV is just an env var (set by venv, virtualenv
# and uv alike), and .python-version is read directly rather than by asking
# pyenv, which would cost a fork per prompt.
__prompt::python() { # {{{1
    REPLY=
    [[ ${THEME_PYTHON:-1} == 1 ]] || return 0

    local venv= pyver= dir=$PWD line

    if [[ -n ${VIRTUAL_ENV:-} ]]; then
        venv=${VIRTUAL_ENV##*/}
        case $venv in         # an uninformative env dir name: use the
            .venv|venv|env|.env)   # project directory instead
                dir=${VIRTUAL_ENV%/*}
                venv=${dir##*/}
                dir=$PWD
                ;;
        esac
    fi

    if [[ -n ${PYENV_VERSION:-} ]]; then
        pyver=$PYENV_VERSION
    else
        while :; do
            if [[ -f $dir/.python-version ]]; then
                IFS= read -r line <"$dir/.python-version"
                pyver=${line//[^[:alnum:]._\/*-]/} # sanitize
                break
            fi
            [[ $dir == / || -z $dir ]] && break
            dir=${dir%/*}
            [[ -z $dir ]] && dir=/
        done
    fi

    [[ -n $venv || -n $pyver ]] || return 0

    local r=${THEME_RL[reset]} c=${THEME_RL[python]}
    local seg=" ${c}"
    [[ -n $venv ]]  && seg+="$venv"
    [[ -n $venv && -n $pyver ]] && seg+=" "
    [[ -n $pyver ]] && seg+="py${pyver}"
    seg+="$r"

    REPLY=$seg
}

# Sets REPLY to the colored node segment, or to '' when there is nothing to
# show. No forks: the active version is read from $NVM_BIN (nvm exports it
# on `nvm use`), and .nvmrc is read directly rather than shelling out to nvm.
__prompt::node() { # {{{1
    REPLY=
    [[ ${THEME_NODE:-1} == 1 ]] || return 0

    local active= pinned= dir=$PWD line

    if [[ -n ${NVM_BIN:-} ]]; then
        active=${NVM_BIN%/bin}   # .../versions/node/v20.11.0/bin -> v20.11.0
        active=${active##*/}
        active=${active#v}
    fi

    while :; do
        if [[ -f $dir/.nvmrc ]]; then
            IFS= read -r line <"$dir/.nvmrc"
            line=${line//[^[:alnum:]._\/*-]/} # sanitize
            pinned=${line#v}
            break
        fi
        [[ $dir == / || -z $dir ]] && break
        dir=${dir%/*}
        [[ -z $dir ]] && dir=/
    done

    [[ -n $active || -n $pinned ]] || return 0

    local r=${THEME_RL[reset]} c=${THEME_RL[node]} w=${THEME_RL[warn]}
    local seg=" ${c}node"
    if [[ -n $active ]]; then
        seg+="$active"
    else
        seg+="${pinned}?"   # pinned in .nvmrc but nvm hasn't activated a version this shell
    fi
    # Only compare when the pinned value is a plain version (not "lts/*" etc),
    # and only flag a real mismatch (active must start with the pinned value,
    # so a pinned "20" matches an active "20.11.0").
    if [[ -n $pinned && -n $active && $pinned == [0-9]* && $active != "$pinned"* ]]; then
        seg+=" ${w}!=${pinned}"
    fi
    seg+="$r"

    REPLY=$seg
}

# Sets REPLY to the colored shell-level segment, or to '' at the base level.
# $SHLVL is bumped by every nested shell (`bash`, `su`, `nix-shell`, an
# editor's :shell, ...) so this is a cheap reminder that `exit` returns to
# another shell rather than closing the terminal.
__prompt::shlvl() { # {{{1
    REPLY=
    [[ ${THEME_SHLVL:-1} == 1 ]] || return 0

    local lvl=${SHLVL:-1} base=${THEME_SHLVL_BASE:-1}
    (( lvl > base )) || return 0

    REPLY=" ${THEME_RL[warn]}lvl$(( lvl - base + 1 ))${THEME_RL[reset]}"
}

# Sets REPLY to the health segment: "[!]" if the error log has content, "[/]"
# if it is empty or missing, or '' when disabled. No forks.
__prompt::errlog() { # {{{1
    REPLY=
    [[ ${THEME_ERRLOG:-1} == 1 ]] || return 0

    local log=${THEME_ERRLOG_FILE:-/tmp/errors.log}
    local r=${THEME_RL[reset]} c=${THEME_RL[ok]} mark='[/]'

    if [[ -s $log ]]; then
        c=${THEME_RL[health]}
        mark='[!]'
    fi
    REPLY=" ${c}${mark}${r}"
}

# Right-most errlog
# __prompt::errlog() { # {{{1
#   REPLY=
#   [[ ${THEME_ERRLOG:-1} == 1 ]] || return 0
#
#   local log=${THEME_ERRLOG_FILE:-/tmp/errors.log}
#   local c=${THEME_SGR[ok]} mark='[/]'
#
#   if [[ -s $log ]]; then
#       c=${THEME_SGR[health]}
#       mark='[!]'
#   fi
#
#   local text="health${mark}"
#   local col=$(( COLUMNS - ${#text} + 1 ))
#   (( col < 1 )) && col=1
#
#   # \e7 / \e8 = save / restore cursor, \e[<n>G = jump to column n
#   REPLY=$'\001\e7\e['$col'G'${c}${text}${THEME_SGR[reset]}$'\e8\002'
# }


# [?] ErrLog at the right-most with auto-adjust on resize of the terminal (1 of 2)
#
# THEME_ERRLOG_TEXT=
# THEME_ERRLOG_COLOR=
# THEME_ERRLOG_COL=0
#
# __prompt::errlog() { # {{{1
#     REPLY=
#     THEME_ERRLOG_TEXT=
#     [[ ${THEME_ERRLOG:-1} == 1 ]] || return 0
#
#     local log=${THEME_ERRLOG_FILE:-/tmp/errors.log}
#     local c=${THEME_SGR[ok]} mark='[/]'
#
#     if [[ -s $log ]]; then
#         c=${THEME_SGR[health]}
#         mark='[!]'
#     fi
#
#     local text="health${mark}"
#     local col=$(( COLUMNS - ${#text} + 1 ))
#     (( col > 1 )) || return 0
#
#     THEME_ERRLOG_TEXT=$text
#     THEME_ERRLOG_COLOR=$c
#     THEME_ERRLOG_COL=$col
#     REPLY=$'\001\e7\e['$col'G'${c}${text}${THEME_SGR[reset]}$'\e8\002'
# }
# # Redraw the health segment at the new right edge after a window resize.
# # Only runs while sitting at the prompt (THEME_CMD_RUNNING is 0 then).
# __theme::errlog_winch() {
#     (( THEME_CMD_RUNNING )) && return 0
#     [[ -n $THEME_ERRLOG_TEXT ]] || return 0
#
#     # printf '\e[2J' # clear the screen.
#
#     # COLUMNS may not be updated yet inside the trap, so ask the tty (one fork per resize).
#     local sz cols col old=$THEME_ERRLOG_COL
#     sz=$(stty size 2>/dev/null </dev/tty) || return 0
#     cols=${sz#* }
#     col=$(( cols - ${#THEME_ERRLOG_TEXT} + 1 ))
#     (( col > 1 )) || return 0
#
#     printf '\e7\e[1A\e[2J'                                    # save cursor, up to the top line
#     (( old > 0 && old <= cols )) && printf '\e[%dG\e[K' "$old"   # wipe the old segment
#     printf '\e[%dG%s%s%s\e8' "$col" "$THEME_ERRLOG_COLOR" "$THEME_ERRLOG_TEXT" "${THEME_SGR[reset]}"
#     THEME_ERRLOG_COL=$col
# }
