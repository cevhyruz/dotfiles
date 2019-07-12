#!/usr/bin/env bash

# completion for my custom functions (bash/profile.d/functions)

function main() {
  echo 'test'
}

main && unset -f main
