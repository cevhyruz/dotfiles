#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "${DOT_BASH}/core/hooks.bash"

@test "environment variables should be ready and initialized." {
  run test -v FIRST_PROMPT
  assert_success
}

@test "_exec_precmd will return if '\$AT_PROMPT' is unset." {
  unset AT_PROMPT
  run _exec_precmd
  assert_failure 1
}

@test "_exec_precmd should run '\$hooks_precmd[@]' in order of precedence." {
  AT_PROMPT=1
  ::pre_command "echo one"
  ::pre_command "echo two"
  run _exec_precmd
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}

@test "_exec_postcmd should return if '\$FIRST_PROMPT' has been set." {
  FIRST_PROMPT=1
  run _exec_postcmd
  assert_failure 1
}

@test "_exec_postcmd should run '\$hooks_postcmd[@]' in order or precedence." {
  unset FIRST_PROMPT
  ::post_command "echo one"
  ::post_command "echo two"
  run _exec_postcmd
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}
