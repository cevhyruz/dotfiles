#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

# _::load() {{{1
@test "script's function definitions should be loaded." {
  _::load "${test_home}/bash_script_file_1.bash"
  run declare -F fixture_foobar &> /dev/null
  assert_success
}
@test "namespace should be made based on script's file path." {
  _::load "${test_home}/bash_script_file_1.bash"
  run echo "${LOADER_STACK[@]}"
  assert_output '_home_devs_Projects_dotfiles_tmp_home_bash_script_file_1_bash'
}
@test "return if already loaded / namespace exists." {
  _::load "${test_home}/bash_script_file_1.bash"
  run _::load "${test_home}/bash_script_file_1.bash"
  assert_failure 1
}
# _::add_to_path {{{1
@test "appending to path." {
  _::add_to_path "${test_home}" "after"
  run echo "$(echo -e "${PATH//:/ }" | awk '{ print $NF }')"
  assert_output "${test_home}"
}
@test "prepending to path." {
  _::add_to_path "${test_home}" "before"
  run echo "$(echo -e "${PATH//:/ }" | awk '{ print $1 }')"
  assert_output "${test_home}"
}
@test "return when path already exists." {
  _::add_to_path "${test_home}" "before"
  run echo "$(echo -e "${PATH//:/ }" | awk '{ print $1 }')"
  assert_output "${test_home}"

  run _::add_to_path "${test_home}" "after"
  assert_failure
}
# _::command_exists {{{1
@test "success if exists, fail if not.'" {
  run _::command_exists 'foo'
  assert_failure 1

  run _::command_exists 'test'
  assert_success
}
