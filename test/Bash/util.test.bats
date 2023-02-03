#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

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
