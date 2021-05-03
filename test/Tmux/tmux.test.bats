#!/usr/bin/env bats

load ../test_helper

function _run() {
   run "$@" 3>-
}

function setup() {
  # shellcheck disable=SC2010
  #if ! tmux -Ltest list-sesion &> /dev/null; then
    #echo 'no test'
  tmux -Ltest new-session -d
    LOCAL_TMUX_VERSION=$(tmux -Ltest -V | sed -En "s/^tmux[^0-9]*([.0-9]+).*/\1/p")
  #fi
}

function teardown() {
  tmux -Ltest kill-server
}

function execute() {
  tmux -Ltest $1
}

function show_option() {
  execute "show-options $1v $2"
}

@test "Tmux: Verify executable version" {
  _run execute "show-environment -g TMUX_VERSION"
  assert_output "TMUX_VERSION=${LOCAL_TMUX_VERSION}"
}

#@test "Tmux: Verify all options has been properly set" {
  #_run show_option -s buffer-limit
  #assert_output 25

  #run show_option -s escape-time
  #assert_output 0
  #run show_option -s exit-unattached
  #assert_output "off"
  #run show_option -s quiet
  #assert_output "off"
  #run show_option -s set-clipboard
  #assert_output "on"
  #run show_option -s focus-event
  #assert_output "on"

  #run show_option -g default-terminal
  #assert_output "screen-256color"
  #run show_option -wg xterm-keys
  #assert_output "on"
  #run show_option -g assume-paste-time
  #assert_output 1
  #run show_option -g base-index
  #assert_output 1
  #run show_option -g bell-action
  #assert_output "none"
  #run show_option -g bell-on-alert
  #assert_output "off"
  #run show_option -g default-command
  #assert_output "${SHELL}"
  ##run show_option -g default-path
  ##assert_output ""
  #run show_option -g default-shell
  #assert_output "${SHELL}"
  #run show_option -g display-time
  #assert_output 5000
  #run show_option -g history-limit
  #assert_output 20000
  #run show_option -g message-limit
  #assert_output 10000
#}
