#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Dotfiles test suite helper file.
#
# Usage:
#   load "${TEST_DIRECTORY}/test_helper.bash"


bats_require_minimum_version 1.5.0

# load the BATS modules we use:
load "${TEST_DEPS_DIR}/bats-support/load.bash"
load "${TEST_DEPS_DIR}/bats-assert/load.bash"
load "${TEST_DEPS_DIR}/bats-file/load.bash"

# utilities
load "${BASH_CONFIG_DIR}/lib/utils.bash"

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
