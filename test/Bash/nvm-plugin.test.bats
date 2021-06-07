#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper


function local_setup() {
  unset LAZYLOAD_NVM
}

TEST_NAME="bash-plugin [NVM]"

@test "${TEST_NAME}: Make sure lazyloading works as expected." {

  LAZYLOAD_NVM=1
  load ../../Bash/plugins/nvm.plugin

   #>&3 echo 'test'
  run declare -F node
  assert_success

  run declare -F npm
  assert_success

  run declare -F npx
  assert_success
}

@test "${TEST_NAME}: Make sure normal loading works as expected." {

  load ../../Bash/plugins/nvm.plugin

  run declare -F node
  assert_failure 1

  run declare -F npm
  assert_failure 1

  run declare -F npx
  assert_failure 1
}
