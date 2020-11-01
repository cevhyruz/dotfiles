#!/usr/bin/env bash
#
#    File:          functions.sh
#    Description:   Helper utility function for easy BASH shell scripting.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck source=/dev/null disable=SC2034


# sanity check.
declare -i DOTLIB_LOADED=1;

# Check if given path is a directory.
function lib::is_dir() {
  local -r DIR_PATH="${1}";

  if [[ -d "${DIR_PATH}" && -r "${DIR_PATH}" ]]
  then
    return 0;
  fi

  return 1;
}

# Check if given path is a file.
function lib::is_file() {
  local -r FILE_PATH="${1}";

  if [[ -f "${FILE_PATH}" ]] \
  || [[ -h "${FILE_PATH}" && -r "${FILE_PATH}" ]];
  then
    return 0;
  fi

  return 1;
}

# Add into environment path.
function lib::add_to_path() {
  local -r DIR_PATH="${1}";

  if printenv PATH \
  | grep --quiet "${DIR_PATH}";
  then
    PATH="${1}:${PATH}";
    return 0;
  fi

  return 1;
}

# Source all files in a given directory path.
function lib::source_files_from() {
  local -r FILE_PATH="${1}";

  lib::is_dir "${FILE_PATH}" || return 1;

  for FILE in "${FILE_PATH}"/*; do
    source "${FILE}";
  done

  return 0;
}


# Source all files in directory including it's sub-directories.
function lib::source_all_from() {
  local -r DIR_PATH="${1}";

  lib::is_dir "${DIR_PATH}" || return 1

  for CONTENT in "${DIR_PATH}"/*; do
    if lib::is_dir "${CONTENT}"; then
      lib::source_files_from "${CONTENT}"
    else
      source "${CONTENT}"
    fi
  done
}
