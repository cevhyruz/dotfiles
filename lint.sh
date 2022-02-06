#!/usr/bin/env bash

# Pull list of checkable files from clean_files.txt
#  - Folder references are allowed
#  - Empty lines are ignored
#  - Comment lines (#) are ignored
#
# shellcheck disable=SC2002  # Prefer 'cat' for cleaner script
mapfile -t FILES < <(
  cat .clean_files.txt |
    grep -v -E '^\s*$' |
    grep -v -E '^\s*#' |
    xargs -I{} find "{}" -type f
)

pre-commit run --files "${FILES[@]}"
