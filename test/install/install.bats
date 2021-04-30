#!/usr/bin/env bats

load ../test_helper

@test "install: verify that the install script exists" {
  assert_file_exist "${DOTFILES_BASH_DIR}/install.sh"
}
