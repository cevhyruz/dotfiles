#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

export TEST_DEPS_DIR="${TEST_DIRECTORY}/../test_lib"

load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"

load "${TEST_DEPS_DIR}/../Bash/lib/util.bash"

# shellcheck disable=SC2155
export TEST_FILE="$(echo -e "[\e[1m$(basename "${BATS_TEST_FILENAME}")\e[0m]")"

function local_setup() { true; }
function local_teardown() { true; }

function setup() {
  if [[ -n "${LOCAL_DEP:-}" ]] &&
    ! _::command_exists "${LOCAL_DEP}"; then
    skip "Missing Dependency: ${LOCAL_DEP}"
  fi
  local_setup
}

function teardown() {
  local_teardown
}
