# ------------------------------------------------------------------
# This will create a single portabe vimrc file
# ------------------------------------------------------------------

#!/usr/bin/env bash

function main() {
  # ...
}

# check script requirements.
function _sanity_check() {

}

# check if program is installed.
function _has() {
  local cmd="";
  if ! [[ "$(command -v "${cmd}")" ]]; then
    printf "[git-s] you don't seem to have \"${cmd}\" installed"
    exit 127
  fi
}

main
