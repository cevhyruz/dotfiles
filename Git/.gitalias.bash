#!/usr/bin/env bash
#
# custom git aliases, too complicated to write inside gitconfig.
# usage: git [function] [...]
# see Bash/core/git.bash for details.

if [[ -z "${git_core_loaded:-}" ]]; then
  return
fi

# list and select alias interactively.
# function alias() {
#   command git config --get-regexp "alias.*" \
#     | awk '{ print $1 }' \
#     | sed 's/alias.//' | fzf --preview 'cat {}'
# }

function foobar() {
  about  "Return a foobar text"
  param "[message] (optional)"
  group "git"
  example "this should be just an example"
  example "another example"

  echo 'from foobar'
}

function bar() {
  about "Return just a bar"
  param "[message] (optional)"
  echo 'from bar'

  group "git"
}

function foo() {
  about "a foo should always be a foo"
  param "[message] (optional)"
  group "git"

  echo 'from foo'
}

function testi() {
  echo 'a function without apidoc'
}
