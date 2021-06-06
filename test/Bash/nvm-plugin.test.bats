#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper

load ../../Bash/plugins/nvm.plugin

TEST_NAME="bash-plugin [NVM]"

@test "${TEST_NAME}: Make sure no node/npm/npx is already on path" {
  run which -a node
  assert_failure 1

  run which -a npm
  assert_failure 1

  run which -a npx
  assert_failure 1
}

@test "${TEST_NAME}: Make sure node/npm/npx functions has been setup" {
  run declare -F node
  assert_success

  run declare -F npm
  assert_success

  run declare -F npx
  assert_success
}


@test "${TEST_NAME}: Make sure cleanup works as expected." {
  # We now load nvm main script file.
  nvm --version

  run declare -F node
  assert_failure 1

  run declare -F npm
  assert_failure 1

  run declare -F npx
  assert_failure 1
}
