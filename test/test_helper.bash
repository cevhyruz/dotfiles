#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"

load "${TEST_DEPS_DIR}/../Bash/lib/util.bash"

function _make_test_name() {
  printf "\e[1m[%s]\e[0m" "$(basename "${BATS_TEST_FILENAME}")"
}

TEST_FILE="$(_make_test_name)"
export TEST_FILE

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
