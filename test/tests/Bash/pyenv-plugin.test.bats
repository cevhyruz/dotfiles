#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

load "Bash/plugins/pyenv.plugin.bash"

@test "${TEST_FILE}: Verify that pyenv has properly loaded." {
  run echo "${PYTHON_CONFIGURE_OPTS}"
  assert_line --index 0 '--enable-shared'
}
