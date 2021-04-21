#!/usr/bin/env bats
#
#  File:          test.sh
#  Description:   Entry file for running all bats test cases.

load "${HOME}/Projects/dotfiles/bash/lib/lib.bash"

VALID_DIR_PATH="/usr/local/bin"
VALID_FILE_PATH="/etc/profile"
NON_EXISTING_PATH="/non/existing/path"

PROC_ENV="TEST";

# lib::is_dir

@test "'lib::is_dir' fail when given invalid path" {
  run lib::is_dir "${NON_EXISTING_PATH}"
  [ "${status}" -eq 1 ];
}

@test "'lib::is_dir' fail when given a valid file path" {
  run lib::is_dir "${VALID_FILE_PATH}"
  [ "${status}" -eq 1 ];
}

@test "'lib::is_dir' success when given valid directory path" {
  run lib::is_dir "${VALID_DIR_PATH}"
  [ "${status}" -eq 0 ];
}

# lib::is_file

@test "'lib::is_file' fail when given an invalid path" {
  run lib::is_file "${NON_EXISTING_PATH}"
  [ "${status}" -eq 1 ];
}

@test "'lib::is_file' fail when given a directory path" {
  run lib::is_file "${VALID_DIR_PATH}"
  [ "${status}" -eq 1 ];
}

@test "'lib::is_file' success when given a valid file path" {
  run lib::is_file "${VALID_FILE_PATH}"
  [ "${status}" -eq 0 ];
}

#lib::source_all_from

#@test "'lib::source_all_from' success when given a valid dir path" {
  #run lib::source_all_from "${VALID_DIR_PATH}"
  #[ "${output}" = "dir" ];
#}
