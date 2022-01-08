#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

export LOCAL_DEP="fzf"
load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/plugins/fzf.plugin.bash"

@test "${TEST_FILE}: Verify that '\$FZF_DEFAULT_COMMAND' has been set properly." {
  run bash -c "echo ${FZF_DEFAULT_COMMAND} | awk '{ print \$1 }'"
  assert_line --index 0 "$(basename "$(command -v ag || command -v rg || echo 'find')")"
}

@test "${TEST_FILE}: Verify that fzf aliases has been loaded." {
  run alias envars
  assert_success

  run alias aliases
  assert_success
}
