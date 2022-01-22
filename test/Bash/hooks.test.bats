#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

inside_bats=1

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/lib/hooks.bash"

@test "${TEST_FILE} __pre_command should return if '\$AT_PROMPT' has not been set." {
  AT_PROMPT=''
  run __pre_command
  assert_failure 1
}

@test "${TEST_FILE} __post_command should return if '\$FIRST_PROMPT' has been set." {
  FIRST_PROMPT=1
  run __post_command
  assert_failure 1
}

@test "${TEST_FILE} __run_hook should fail if no argument." {
  run __run_hook ''
  assert_failure 1
}

@test "${TEST_FILE} __pre_command should run '\$PRE_COMMAND' in order of precedence" {
  AT_PROMPT=1
  PRE_COMMAND='echo one;'
  PRE_COMMAND+='echo two;'
  run __pre_command
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}

@test "${TEST_FILE} __post_command should run '\$POST_COMMAND in order or precedence'" {
  POST_COMMAND='echo one;'
  POST_COMMAND+='echo two;'
  run __post_command
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}
