#!/usr/bin/env bash
#
# simple note-taking tool.

function note() {
  for param in "$@"; do
    shift
    case "$param" in
      "--help") set -- "$@" "-h" ;;
      "--silent") set -- "$@" "-s" ;;
      "--interactive") set -- "$@" "-i" ;;
      "--no-modify-config") set -- "$@" "-n" ;;
      "--append-to-config") set -- "$@" "-a" ;;
      "--overwrite-backup") set -- "$@" "-f" ;;
      *) set -- "$@" "$param" ;;
    esac
  done

  OPTIND=1
  while getopts "hsinaf" opt; do
    case "$opt" in
      "h")
        usage
        return 0
        ;;
      "s") ;;
      "i") ;;
      "n") ;;
      "a") ;;
      "f") ;;
      "?")
        usage >&2
        return 1
        ;;
    esac
  done

  shift $((OPTIND - 1))
}

function usage() {
	echo -e "Usage:\nnote [arguments] \n"
	echo "Arguments:"
	echo "--help (-h)             Display this help message"
	echo "--create (-h)             Display this help message"
}
