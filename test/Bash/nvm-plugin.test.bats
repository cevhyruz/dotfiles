#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

@test "Make sure executables were loaded." {
  run which node npm npx
  assert_success
}
