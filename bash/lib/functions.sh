#!/usr/bin/env bash

# repeat 'expr'  by 'count' and return the concatenated results.
# usage: repeat [expr] [count]
function repeat() {
  for (( i = 0; i < ${2}; i++ )); do
    printf %s "${1}"
  done
}

# return the length of given string.
# usage: len [string]
function len() {
  echo -n "${1}" | wc -c
}

# return given string in uppercase format.
# usage: uppercase [string]
function uppercase() {
  echo "${1^^}"
}

# return given string in lowercase format.
# usage: lowercase [string]
function lowercase() {
  echo "${1,,}"
}
