#!/usr/bin/env bash

function create_directories() {
  declare -a DIRECTORIES=(
    "${HOME}/.config"
    "${HOME}/Projects/cloned-repo"
    "${HOME}/Projects/forked-repo"
    "${HOME}/Pictures/screenshots"
    "${HOME}/Documents/notes"
  )
}

function main() {
  print::jobname "Create Directories"
  create_directories "$@"
}

main "$@"
