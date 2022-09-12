#!/usr/bin/env bash
#
# Custom git aliases, too complicated to write inside gitconfig.
# usage:    git [function] [...]
# requires: git.bash
# see: Bash/core/git.bash for details

# list and select alias interactively.

function foobar() {
  echo 'from foobar'
}

function bar() {
  group "git"
}

function foo() {
  echo 'from foo'
}
