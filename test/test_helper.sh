#!/usr/bin/env bash

export TEST_MAIN_DIR="${BATS_TEST_DIRNAME}/.."
export TEST_DEPS_DIR="${TEST_DEPS_DIR-${TEST_MAIN_DIR}/../test/_lib}"

load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"
