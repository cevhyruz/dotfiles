#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
# load "${DOT_BASH}/plugins/fzf.plugin.bash"

LOCAL_DEP="fzf"

@test "Verify that '\$FZF_DEFAULT_COMMAND' has been set properly." {
  run bash -c "echo ${FZF_DEFAULT_COMMAND-} | awk '{ print \$1 }'"
  assert_line --index 0 "$(
    basename "$(
      command -v ag \
      || command -v rg \
      || command -v dfind
    )"
  )"
}

@test "Verify fzf keybindings has been loaded" {
  run bash -c "echo ${FZF_DEFAULT_OPTS-} | grep -qe '--bind'"
  assert_success
}

@test "Verify fzf theme has been loaded." {
  run bash -c "echo ${FZF_DEFAULT_OPTS-} | grep -qe '--color'"
  assert_success
}

@test "Verify that fzf aliases has been loaded." {
  run alias envars
  assert_success

  run alias aliases
  assert_success
}
