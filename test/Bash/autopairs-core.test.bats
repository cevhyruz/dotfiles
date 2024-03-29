#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "${DOT_BASH}/core/autopairs.bash"

function local_setup() {
  case=( '""' "''" '()' '{}' '[]')
}

@test "double spaces inside of pairs." {
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

@test "spacing still works when no pairs." {
    READLINE_LINE=foobar
    READLINE_POINT=3
    __smart_space
    assert_equal "${READLINE_LINE}" 'foo bar'
    assert_equal "${READLINE_POINT}" 4
}

@test "backspace inside pairs." {
  for test_case in "${case[@]}"; do
    READLINE_LINE=${test_case}
    READLINE_POINT=1
    __depair
    assert_equal "${READLINE_LINE}" ""
    assert_equal "${READLINE_POINT}" 0
  done
}

@test "backspace stil works normally." {
  READLINE_LINE="foobar"
  READLINE_POINT=3
  __depair
  assert_equal "${READLINE_LINE}" 'fobar'
  assert_equal "${READLINE_POINT}" 2
}

@test "backspace inside pairs with spaces" {
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

@test "don't close open pair if escaped." {
  for test_case in "${case[@]}"; do
    READLINE_LINE="\\"
    READLINE_POINT=1
    __autopair "${test_case:0:1}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" "\\${test_case:0:1}"
    assert_equal "${READLINE_POINT}" 2
  done
}

@test "don't treat escaped open pair as unclosed." {
  for test_case in "${case[@]}"; do
    READLINE_LINE="\\${test_case:0:1}"
    READLINE_POINT=2
    local closing_char="${test_case:1:1}"
    # '', ""
    if [[ "${test_case:0:1}" == "${test_case:1:1}" ]]; then
      closing_char="${test_case:0:1}"
    fi
    __autopair "${test_case:0:1}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" \
      "\\${test_case:0:1}${test_case:0:1}${closing_char}"
    assert_equal "${READLINE_POINT}" 3
  done
}

@test "auto pair" {
  for test_case in "${case[@]}"; do
    READLINE_LINE="foo "
    READLINE_POINT=4
    __autopair "${test_case:0:1}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" "foo ${test_case:0:1}${test_case:1:1}"
  done
}

@test "bump cursor for already closed pairs" {
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

@test "auto close open pair" {
  for test_case in "${case[@]}"; do
    READLINE_LINE="${test_case:0:1}foobar"
    READLINE_POINT=7
    local closing_char="${test_case:1:1}"
    if [[ "${test_case:0:1}" == "${test_case:1:1}" ]]; then
      closing_char="${test_case:0:1}"
    fi
    __autopair "${closing_char}" "${test_case:0:1}" "${test_case:1:1}"
    assert_equal "${READLINE_LINE}" "${test_case:0:1}foobar${closing_char}"
  done
}

@test "no backspace when readline is empty" {
  READLINE_LINE=''
  READLINE_POINT=1
  run __depair
  assert_failure 1
}
