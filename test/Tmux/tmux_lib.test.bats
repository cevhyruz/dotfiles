#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

load "${HOME}/Projects/dotfiles/Tmux/core/options.bash"

@test "${TEST_FILE}: Tmux lib test" {
  run "tmux -Lfoobar show-options -sv buffer-limit"
  assert_output 25
}
