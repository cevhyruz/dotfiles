#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper

load ../../Bash/lib/util
load ../../Bash/plugins/pyenv.plugin

TEST_NAME="bash-plugin [Pyenv]"

@test "${TEST_NAME}: Verify that pyenv hay properly loaded." {
  run bash -c "echo ${PATH} | grep 'pyenv'"
  assert_success

  run echo "${PYTHON_CONFIGURE_OPTS}"
  assert_line --index 0 '--enable-shared'
}
