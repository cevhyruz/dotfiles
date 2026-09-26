#!/usr/bin/env bats
# shellcheck shell=bash
# vi:ft=bash fdm=marker ts=2 sw=2 et

bats_require_minimum_version 1.5.0

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

# Sources the file under test (FUT) in an isolated interactive shell, then runs "$1" in it.
# Sets $output, $stderr, $status and the *_lines arrays like bats' `run`.
run_bashrc() {
  # Usage: run_bashrc [-i] [-p pre_cmd] post_cmd
  #
  #   -i           run interactively (via setsid -w bash -i), instead of non-interactive
  #   -p pre_cmd   command to run before sourcing bashrc (e.g. 'set -x', 'export FOO=bar')
  #   post_cmd     command/expression to run after sourcing bashrc; its output is
  #                captured via `run`, e.g. probing env vars set by bashrc
  #
  local interactive=0
  local pre_cmd=""

  local OPTIND=1
  while getopts "ip:" opt; do
    case "$opt" in
      i) interactive=1 ;;
      p) pre_cmd="$OPTARG" ;;
    esac
  done
  shift $((OPTIND - 1))

  local post_cmd="$1"
  local script="
    export XDG_CONFIG_HOME='$TEST_ROOT'
    ${pre_cmd:+$pre_cmd}
    source '$TEST_CONFIG_DIR/bashrc'
    rc=\$?
    ${post_cmd:+$post_cmd}
    exit \$rc
  "

  if [[ $interactive -eq 1 ]]; then
    # setsid -w    detaches from the controlling tty so parallel jobs don't fight
    #              over it (SIGTTIN/SIGTTOU); -w waits and keeps the exit status
    # -i           interactive, so the bashrc doesn't return early
    # < /dev/null  prevents blocking on stdin
    #
    # --separate-stderr  keeps stderr out of $output/$lines, into $stderr/
    #                    $stderr_lines, so warnings don't get mixed into the
    #                    command's actual output and can be asserted on
    #                    independently
    #
    run --separate-stderr setsid --wait bash --norc --noprofile -i -c "$script" < /dev/null

    # `bash -i` without a controlling terminal typically warns on stderr that it
    # can't set the terminal process group or has no job control. Strip those lines
    # so tests only see output from the file under test.
    #
    # NOTE: The exact text varies by bash version, and the patterns are English-only,
    # so on another locale the noise may leak through.
    #
    # `|| true` is required: grep -v exits 1 when every line is filtered out,
    # and bats runs helpers under `set -e`, so that would fail the test.
    stderr="$(grep -vE 'cannot set terminal process group|no job control in this shell' <<< "$stderr" || true)"

    # mapfile on an empty string yields one empty element, so use an empty
    # array instead, letting ${#stderr_lines[@]} be 0 when nothing is left.
    if [[ -n $stderr ]]; then
      mapfile -t stderr_lines <<< "$stderr"
    else
      stderr_lines=()
    fi
  else
    run --separate-stderr bash --norc --noprofile -c "$script"
  fi
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
