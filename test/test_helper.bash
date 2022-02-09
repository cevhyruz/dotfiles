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
load "${TEST_DEPS_DIR}/../Bash/lib/util.bash"

TEST_FILE="$( printf "\e[1m[%s]\e[0m\n" "$(basename "${BATS_TEST_FILENAME}")")"
if [[ -n "${CI:-}" ]]; then
  TEST_FILE="[$(basename "${BATS_TEST_FILENAME}")]"
fi
export TEST_FILE

function local_setup()    { true; }
function local_teardown() { true; }

function _local_dependency() {
  # Usage: export LOCAL_DEP="fzf"
  if [[ -n "${LOCAL_DEP:-}" ]] &&
    ! _::command_exists "${LOCAL_DEP}"; then
    skip "Missing Dependency: ${LOCAL_DEP}"
  fi
}

function setup() {
  _local_dependency
  local_setup
}

function teardown() {
  local_teardown
}
