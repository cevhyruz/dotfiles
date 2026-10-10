#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=bash fdm=marker ts=2 sw=2 et
#
# Clone the dotfiles and symlink their local/ pieces into ~/.local.
#
# <dotfiles>/local/bin/dotfiles      -> /home/cevhyruz/.local/bin/dotfiles
# <dotfiles>/local/share/bashlib/    -> /home/cevhyruz/.local/share/bashlib
# <dotfiles>/local/libexec/dotfiles/ -> /home/cevhyruz/.local/libexec/dotfiles
#
# Options:
#   -n, --dry-run   Show what would happen without changing anything
#   -v, --verbose   Show resolved paths and the decision behind each step
#   -h, --help      Show this help and exit


set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/cevhyruz/dotfiles.git}"
DEFAULT_DIR="$HOME/.dotfiles" # Projects/Personal/Dotfiles

BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
LIBEXEC_DIR="$HOME/.local/libexec" # no XDG variable exists for this one
PROFILE="$HOME/.profile"

DRY_RUN=0
VERBOSE=0

# helpers {{{

info() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

# Extra detail, only with --verbose. Uses `if` so a quiet run never returns
# non-zero (which would trip `set -e` in the caller).
debug() {
  if (( VERBOSE )); then
    printf '  [verbose] %s\n' "$*" >&2
  fi
}

usage() {
  cat <<EOF
Usage: bootstrap.sh [options]

Clone the dotfiles and symlink their local/ pieces into ~/.local.

Options:
  -n, --dry-run   Show what would happen without changing anything
  -v, --verbose   Show resolved paths and the decision behind each step
  -h, --help      Show this help and exit

Environment:
  DOTFILES_DIR    Where to clone the dotfiles (skips the prompt)
  DOTFILES_REPO   Repository URL (default: $REPO_URL)
  XDG_BIN_HOME    Where the dispatcher is linked (default: ~/.local/bin)
  XDG_DATA_HOME   Where bashlib is linked (default: ~/.local/share)

Links created:
  <dotfiles>/local/bin/dotfiles            -> $BIN_DIR/dotfiles
  <dotfiles>/local/share/bashlib/          -> $DATA_DIR/bashlib
  <dotfiles>/local/libexec/dotfiles/       -> $LIBEXEC_DIR/dotfiles

Examples:
  ./bootstrap.sh --dry-run
  ./bootstrap.sh --dry-run --verbose
  DOTFILES_DIR=~/dotfiles ./bootstrap.sh
  curl -fsSL <url>/bootstrap.sh | bash -s -- --dry-run

In dry-run mode every prompt is answered 'yes' so the full plan is shown;
nothing is cloned, created, moved, linked, or written.
EOF
}

parse_args() {
  while (( $# )); do
    case "$1" in
      -n|--dry-run) DRY_RUN=1 ;;
      -v|--verbose) VERBOSE=1 ;;
      -nv|-vn)      DRY_RUN=1; VERBOSE=1 ;;
      -h|--help)    usage; exit 0 ;;
      *)            warn "unknown option: $1"; usage >&2; exit 1 ;;
    esac
    shift
  done
}

# Run a command, or just print it in dry-run mode.
run() {
  if (( DRY_RUN )); then
    printf '[dry-run] %s\n' "$*"
  else
    debug "run: $*"
    "$@"
  fi
}

# True if we can actually read from the terminal (works under curl | bash).
has_tty() { { : < /dev/tty; } 2>/dev/null; }

# Ask a yes/no question, default NO. With no terminal, answers no.
# In dry-run mode, answers yes so the whole plan is shown.
confirm() {
  local prompt="$1" ans=""

  if (( DRY_RUN )); then
    info "[dry-run] assuming 'yes' for: $prompt"
    return 0
  fi

  if has_tty; then
    read -r -p "$prompt [y/N] " ans < /dev/tty || true
  else
    warn "no terminal available, assuming 'no' for: $prompt"
  fi
  [[ "$ans" =~ ^[Yy]$ ]]
}

