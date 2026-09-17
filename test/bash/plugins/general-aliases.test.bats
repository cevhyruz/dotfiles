#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "${DOT_BASH}/aliases/general.aliases.bash"

@test "Verify aliases has all been loaded" {
  local aliases=(
      "sudo"
      "home"
      "reload"
      "mv"
      "which"
      "path"
      "bashopts"
      "dir"
      "egrep"
      "fgrep"
      "grep"
      "lscolor"
      "vdir"
      "parent"
      "q"
      "c"
      "-"
      "ls"
      "dir"
  )

  for _alias in "${aliases[@]}"; do
    run alias "$_alias"
    assert_success
  done
}
