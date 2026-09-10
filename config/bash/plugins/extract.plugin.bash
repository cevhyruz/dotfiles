#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Extract file(s) from compressed status.

function show_usage() {
cat <<EOF
Usage: $1 [option] <archives>
  options:
    -h  show this message and exit
    -v  verbosely list files processed
EOF
}


function extract() {
  local opt
  local OPTIND=1
  while getopts "hv" opt; do
    case "$opt" in
      h)
        show_usage "${FUNCNAME[0]}"
        return ;;
      v)
        local -r verbose='v' ;;
      ?)
        extract -h >&2
        return 1 ;;
    esac
  done

  shift $((OPTIND-1))

  if [[ $# -eq 0 ]]; then
    show_usage "${FUNCNAME[0]}" 
    return 1
  fi

  while [[ $# -gt 0 ]]; do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi

    local -r filename=$(basename -- $1)
    local -r dirname=$(dirname -- $1)
    local dest=$(\
      sed 's/\(\.tar\.bz2$\|\.tbz$\|\.tbz2$\|\.tar\.gz$\|\.tgz$\|\.tar$\|\.tar\.xz$\|\.txz$\|\.tar\.Z$\|\.7z$\|\.nupkg$\|\.zip$\|\.war$\|\.jar$\)//g' \
      <<< $filename
    )

    local -r destpath="${dirname}/${dest}"

    if [[ "$filename" = "$dest" ]]; then
      # archive type either not supported or it doesn't need dir creation
      dest=""
    else
      command mkdir -v "$dirname/$dest"
    fi

    if [ -f "$1" ]; then
      case "$1" in
           *.tar.bz2|*.tbz|*.tbz2) tar "x${verbose}jf" "$1" -C "${destpath}" ;;
                   *.tar.xz|*.txz) tar "x${verbose}Jf" "$1" -C "${destpath}" ;;
                   *.tar.gz|*.tgz) tar "x${verbose}zf" "$1" -C "${destpath}" ;;
                          *.tar.Z) tar "x${verbose}Zf" "$1" -C "${destpath}" ;;
                            *.bz2) bunzip2 "$1" ;;
                            *.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
                         *.pax.gz) gunzip "$1"; set -- "$@" "${1:0:-3}" ;;
                             *.gz) gunzip "$1" ;;
                            *.pax) pax -r -f "$1" ;;
                            *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
                            *.rar) unrar x "$1" ;;
                            *.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
                            *.tar) tar "x${verbose}f" "$1" -C "${destpath}" ;;
                             *.xz) xz --decompress "$1" ;;
        *.zip|*.war|*.jar|*.nupkg) unzip "$1" -d "${destpath}" ;;
                              *.Z) uncompress "$1" ;;
                              .7z) 7za x -o"${destpath}" "$1" ;;
        *) echo "'$1' cannot be extracted via extract" >&2 ;;
      esac
    fi
    shift
  done
}

