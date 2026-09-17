#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "${DOT_BASH}/core/envars.bash"

@test "Make sure envars has been set properly" {

  # mailcheck should unset when mailwarn is disabled.
  shopt -u mailwarn
  run test -v MAILCHECK
  assert_failure 1

  run test -v PROMPT_COMMAND
  assert_success

  run test -v HISTSIZE
  assert_success

  run test -v HISTFILESIZE
  assert_success

  run test -v HISTCONTROL
  assert_success

  run test -v HISTIGNORE
  assert_success

  run test -v VISUAL
  assert_success

  run printenv EDITOR
  assert_success
}
