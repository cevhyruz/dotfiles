#!/usr/bin/env bats
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

set -o nounset
set -o errexit
set -o pipefail

load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"
load "${TEST_DEPS_DIR}/../Bash/lib/util.bash"

TEST_FILE="$(printf "%b" "\e[1m[$(basename "${BATS_TEST_FILENAME}")]\e[0m")"
test -v "${CI:-}" && TEST_FILE="[$(basename "${BATS_TEST_FILENAME}")]"
export TEST_FILE

function local_setup()    { true; }
function local_teardown() { true; }

function setup() {
  # Usage: export LOCAL_DEP="fzf"
  if [[ -n "${LOCAL_DEP:-}" ]] && ! _::command_exists "${LOCAL_DEP}"; then
    skip "Missing Dependency: ${LOCAL_DEP}"
  fi
  local_setup
}

function teardown() {
  local_teardown
}
