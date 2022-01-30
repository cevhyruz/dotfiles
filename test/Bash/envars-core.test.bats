#!/usr/bin/env bats
# vim: ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load 'Bash/core/envars.bash'

function has_value() {
  for var in "$@"; do
    if [[ -z "$var" ]]; then
      return 1
    fi
  done
  return 0
}

@test "${TEST_FILE}: Make sure Environment variables has been set." {
  local variable=(
    "${PROMPT_COMMAND}"
    "${VISUAL}"
    "${EDITOR}"
    "${HISTCONTROL}"
    "${HISTSIZE}"
    "${HISTFILESIZE}"
    "${HISTCONTROL}"
    "${HISTIGNORE}")

  run has_value "${variable[@]}"
  assert_success
}
