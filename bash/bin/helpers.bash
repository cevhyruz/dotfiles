#!/usr/bin/env bash

# It's important to unset all this functions after runtime
# since we won't use it on interactive shell.

function has() {
  local cmd="$1";
  if ! [[ "$(command -v "$cmd")" ]]; then
    echo "dont have $cmd"
    return 1
  else
    echo 'true'
  fi
}

function clean() {
  echo "you cleaned?"
}
