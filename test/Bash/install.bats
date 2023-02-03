#!/usr/bin/env bats

load "${TEST_DIRECTORY}/test_helper.bash"

@test "verify install script exists" {
  assert_file_exist "${DOTFILES}/install.sh"
}
