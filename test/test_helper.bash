#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Dotfiles test suite helper file.
#
# Usage:
#   load "${TEST_DIRECTORY}/test_helper.bash"

set -o nounset

# helpers
load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"

# utilities
load "${DOT_BASH}/lib/util.bash"
load "${DOT_BASH}/lib/apidoc.bash"

if [[ -t 0 ]]; then
  TEST_FILE="$(printf "\e[1m[%s]\e[0m\n" "${BATS_TEST_FILENAME##*/}")"
fi

function local_setup() { :; }
function local_teardown() { :; }
function local_fixtures() { :; }

function fixtures() {
  local_fixtures
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
  local_teardown
}
