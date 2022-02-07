#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/lib/theme.bash"
load "Bash/themes/default.theme.bash"

@test "${TEST_FILE} hould be ready and initialized." {
  run echo 'test'
  assert_success
}
