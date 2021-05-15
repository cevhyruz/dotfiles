#!/usr/bin/env bats
# vi:ft=bats fdm=marker ts=2 sw=2 et

load ../test_helper
load ../../Bash/core/options

function _show_bash_opts() {
  shopt "$1" | awk '{print $2}'
}

@test "Bash-options: Verify all bash options has been properly set" {
  run _show_bash_opts "no_empty_cmd_completion"
  assert_output on

  run _show_bash_opts "autocd"
  assert_output on

  run _show_bash_opts "cdspell"
  assert_output on

  run _show_bash_opts "nocaseglob"
  assert_output on

  run _show_bash_opts "checkwinsize"
  assert_output on

  run _show_bash_opts "cmdhist"
  assert_output on

  run _show_bash_opts "cdable_vars"
  assert_output on

  run _show_bash_opts "checkhash"
  assert_output on

  run _show_bash_opts "checkjobs"
  assert_output on

  run _show_bash_opts "dirspell"
  assert_output on

  run _show_bash_opts "dotglob"
  assert_output on

  run _show_bash_opts "extglob"
  assert_output on

  run _show_bash_opts "failglob"
  assert_output on

  run _show_bash_opts "globstar"
  assert_output on

  run _show_bash_opts "gnu_errfmt"
  assert_output on

  run _show_bash_opts "histappend"
  assert_output on

  run _show_bash_opts "histreedit"
  assert_output on

  run _show_bash_opts "histverify"
  assert_output on

  run _show_bash_opts "hostcomplete"
  assert_output on

  run _show_bash_opts "huponexit"
  assert_output on

  run _show_bash_opts "lithist"
  assert_output on

  run _show_bash_opts "nullglob"
  assert_output on

  run _show_bash_opts "xpg_echo"
  assert_output on

  run _show_bash_opts "mailwarn"
  assert_output off
}
