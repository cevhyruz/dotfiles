#!/usr/bin/env bash

# Helper functions for 'git' prepended executables.

function _get_sha1() {
  sha1=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "${commits}" | awk '{print $1}')
}

