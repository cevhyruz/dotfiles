#!/usr/bin/env bash
#
#
# Quick and dirty wordpress installation

function ask_for_sudo() {
  command sudo -v &> /dev/null
  # Update existing `sudo` time stamp
  # until this script has finished.
  #
  # https://gist.github.com/cowboy/3118588
  while true; do
    command sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &
}

function download() {
  local url="$1"
  local output="$2"
  
  if command -v "wget" &> /dev/null; then
    echo 'downloading using wget'
    wget -qcO "$output" "$url" &> /dev/null
    return $?
  elif command -v "curl" &> /dev/null; then
    echo 'downloading using curl'
    curl -LsSo "$output" "$url" &> /dev/null
    return $?
  fi
  return 1
}


function main() {
  ask_for_sudo

  download "http://wordpress.org/latest.tar.gz" ".."

  # # extract
  # /var/www/html$ sudo tar -xzvf latest.tar.gz
  #
  # sudo chown -R www-data:www-data /var/www/html/wordpress
}


main "$@"