# Ask for a directory, showing a default. Empty answer (or no terminal)
# returns the default. Expands a leading ~ and makes relative paths absolute.
ask_dir() {
  local prompt="$1" default="$2" ans=""
  if has_tty; then
    read -r -p "$prompt [$default] " ans < /dev/tty || true
  fi
  ans="${ans:-$default}"

  case "$ans" in
    "~")    ans="$HOME" ;;
    "~/"*)  ans="$HOME/${ans#"~/"}" ;;
    /*)     ;;
    *)      ans="$PWD/$ans" ;;
  esac

  printf '%s\n' "${ans%/}"
}

in_path() {
  case ":$PATH:" in
    *":$1:"*) return 0 ;;
    *)        return 1 ;;
  esac
}

# }}}

# 1. clone {{{

# DOTFILES_DIR from the environment skips the prompt (useful for automation).
choose_dir() {
  if [[ -n "${DOTFILES_DIR:-}" ]]; then
    info "Using DOTFILES_DIR from environment: $DOTFILES_DIR"
  else
    DOTFILES_DIR="$(ask_dir "Where should the dotfiles be cloned?" "$DEFAULT_DIR")"
  fi
}

clone_repo() {
  command -v git >/dev/null 2>&1 || die "git is required but not installed"

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    debug "$DOTFILES_DIR/.git exists"
    info "Repository already present at $DOTFILES_DIR, skipping clone"
  elif [[ -d "$DOTFILES_DIR" && -z "$(ls -A "$DOTFILES_DIR")" ]]; then
    debug "$DOTFILES_DIR exists and is empty"
    info "Cloning $REPO_URL into existing empty directory $DOTFILES_DIR"
    run git clone "$REPO_URL" "$DOTFILES_DIR"
  elif [[ -e "$DOTFILES_DIR" ]]; then
    die "$DOTFILES_DIR exists and is not an empty directory or a git repository"
  else
    debug "$DOTFILES_DIR does not exist"
    info "Cloning $REPO_URL into $DOTFILES_DIR"
    run mkdir -p "$(dirname "$DOTFILES_DIR")"
    run git clone "$REPO_URL" "$DOTFILES_DIR"
  fi

  # Nothing was cloned in dry-run mode, so there is nothing to validate yet.
  if (( DRY_RUN )) && [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    info "[dry-run] skipping source checks: repository not cloned"
    return 0
  fi

  [[ -f "$DOTFILES_DIR/local/bin/dotfiles" ]] \
    || die "dispatcher not found at $DOTFILES_DIR/local/bin/dotfiles"
  [[ -d "$DOTFILES_DIR/local/share/bashlib" ]] \
    || die "bashlib not found at $DOTFILES_DIR/local/share/bashlib"
  [[ -d "$DOTFILES_DIR/local/libexec/dotfiles" ]] \
    || die "libexec not found at $DOTFILES_DIR/local/libexec/dotfiles"
  debug "source check passed: local/bin/dotfiles, local/share/bashlib, local/libexec/dotfiles"
}

# }}}

# 2. directories and PATH {{{

# Make sure a directory exists, asking before creating it.
# Returns 1 if it is missing and the user declined.
ensure_dir() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    debug "directory exists: $dir"
    return 0
  fi

  if confirm "$dir does not exist. Create it?"; then
    run mkdir -p "$dir"
    (( DRY_RUN )) || info "Created $dir"
  else
    warn "skipping: $dir was not created"
    return 1
  fi
}

ensure_in_path() {
  if in_path "$BIN_DIR"; then
    debug "$BIN_DIR is already in PATH"
    return 0
  fi

  echo
  warn "$BIN_DIR is not in your current PATH"

  # Already configured in the profile? Then it only needs a new login.
  if [[ -f "$PROFILE" ]] && grep -qF "$BIN_DIR" "$PROFILE"; then
    info "$PROFILE already references $BIN_DIR; log out and back in to pick it up"
    return 0
  fi

  if confirm "Append a PATH entry for $BIN_DIR to $PROFILE?"; then
    if (( DRY_RUN )); then
      info "[dry-run] would append a PATH entry for $BIN_DIR to $PROFILE"
    else
      {
        printf '\n# added by dotfiles bootstrap\n'
        # shellcheck disable=SC2016
        printf 'case ":$PATH:" in *":%s:"*) ;; *) PATH="%s:$PATH" ;; esac\n' \
          "$BIN_DIR" "$BIN_DIR"
        printf 'export PATH\n'
      } >> "$PROFILE"
      info "Updated $PROFILE (log out and back in, or run: export PATH=\"$BIN_DIR:\$PATH\")"
    fi
  else
    info "Add it yourself: export PATH=\"$BIN_DIR:\$PATH\""
  fi
}

# }}}

# 3. symlinks {{{

# Symlink SRC (file or directory) to DEST. DEST's parent must exist or be
# created. Returns 0 if DEST ends up pointing at SRC, 1 if it was skipped.
#
# Paths must not have a trailing slash: `ln -sfn` would otherwise follow an
# existing directory symlink instead of replacing it.
link_path() {
  local src="${1%/}" dest="${2%/}"

  debug "link: $dest -> $src"
  ensure_dir "$(dirname "$dest")" || return 1

  if [[ -L "$dest" ]]; then
    debug "$dest is a symlink (currently -> $(readlink "$dest"))"
    if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      info "Already linked: $dest"
      return 0
    fi
    warn "$dest is a symlink to $(readlink "$dest")"
    confirm "Replace it with a link to $src?" \
      || { info "Left $dest unchanged"; return 1; }
  elif [[ -e "$dest" ]]; then
    debug "$dest exists as a regular file or directory"
    local backup
    backup="$dest.bak.$(date +%s)"
    warn "$dest exists and is not a symlink"
    confirm "Move it to $backup and link to $src?" \
      || { info "Left $dest unchanged"; return 1; }
    run mv -- "$dest" "$backup"
    (( DRY_RUN )) || info "Moved $dest -> $backup"
  fi

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    debug "$dest does not exist yet"
  fi
  run ln -sfn -- "$src" "$dest"
  (( DRY_RUN )) || info "Linked: $dest -> $src"
}

link_dispatcher() {
  run chmod +x "$DOTFILES_DIR/local/bin/dotfiles"
  link_path "$DOTFILES_DIR/local/bin/dotfiles" "$BIN_DIR/dotfiles"
}

link_bashlib() {
  link_path "$DOTFILES_DIR/local/share/bashlib" "$DATA_DIR/bashlib"
}

link_libexec() {
  link_path "$DOTFILES_DIR/local/libexec/dotfiles" "$LIBEXEC_DIR/dotfiles"
}

# }}}

main() {
  parse_args "$@"

  if (( DRY_RUN )); then
    info "Dry run: no changes will be made"
    echo
  fi

  if (( VERBOSE )); then
    debug "REPO_URL=$REPO_URL"
    debug "BIN_DIR=$BIN_DIR"
    debug "DATA_DIR=$DATA_DIR"
    debug "LIBEXEC_DIR=$LIBEXEC_DIR"
    debug "PROFILE=$PROFILE"
    if has_tty; then
      debug "interactive terminal: yes"
    else
      debug "interactive terminal: no (prompts default to 'no')"
    fi
    echo >&2
  fi

  choose_dir
  echo

  clone_repo
  echo

  if link_dispatcher; then
    ensure_in_path
  fi
  echo

  link_bashlib || true
  echo

  link_libexec || true
  echo

  if (( DRY_RUN )); then
    info "Dry run complete. Nothing was changed."
  else
    info "Done. Run 'dotfiles' to continue (or $DOTFILES_DIR/local/bin/dotfiles if PATH isn't updated yet)."
  fi
}

main "$@"
