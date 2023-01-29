#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

@test "${TEST_FILE}: Make sure lazyloading works as expected." {
  LAZYLOAD_NVM=1
  load "Bash/plugins/nvm.plugin.bash"

  run declare -F node
  assert_success

  run declare -F npm
  assert_success

  run declare -F npx
  assert_success
}

@test "${TEST_FILE}: Make sure normal loading works as expected." {
  # shellcheck disable=SC2034
  LAZYLOAD_NVM=0
  load "Bash/plugins/nvm.plugin.bash"

  run declare -F node
  assert_failure 1

  run declare -F npm
  assert_failure 1

  run declare -F npx
  assert_failure 1
}

@test "${TEST_FILE}: Make sure no functions and variables were leaking." {
  run declare -F __set_nvm
  assert_failure 1

  run declare -F __load_script_files
  assert_failure 1

  run declare -F __lazy_load_nvm
  assert_failure 1

  run declare -F cleanup
  assert_failure 1
}
