#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper

load ../../Bash/lib/util
load ../../Bash/plugins/pyenv.plugin

function local_setup() {
  export OLD_PATH="{$PATH}"
  export PATH="/usr/bin:/bin:/usr/sbin"
}

function local_teardown {
  export PATH="$OLD_PATH"
  unset OLD_PATH
}

TEST_NAME="bash-plugin [Pyenv]"

#@test "${TEST_NAME}: Verify that pyenv has properly loaded." {
  #run bash -c "printenv ${PATH} | grep 'pyenv'"
  #assert_success

  #run echo "${PYTHON_CONFIGURE_OPTS}"
  #assert_line --index 0 '--enable-shared'
#}
