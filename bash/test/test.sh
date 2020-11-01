#!/usr/bin/env bash
#
#  File:          test.sh
#  Description:   Entry file for running all bats test cases.


function test::init() {
  # check if we're in the right directory.
  echo 'test'
}


test::init "$@"
