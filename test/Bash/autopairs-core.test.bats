#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/core/autopairs.bash"

function local_setup() {
  case=( '""' "''" '()' '{}' '[]')
}

@test "${TEST_FILE}: double spaces inside of pairs." {
  for test_case in "${case[@]}"; do
    READLINE_LINE=${test_case}
    READLINE_POINT=1
    local wspace='  '
    # no double spacing inside '' and ""
    if [[ "${READLINE_LINE:0:1}" == "${READLINE_LINE:1:1}" ]]; then
      wspace=' '
    fi
    __smart_space
    assert_equal "${READLINE_LINE}" "${test_case:0:1}${wspace}${test_case:1:1}"
    assert_equal "${READLINE_POINT}" 2
  done
}

@test "${TEST_FILE}: spacing still works when no pairs." {
    READLINE_LINE=foobar
    READLINE_POINT=3
    __smart_space
    assert_equal "${READLINE_LINE}" 'foo bar'
    assert_equal "${READLINE_POINT}" 4
}

@test "${TEST_FILE}: backspace inside pairs." {
  for test_case in "${case[@]}"; do
    READLINE_LINE=${test_case}
    READLINE_POINT=1
    __depair
    assert_equal "${READLINE_LINE}" ""
    assert_equal "${READLINE_POINT}" 0
  done
}

@test "${TEST_FILE}: backspace stil works normally." {
  READLINE_LINE="foobar"
  READLINE_POINT=3
  __depair
  assert_equal "${READLINE_LINE}" 'fobar'
  assert_equal "${READLINE_POINT}" 2
}

@test "${TEST_FILE}: backspace inside pairs with spaces" {
  for test_case in "${case[@]}"; do
    READLINE_LINE="${test_case:0:1}  ${test_case:1:1}"
    READLINE_POINT=2
    local wspace=''
    # no double space clearing inside '' and ""
    if [[ "${test_case:0:1}" == "${test_case:1:1}" ]]; then
      wspace=' '
    fi
    __depair
    assert_equal "${READLINE_LINE}" "${test_case:0:1}${wspace}${test_case:1:1}"
    assert_equal "${READLINE_POINT}" 1
  done
}

@test "${TEST_FILE}: auto pair" {
  for test_case in "${case[@]}"; do
    READLINE_LINE="foo "
    READLINE_POINT=4
    __autopair "${test_case:0:1}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" "foo ${test_case:0:1}${test_case:1:1}"
  done
}

@test "${TEST_FILE}: bump cursor for already closed pairs" {
  for test_case in "${case[@]}"; do
    READLINE_LINE="foo ${test_case:0:1}${test_case:1:1}"
    READLINE_POINT=5
    local closing_char="${test_case:1:1}"
    # '' and ""
    if [[ "${test_case:0:1}" == "${test_case:1:1}" ]]; then
      closing_char="${test_case:0:1}"
    fi
    __autopair "${closing_char}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" "foo ${test_case:0:1}${closing_char}"
    assert_equal "${READLINE_POINT}" 6
  done
}

@test "${TEST_FILE}: no backspace when readline is empty" {
  READLINE_LINE=''
  READLINE_POINT=1
  run __depair
  assert_failure 1
}
