#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/lib/theme.bash"

@test "${TEST_FILE}: check ANSI attributes has been set." {
  local _attrib=(
      "reset_bold"
      "reset_underline"
      "reset_reverse"
      "defaultfg"
      "defaultbg"
      "reset"
      "resetall"
      "bold"
      "dim"
      "italic"
      "underline"
      "blink"
      "reverse"
      "hidden"
      "strikethrough"
      "normal"
      "curvyline"
      "overline"
      "double_underline"
   )

   for attrib in "${_attrib[@]}"; do
     run test -v "${attrib}"
     assert_success
   done
}


@test "${TEST_FILE}: check default ANSI color pallete will be set." {
  local color_palette=(
      "bg_black"
      "bg_red"
      "bg_green"
      "bg_yellow"
      "bg_blue"
      "bg_magenta"
      "bg_cyan"
      "bg_white"
      "fg_black"
      "fg_red"
      "fg_green"
      "fg_yellow"
      "fg_blue"
      "fg_magenta"
      "fg_cyan"
      "fg_white"
  )

  run __load_default_pallete
  assert_success

  __load_default_pallete
  for color in "${color_palette[@]}"; do
    run test -v "${color}"
    assert_success
  done
}

@test "${TEST_FILE}: check dircolors has been set." {
  run __make_dircolors_pallete
  assert_success
}
