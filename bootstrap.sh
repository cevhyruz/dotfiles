#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=bash fdm=marker ts=2 sw=2 et
#
# Bootstrap script for my dotfiles
#
# This will:
#
#  Download the dotfiles tarball (no git needed) and extract it into your location of choice
#  (or, with --link DIR, skip the download and use dotfiles you already have at DIR)
#  Symlink the file <dotfiles>/local/bin/dotfiles into '~/.local/bin/dotfiles'
#  Symlink the dir <dotfiles>/local/share/bashlib/ into '~/.local/share/bashlib/'
#  Symlink the dir <dotfiles>/local/libexec/dotfiles/ into '~/.local/libexec/dotfiles/'
#  Symlink the dir <dotfiles>/config/bash/ into '~/.config/bash/'
#  Symlink the file ~/.config/bash/bashrc into '~/.bashrc'
#
# Run with --help for usage, or --teardown to undo the symlinks (restoring any
# backups it made), remove the libexec directory if it ends up empty, and
# delete the extracted dotfiles.


set -euo pipefail

DOTFILES_BRANCH="${DOTFILES_BRANCH:-master}"
TARBALL_URL="${DOTFILES_TARBALL:-https://github.com/cevhyruz/dotfiles/archive/refs/heads/$DOTFILES_BRANCH.tar.gz}"
DEFAULT_DIR="$HOME/.dotfiles" # Projects/Personal/Dotfiles

BIN_DIR="${XDG_BIN_HOME:-$HOME/.local/bin}"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
LIBEXEC_DIR="$HOME/.local/libexec" # no XDG variable exists for this one

TEARDOWN=0
LINK_DIR=""

# helpers {{{

info() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: bootstrap.sh [options]

Download the dotfiles tarball and symlink their pieces into place.
Requires only curl and tar (no git).

Options:
  -l, --link DIR  Don't download anything; link the dotfiles already at DIR
  -t, --teardown  Remove the symlinks this script created, restore backups,
                  remove ~/.local/libexec if it ends up empty, and delete
                  the extracted dotfiles (asks first)
  -h, --help      Show this help and exit

Environment:
  DOTFILES_DIR     Where to extract the dotfiles (skips the prompt)
  DOTFILES_BRANCH  Branch to download (default: master)
  DOTFILES_TARBALL Full tarball URL (overrides DOTFILES_BRANCH)
  XDG_BIN_HOME     Where the dispatcher is linked (default: ~/.local/bin)
  XDG_DATA_HOME    Where bashlib is linked (default: ~/.local/share)
  XDG_CONFIG_HOME  Where the bash config is linked (default: ~/.config)

Links created:
  <dotfiles>/local/bin/dotfiles            -> $BIN_DIR/dotfiles
  <dotfiles>/local/share/bashlib/          -> $DATA_DIR/bashlib
  <dotfiles>/local/libexec/dotfiles/       -> $LIBEXEC_DIR/dotfiles
  <dotfiles>/config/bash/                  -> $CONFIG_DIR/bash
  <config>/bash/bashrc                     -> $HOME/.bashrc

Examples:
  ./bootstrap.sh
  ./bootstrap.sh --teardown
  ./bootstrap.sh --link ~/Projects/Personal/Dotfiles
  DOTFILES_DIR=~/dotfiles ./bootstrap.sh
  curl -fsSL <url>/bootstrap.sh | bash

Teardown only removes symlinks that point where this script put them. It
then offers to delete the extracted dotfiles directory, but never a git
repository.

--link overrides DOTFILES_DIR, and can't be combined with --teardown.
EOF
}

