#!/usr/bin/env bash
#
# install.sh — fetch & install pinned fonts (Nerd Fonts, Font Awesome).
# PowerlineSymbols is handled separately as its own stow package
# (fonts/powerline-symbols/), since it's a single small vendored file.
#
# Usage: ./install.sh

set -euo pipefail
IFS=$'\n\t'

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly MANIFEST="${SCRIPT_DIR}/manifest.conf"
readonly TMP_DIR="$(mktemp -d)"

trap 'cleanup' EXIT INT TERM

cleanup() {
    local -r rc=$?
    rm -rf -- "${TMP_DIR}"
    exit "${rc}"
}

log() {
    printf '[fonts] %s\n' "$1"
}

err() {
    printf '[fonts] error: %s\n' "$1" >&2
}

require_cmd() {
    if ! __util::command_exists "$1"; then
        err "missing required command: $1"
        exit 1
    fi
}

# Minimal standalone fallback if lib/__util isn't sourced into this shell.
if ! declare -f __util::command_exists &>/dev/null; then
    __util::command_exists() { command -v "$1" &>/dev/null; }
fi

install_nerd_fonts() {
    local name url zip
    for name in "${NERD_FONT_NAMES[@]}"; do
        if compgen -G "${FONT_DIR}/${name}"'*NerdFont*' &>/dev/null; then
            log "NerdFont ${name} already installed, skipping"
            continue
        fi

        url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${name}.zip"
        zip="${TMP_DIR}/${name}.zip"

        log "downloading NerdFont ${name} (${NERD_FONT_VERSION})"
        curl -fsSL -o "${zip}" "${url}"

        log "extracting ${name}"
        unzip -q -o "${zip}" -d "${TMP_DIR}/${name}" -- '*.ttf' '*.otf' 2>/dev/null || true
        mkdir -p -- "${FONT_DIR}"
        find "${TMP_DIR}/${name}" -type f \( -name '*.ttf' -o -name '*.otf' \) \
            -exec cp -f -- {} "${FONT_DIR}/" \;
    done
}

install_font_awesome() {
    local zip extract_dir

    if compgen -G "${FONT_DIR}/fa-*" &>/dev/null || compgen -G "${FONT_DIR}/Font Awesome*" &>/dev/null; then
        log "Font Awesome ${FA_VERSION} already installed, skipping"
        return
    fi

    zip="${TMP_DIR}/fontawesome.zip"
    extract_dir="${TMP_DIR}/fontawesome"

    log "downloading Font Awesome ${FA_VERSION}"
    curl -fsSL -o "${zip}" "${FA_URL}"

    log "extracting Font Awesome webfonts"
    unzip -q -o "${zip}" -d "${extract_dir}"

    mkdir -p -- "${FONT_DIR}"
    find "${extract_dir}" -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.woff2' \) \
        -path '*webfonts*' -exec cp -f -- {} "${FONT_DIR}/" \;
}

refresh_font_cache() {
    if __util::command_exists fc-cache; then
        log "refreshing font cache"
        fc-cache -f "${FONT_DIR}" &>/dev/null
    fi
}

main() {
    require_cmd curl
    require_cmd unzip

    # shellcheck source=manifest.conf
    source "${MANIFEST}"

    install_nerd_fonts
    install_font_awesome
    refresh_font_cache

    log "done. PowerlineSymbols is installed separately via:"
    log "  stow -t \$HOME powerline-symbols"
}

main "$@"
