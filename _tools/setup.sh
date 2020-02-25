#!/usr/bin/env bash

declare -r VCS="https://github.com"
declare -r REPO="cevhyruz/dotfiles";
declare -r ORIGIN="git@github.com:$REPO.git";
declare -r TARBALL="$VCS/$REPO/tarball/master";
declare -r UTILS="$VCS/raw.githubusercontent.com/$REPO/_tools/util.sh"

# declare dotfiles_home="$HOME/Projects/dotfiles";
declare dotfiles_home="/tmp/dotfiles";
declare skip_question=false;

main() {
  # ensure that cwd is relative to this script file.
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
  # load utils
  [[ -x "utils.sh" ]] && {
    . "utils.sh" || exit 1
  } || download_utils || exit 1
}

# show spinner
function install() {
  local spinner=⣾⣽⣻⢿⡿⣟⣯⣷
  while :; do
    for (( i = 0; i<${#spinner}; i++ )); do
      sleep 0.1
      echo -en " ${green}${bold}${spinner:$i:1}${reset}  " "\\r"
    done
  done
  unset i spinner
}

# download from [url] using curl/get and save to [output].
# usage donwload [rul] [output]
download() {
  local url="$1"
  local output="$2"
  if command -v "curl" &> /dev/null; then
    curl -LsSo "$output" "$url" &> /dev/null
    return $?
  elif command -v "wget" &> /dev/null; then
    wget -qO "$output" "$url" &> /dev/null
    return $?
  fi
  unset url output
  return 1
}

# download utility helper file.
download_utils() {
  local tmp_file='';
  tmp_file="$(mktemp /tmp/XXXXX)";
  download "$UTILS" "$tmp_file" \
    && . "$tmp_file" \
    && rm -rf "$tmp_file" \
    return 0;
  unset tmp_file
  return 1
}

download_dotfiles() {
  local tmp_file=""
  print_header "\n • Download and extract archive\n\n";
  tmp_file="$(mktemp /tmp/XXXXX)";
  download "$TARBALL" "$tmp_file";
  print_result $? "Download archive" "true";
  printf "\n";
}

main && unset -f main