parse_args() {
  local args=() arg i

  # Split bundled short flags: -tl becomes -t -l.
  for arg in "$@"; do
    if [[ "$arg" =~ ^-[A-Za-z]{2,}$ ]]; then
      for (( i = 1; i < ${#arg}; i++ )); do
        args+=("-${arg:i:1}")
      done
    else
      args+=("$arg")
    fi
  done

  set -- ${args[@]+"${args[@]}"}

  while (( $# )); do
    case "$1" in
      -t|--teardown) TEARDOWN=1 ;;
      -l|--link)
        if (( $# < 2 )) || [[ "$2" == -* ]]; then
          die "$1 requires a directory"
        fi
        LINK_DIR="$2"
        shift
        ;;
      --link=*)
        LINK_DIR="${1#--link=}"
        [[ -n "$LINK_DIR" ]] || die "--link requires a directory"
        ;;
      -h|--help)     usage; exit 0 ;;
      *)             warn "unknown option: $1"; usage >&2; exit 1 ;;
    esac

    shift
  done
}

# True if we can actually read from the terminal (works under curl | bash).
has_tty() { { : < /dev/tty; } 2>/dev/null; }

# Ask a yes/no question, default NO. With no terminal, answers no.
confirm() {
  local prompt="$1" ans=""

  if has_tty; then
    read -r -p "$prompt [y/N] " ans < /dev/tty || true
  else
    warn "no terminal available, assuming 'no' for: $prompt"
  fi
  [[ "$ans" =~ ^[Yy]$ ]]
}

# Expand a leading ~ and make relative paths absolute (no trailing slash).
abs_path() {
  local p="$1"

  case "$p" in
    "~")    p="$HOME" ;;
    "~/"*)  p="$HOME/${p#"~/"}" ;;
    /*)     ;;
    *)      p="$PWD/$p" ;;
  esac

  printf '%s\n' "${p%/}"
}

# Ask for a directory, showing a default. Empty answer (or no terminal)
# returns the default. Expands a leading ~ and makes relative paths absolute.
ask_dir() {
  local prompt="$1" default="$2" ans=""
  if has_tty; then
    read -r -p "$prompt [$default] " ans < /dev/tty || true
  fi

  abs_path "${ans:-$default}"
}

# }}}

# 1. download {{{

# DOTFILES_DIR from the environment skips the prompt (useful for automation).
choose_dir() {
  local prompt="${1:-Where should the dotfiles be extracted?}"

  if [[ -n "${DOTFILES_DIR:-}" ]]; then
    info "Using DOTFILES_DIR from environment: $DOTFILES_DIR"
  else
    DOTFILES_DIR="$(ask_dir "$prompt" "$DEFAULT_DIR")"
  fi
}

# Download the tarball and extract it into DOTFILES_DIR.
#
# Everything is staged in a temp directory first, so DOTFILES_DIR only
# appears once the download and extraction have both succeeded.
fetch_tarball() {
  command -v curl >/dev/null 2>&1 || die "curl is required but not installed"
  command -v tar  >/dev/null 2>&1 || die "tar is required but not installed"

  local tmp
  tmp="$(mktemp -d)"
  mkdir "$tmp/src"

  if ! curl -fsSL "$TARBALL_URL" -o "$tmp/dotfiles.tar.gz"; then
    rm -rf "$tmp"
    die "download failed: $TARBALL_URL"
  fi

  # --strip-components=1 drops GitHub's wrapper folder (dotfiles-<branch>/).
  if ! tar -xzf "$tmp/dotfiles.tar.gz" --strip-components=1 -C "$tmp/src"; then
    rm -rf "$tmp"
    die "could not extract the tarball"
  fi

  mkdir -p "$(dirname "$DOTFILES_DIR")"

  # An existing empty directory would make mv nest inside it.
  if [[ -d "$DOTFILES_DIR" ]]; then
    rmdir "$DOTFILES_DIR"
  fi

  mv "$tmp/src" "$DOTFILES_DIR"
  rm -rf "$tmp"
}

# Make sure DOTFILES_DIR has everything the linking steps need.
check_source() {
  [[ -f "$DOTFILES_DIR/local/bin/dotfiles" ]] \
    || die "dispatcher not found at $DOTFILES_DIR/local/bin/dotfiles"
  [[ -d "$DOTFILES_DIR/local/share/bashlib" ]] \
    || die "bashlib not found at $DOTFILES_DIR/local/share/bashlib"
  [[ -d "$DOTFILES_DIR/local/libexec/dotfiles" ]] \
    || die "libexec not found at $DOTFILES_DIR/local/libexec/dotfiles"
  [[ -d "$DOTFILES_DIR/config/bash" ]] \
    || die "bash config not found at $DOTFILES_DIR/config/bash"
  [[ -f "$DOTFILES_DIR/config/bash/bashrc" ]] \
    || die "bashrc not found at $DOTFILES_DIR/config/bash/bashrc"
}

fetch_dotfiles() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Repository already present at $DOTFILES_DIR, skipping download"

  elif [[ -f "$DOTFILES_DIR/local/bin/dotfiles" ]]; then
    info "Dotfiles already present at $DOTFILES_DIR, skipping download"

  elif [[ -d "$DOTFILES_DIR" && -n "$(ls -A "$DOTFILES_DIR")" ]]; then
    die "$DOTFILES_DIR exists and is not empty (and doesn't look like these dotfiles)"

  else
    info "Downloading $TARBALL_URL into $DOTFILES_DIR"
    fetch_tarball
  fi

  check_source
}

# }}}

# 2. directories {{{

# Make sure a directory exists, asking before creating it.
# Returns 1 if it is missing and the user declined.
ensure_dir() {
  local dir="$1"

  if [[ -d "$dir" ]]; then
    return 0
  fi

  if confirm "$dir does not exist. Create it?"; then
    mkdir -p "$dir"
    info "Created $dir"
  else
    warn "skipping: $dir was not created"
    return 1
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

  ensure_dir "$(dirname "$dest")" || return 1

  if [[ -L "$dest" ]]; then
    if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      info "Already linked: $dest"
      return 0
    fi
    warn "$dest is a symlink to $(readlink "$dest")"
    confirm "Replace it with a link to $src?" \
      || { info "Left $dest unchanged"; return 1; }
  elif [[ -e "$dest" ]]; then
    local backup
    backup="$dest.bak.$(date +%s)"
    warn "$dest exists and is not a symlink"
    confirm "Move it to $backup and link to $src?" \
      || { info "Left $dest unchanged"; return 1; }
    mv -- "$dest" "$backup"
    info "Moved $dest -> $backup"
  fi

  ln -sfn -- "$src" "$dest"
  info "Linked: $dest -> $src"
}

link_dispatcher() {
  chmod +x "$DOTFILES_DIR/local/bin/dotfiles"
  link_path "$DOTFILES_DIR/local/bin/dotfiles" "$BIN_DIR/dotfiles"
}

link_bashlib() {
  link_path "$DOTFILES_DIR/local/share/bashlib" "$DATA_DIR/bashlib"
}

link_libexec() {
  link_path "$DOTFILES_DIR/local/libexec/dotfiles" "$LIBEXEC_DIR/dotfiles"
}

link_bash_config() {
  link_path "$DOTFILES_DIR/config/bash" "$CONFIG_DIR/bash"
}

link_bashrc() {
  local src="$CONFIG_DIR/bash/bashrc"

  # The target is reached through the config/bash link, so that link must be
  # in place first.
  if [[ ! -e "$src" ]]; then
    warn "$src not found (is the config/bash link in place?)"
    return 1
  fi

  link_path "$src" "$HOME/.bashrc"
}

# }}}

# 4. teardown {{{

# Print the newest "<path>.bak.<timestamp>" backup next to PATH, if any.
find_backup() {
  local path="$1"

  find "$(dirname "$path")" -maxdepth 1 -name "$(basename "$path").bak.*" 2>/dev/null \
    | sort | tail -n 1
}


# Inverse of link_path: remove DEST if it is a symlink to SRC, then restore
# the newest backup link_path made, if there is one. Anything that is not
# exactly our symlink is left alone. Returns 1 if DEST was left alone.
unlink_path() {
  local src="${1%/}" dest="${2%/}"

  if [[ ! -e "$dest" && ! -L "$dest" ]]; then
    info "Not present: $dest"
    return 0
  fi

  if [[ ! -L "$dest" ]]; then
    warn "$dest is not a symlink, leaving it alone"
    return 1
  fi

  local target rdest rsrc ours=0
  target="$(readlink "$dest")"
  rdest="$(readlink -f "$dest" 2>/dev/null || true)"
  rsrc="$(readlink -f "$src" 2>/dev/null || true)"

  # Literal match also covers a dangling link (dotfiles directory already gone).
  if [[ "$target" == "$src" ]]; then
    ours=1
  elif [[ -n "$rdest" && "$rdest" == "$rsrc" ]]; then
    ours=1
  fi

  if (( ! ours )); then
    warn "$dest points to $target, not $src; leaving it alone"
    return 1
  fi

  rm -- "$dest"
  info "Removed: $dest"

  local backup
  backup="$(find_backup "$dest" || true)"

  if [[ -n "$backup" ]]; then
    mv -- "$backup" "$dest"
    info "Restored backup: $backup -> $dest"
  fi
}


# Remove DIR (non-recursively, so it can never delete content) if nothing is
# left in it.
remove_dir_if_empty() {
  local dir="${1%/}" remaining

  if [[ ! -d "$dir" || -L "$dir" ]]; then
    return 0
  fi

  remaining="$(find "$dir" -mindepth 1 -maxdepth 1 2>/dev/null | head -n 1)"

  if [[ -n "$remaining" ]]; then
    return 0
  fi

  rmdir -- "$dir"
  info "Removed empty directory: $dir"
}


unlink_bashrc() {
  unlink_path "$CONFIG_DIR/bash/bashrc" "$HOME/.bashrc"
}


unlink_bash_config() {
  unlink_path "$DOTFILES_DIR/config/bash" "$CONFIG_DIR/bash"
}


# Also removes the libexec directory itself, but only if nothing else is in it.
unlink_libexec() {
  local rc=0

  unlink_path "$DOTFILES_DIR/local/libexec/dotfiles" "$LIBEXEC_DIR/dotfiles" || rc=$?

  remove_dir_if_empty "$LIBEXEC_DIR"

  return "$rc"
}


unlink_bashlib() {
  unlink_path "$DOTFILES_DIR/local/share/bashlib" "$DATA_DIR/bashlib"
}


unlink_dispatcher() {
  unlink_path "$DOTFILES_DIR/local/bin/dotfiles" "$BIN_DIR/dotfiles"
}


# Delete the extracted dotfiles directory. Meant for a tarball extract only:
# it refuses a git repository (history, unpushed work), a symlink, anything
# that doesn't look like these dotfiles, and any path that contains $HOME.
# Returns 1 if the directory was kept.
remove_dotfiles_dir() {
  local dir="${DOTFILES_DIR%/}" real

  if [[ ! -e "$dir" && ! -L "$dir" ]]; then
    info "Not present: $dir"
    return 0
  fi

  if [[ -L "$dir" ]]; then
    warn "$dir is a symlink; not deleting it"
    return 1
  fi

  if [[ -d "$dir/.git" ]]; then
    warn "$dir is a git repository, not a tarball extract; not deleting it"
    return 1
  fi

  if [[ ! -f "$dir/local/bin/dotfiles" ]]; then
    warn "$dir doesn't look like these dotfiles; not deleting it"
    return 1
  fi

  real="$(readlink -f "$dir" 2>/dev/null || true)"

  if [[ -z "$real" || "$real" == "/" || "$HOME" == "$real" || "$HOME" == "$real"/* ]]; then
    warn "refusing to delete $dir (resolves to '$real')"
    return 1
  fi

  confirm "Delete $dir? Any local edits in it will be lost." || return 1

  rm -rf -- "$dir"
  info "Deleted: $dir"
}


# Reverse order of install: ~/.bashrc points through the config/bash link,
# so it has to go first.
teardown() {
  choose_dir "Where are the dotfiles?"
  echo

  unlink_bashrc || true
  echo

  unlink_bash_config || true
  echo

  unlink_libexec || true
  echo

  unlink_bashlib || true
  echo

  unlink_dispatcher || true
  echo

  if ! remove_dotfiles_dir; then
    info "Left in place: $DOTFILES_DIR"
  fi
  echo

  info "Teardown complete."
}

# }}}


main() {
  parse_args "$@"

  if (( TEARDOWN )); then
    [[ -z "$LINK_DIR" ]] || die "--link and --teardown can't be combined"
    teardown
    return 0
  fi

  if [[ -n "$LINK_DIR" ]]; then
    DOTFILES_DIR="$(abs_path "$LINK_DIR")"
    [[ -d "$DOTFILES_DIR" ]] || die "not a directory: $DOTFILES_DIR"
    info "Linking from $DOTFILES_DIR (no download)"
    check_source
  else
    choose_dir
    echo

    fetch_dotfiles
  fi
  echo

  link_dispatcher || true
  echo

  link_bashlib || true
  echo

  link_libexec || true
  echo

  link_bash_config || true
  echo

  link_bashrc || true
  echo

  info "Done. Run 'dotfiles' to continue (or $DOTFILES_DIR/local/bin/dotfiles if PATH isn't updated yet)."
}

main "$@"
