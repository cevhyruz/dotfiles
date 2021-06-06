#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper

load ../../Bash/lib/util

load ../../Bash/plugins/fzf.plugin

function local_setup() {
  local -r dependency="fzf"
  _::command_exists "${dependency}" \
    || skip "Missing dependency: ${dependency}"
}

TEST_NAME="bash-plugin [FZF]"

@test "${TEST_NAME}: Verify fzf command has been set properly." {
  run bash -c "echo ${FZF_DEFAULT_COMMAND} | awk '{ print \$1 }'"
  assert_line --index 0 "$(basename "$(command -v ag || command -v rg || echo 'find')")"
}

@test "${TEST_NAME}: Verify that fzf aliases has been loaded." {
  run alias
  assert_line --index 0 "alias aliases='alias | fzf'"
  assert_line --index 1 "alias envars='printenv | fzf'"
}

@test "${TEST_NAME}: Check if fzf plugin has properly cleaned up itself" {
  run declare -F _set_fzf
  assert_failure 1

  run declare -F _set_fzf::_as_ag
  assert_failure 1

  run declare -F _set_fzf::_as_rg
  assert_failure 1

  run declare -F _set_fzf::_as_find
  assert_failure 1

  run declare -F _set_fzf::_as_envars
  assert_failure 1

  run declare -F _set_fzf::_cleanup
  assert_failure 1
}
