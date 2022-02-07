#!/usr/bin/env bats

load "${TEST_DIRECTORY}/test_helper.bash"

@test "${TEST_FILE}: verify that the install script exists" {
  assert_file_exist "install.sh"
}
