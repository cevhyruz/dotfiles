#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Dotfiles test suite helper file.
#
# Usage:
#   load "${TEST_DIRECTORY}/test_helper.bash"
set -o nounset
set -o errexit
set -o pipefail

load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"
load "${DOT_BASH}/lib/util.bash"
load "${DOT_BASH}/lib/apidoc.bash"

if [[ -t 0 ]]; then
  TEST_FILE="$(printf "\e[1m[%s]\e[0m\n" "${BATS_TEST_FILENAME}")"
fi

function local_setup() { :; }
function local_teardown() { :; }

function fixtures() {
  test_home="${DOTFILES}/tmp_home"
  mkdir -p "${test_home}"
  cp "${TEST_DIRECTORY}/fixtures/bash_script_file_1.bash" \
    "${test_home}/bash_script_file_1.bash"
}

function setup() {
  # usage: LOCAL_DEP="fzf"
  if ! _::command_exists "${LOCAL_DEP:-}" && [[ -n ${LOCAL_DEP:-} ]]; then
    skip "Missing Dependency: ${LOCAL_DEP:-}"
  fi

  if ! [[ -t 0 ]]; then
    TEST_FILE="[$(basename "${BATS_TEST_FILENAME}")]"
    if [[ "${BATS_TEST_NUMBER}" -eq 1 ]];then
      echo "# ${TEST_FILE}" >&3
    fi
  fi

  local_setup
  fixtures
}

function teardown() {
  rm -rf "${test_home}"
  local_teardown
}
