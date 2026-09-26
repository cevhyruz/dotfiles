#!/usr/bin/env bats
# shellcheck shell=bash
# vi:ft=bash fdm=marker ts=2 sw=2 et

load "${TEST_DIR}/test_helper.bash"

setup() {
  TEST_ROOT="$(mktemp -d)"
  TEST_CONFIG_DIR="$TEST_ROOT/bash"
  mkdir -p "$TEST_CONFIG_DIR/localrc"

  cp "${BASH_CONFIG_DIR}/bashrc" "$TEST_CONFIG_DIR/bashrc"

  echo 'INIT_LOADED=1' > "${TEST_CONFIG_DIR}/init.bash"
  echo 'MINIMAL_CONFIG_LOADED=1' > "$TEST_CONFIG_DIR/bashrc-minimal.bash"
  echo 'LOCALRC_LOADED=1' > "$TEST_CONFIG_DIR/localrc/bashrc.local"
}

teardown() {
  rm -rf "$TEST_ROOT"
}


@test "Should return silently with status code 1 when not running interactively" {
  run_bashrc -p 'set -x'

  assert_failure 1
  assert_output ''
  # Since the guard block returns before config_dir/config_file are ever
  # assigned, those names should never appear in the trace output.
  refute_stderr --partial 'config_dir='
  refute_stderr --partial 'config_file='
}

@test "Should warn if init.bash has errors but does not break the execution" {
  # returning with code > 0
  echo 'return 1' > "$TEST_CONFIG_DIR/init.bash"
  run_bashrc -i 'printf "%s" "${LOCALRC_LOADED-unset}"'
  assert_output '1'
  assert_stderr --partial 'Warning: failed to initialize config file'

  # parse error
  echo 'this is not valid bash ((' > "$TEST_CONFIG_DIR/init.bash"
  run_bashrc -i 'printf "%s" "${LOCALRC_LOADED-unset}"'
  assert_output '1'
  assert_stderr --partial 'Warning: failed to initialize config file'
}

@test "Should warn and load bashrc-minimal.bash when init.bash is missing" {
  rm "${TEST_CONFIG_DIR}/init.bash"
  run_bashrc -i 'printf "%s" "${LOCALRC_LOADED-unset}"'
  assert_output '1'
  assert_stderr --partial 'Warning: using minimal config'
}

@test "Should warn if bashrc-minimal.bash has errors but does not break the execution" {
  rm "${TEST_CONFIG_DIR}/init.bash"
  echo 'return 1' > "$TEST_CONFIG_DIR/bashrc-minimal.bash"
  run_bashrc -i 'printf "%s" "${LOCALRC_LOADED-unset}"'
  assert_output '1'
  assert_stderr --partial 'Warning: using minimal config'
  assert_stderr --partial 'Warning: failed to load minimal config'
}

@test "Should warn if bashrc.local has errors but does not break the execution" {
  echo 'return 1' > "$TEST_CONFIG_DIR/localrc/bashrc.local"
  run_bashrc -i 'printf "%s|%s|%s" "${config_dir-unset}" "${config_file-unset}" "${local_bashrc-unset}"'
  assert_success
  assert_output 'unset|unset|unset'
  assert_stderr --partial 'bashrc.local failed to load'
}

@test "Should not leak temporary variables" {
  run_bashrc -i 'printf "%s|%s|%s" "${config_dir-unset}" "${config_file-unset}" "${local_bashrc-unset}"'
  assert_output 'unset|unset|unset'
}
