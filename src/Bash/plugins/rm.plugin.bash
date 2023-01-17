#!/usr/bin/env bash
# shellcheck shell=bash

function rm() {
  echo "--------------------------"
  echo "  ✋ Stop right there!!"
  echo "--------------------------"
  echo "rm is not recommended when deleting stuff, use trash-cli instead."
  echo "see: https://github.com/andreafrancia/trash-cli"
  return 1
} >&2
