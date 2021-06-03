#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper
load ../../Bash/lib/hooks

@test "bash-hooks: pre_command should return if '\$AT_PROMPT' has not been set." {
  AT_PROMPT=''
  run pre_command
  assert_failure 1
}

@test "bash-hooks: post_command should return if '\$FIRST_PROMPT' has been set." {
  FIRST_PROMPT=1
  run post_command
  assert_failure 1
}

@test "bash-hooks: _run_hook should fail if no argument." {
  run _run_hook ''
  assert_failure 1
}

@test "bash-hooks: pre_command should execute command/functions in order of it's array." {
  AT_PROMPT=1
  PRE_COMMAND='echo one;'
  PRE_COMMAND+='echo two;'
  run pre_command
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}

@test "bash-hooks: post_command should execute command/functions in order of it's array." {
  POST_COMMAND='echo one;'
  POST_COMMAND+='echo two;'
  run post_command
  assert_line --index 0 "one"
  assert_line --index 1 "two"
  assert_success
}
