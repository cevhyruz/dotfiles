#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - -

function package_is_installed() { dpkg -s "$1" &> /dev/null; }

function update() {
  execute "sudo apt-get update -qqy" "APT (update)"
}

function install_apps() {
  execute "sudo apt-get update -y" "APT (update)"
}

function install_package() {
  if ! package_is_installed "$PACKAGE"; then
    execute "sudo apt-get install --allow-unauthenticated -qqy $3 $2" "$1"
  else
    print_success "$1"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - -

function main() {
  install_apps "$@"

  print::jobname "Build Essentials"

  install_package "Build Essential" "build-essential"
  install_package "GnuPG archive keys" "debian-archive-keyring"
}

main "$@"
