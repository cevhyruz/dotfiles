#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load "${TEST_DIRECTORY}/test_helper.bash"
load "Bash/lib/theme.bash"

@test "${TEST_FILE}: Make sure color variables has been set." {
  assert_equal "${reset_bold}" "\e[22m"
    assert_equal "${reset_underline}" "\e[24m"
    assert_equal "${reset_reverse}" "\e[27m"
    assert_equal "${defaultfg}" "\e[39m"
    assert_equal "${defaultbg}" "\e[49m"
    assert_equal "${reset}" "\e[0m"
    assert_equal "${resetall}" "\e[0m\e[22m\e[24m\e[27m"
    assert_equal "${bold}" "\e[1m"
    assert_equal "${dim}" "\e[2m"
    assert_equal "${italic}" "\e[3m"
    assert_equal "${underline}" "\e[4m"
    assert_equal "${blink}" "\e[5m"
    assert_equal "${reverse}" "\e[7m"
    assert_equal "${hidden}" "\e[8m"
    assert_equal "${strikethrough}" "\e[9m"
    assert_equal "${normal}" "\e[38;5;247m"
    assert_equal "${curvyline}" "\e[4:3m"
    assert_equal "${overline}" "\e[53m"
    assert_equal "${double_underline}" "\e[4:2m"
}
