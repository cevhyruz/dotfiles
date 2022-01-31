#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/functions/general.functions.bash"

@test "${TEST_FILE}: Make sure general functions have been loaded." {
  run md ''
  assert_failure 1
  run fs .
  assert_success
  run fs
  assert_success
  run dataurl
  assert_success
  run colormap
  assert_success
  run truecolors
  assert_success
  run declare -F note
  assert_success
  run terminfo
  assert_success
}

@test "${TEST_FILE}: sure general functions have been loaded." {
  if ! command -v  pygmentize; then
    skip "test case requires pygmentize to be installed."
  fi
  run json '{"foo":42}'
  assert_line --index 0 '{'
  assert_line --index 2 '}'
  assert_success
}
