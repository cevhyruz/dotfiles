#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"

function local_setup() {
  FIXTURE_LOCATION="/tmp/bash-test-fixture"
  EMPTY_DIR="${FIXTURE_LOCATION}/empty_dir"
  DIR="${FIXTURE_LOCATION}/a_dir"

  mkdir -p "${FIXTURE_LOCATION}" \
    && cd "${FIXTURE_LOCATION}" || return 1

  mkdir "${EMPTY_DIR}" "${DIR}"

  echo 'echo "file1"' >> "${DIR}/file1"
  echo 'echo "file3"' >> "${DIR}/file3"

# a file with syntax error
cat << EOF > "${DIR}/file2"
#!/usr/bin/env bash
  for (( i = 0; i < ; i++ ; do
EOF
}

function local_teardown() {
  rm -rf "${FIXTURE_LOCATION}"
}

# _::die {{{1
#
@test "${TEST_FILE}: bash-lib: Test '_::die()'" {
  run _::die "died"
  [ $status -eq 1 ]

  assert_output "died"
}

# _::is_dir {{{1
#
@test "${TEST_FILE}: Test '_::is_dir()'" {
  # non empty directory
  run _::is_dir "${DIR}"
  [ "${status}" -eq 0 ];

  # valid dir path with glob
  run _::is_dir "${DIR}/*"
  [ "${status}" -eq 1 ];

  run _::is_dir "/non/existing/path"
  [ "${status}" -eq 1 ];

  run _::is_dir "${DIR}/file1"
  [ "${status}" -eq 1 ];

  run _::is_dir "${EMPTY_DIR}"
  [ "${status}" -eq 1 ];
}

# _::is_file {{{1
#
@test "${TEST_FILE}: Test '_::is_file()'" {
  run _::is_file "/non/existing/path"
  [ "${status}" -eq 1 ];

  run _::is_file "${DIR}"
  [ "${status}" -eq 1 ];

  run _::is_file "${DIR}/file1"
  [ "${status}" -eq 0 ];

  # valid file path with glob
  run _::is_file "${DIR}file1/*"
  [ "${status}" -eq 1 ];
}

# _::add_to_path {{{1
#
@test "${TEST_FILE}: Test '_::add_to_path()'" {
  # for path that is already on the environment
  run _::add_to_path "/usr/local/bin"
  assert_success

  run _::add_to_path "${DIR}"
  assert_success
}

# _::source_file {{{1
#
@test "${TEST_FILE}: Test '_::source_file()'" {
  run _::source_file "${DIR}/file1"
  [ $status -eq 0 ]

  # file with syntax error
  run _::source_file "${DIR}/file2"
  assert_output "can't source '${DIR}/file2'"
  [ $status -eq 1 ]

  run _::source_file "/non/existent/path"
  assert_output "can't source '/non/existent/path'"
  [ $status -eq 1 ]
}

# _::source_files_from {{{1
#
@test "${TEST_FILE}: Test '_::source_files_from()'" {
  # dir with scripts that has syntax error (file2)
  run _::source_files_from "${DIR}"
  assert_output --partial "can't source '${DIR}/file2'"

  run _::source_files_from "${EMPTY_DIR}"
  [ $status -eq 1 ]
}

# _::source_all_from {{{1
#
@test "${TEST_FILE}: Test '_::source_all_from()'" {
  run _::source_all_from "${EMPTY_DIR}"
  [ "${status}" -eq 1 ];

  run _::source_all_from "/non/existent/path"
  [ "${status}" -eq 1 ];

  run _::source_all_from "${DIR}"
  assert_output --partial "can't source '${DIR}/file2'"
}

# _::command_exists {{{1
#
@test "${TEST_FILE}: Test '_::command_exists()'" {
  run _::command_exists 'foo'
  assert_failure 1

  run _::command_exists 'test'
  assert_success
}
