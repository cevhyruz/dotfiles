#!/usr/bin/env bash
#
# [?] setup and install necessary things to make dotfiles up and running.


declare -r GITHUB_REPOSITORY="cevhyruz/dotfiles";
declare -r DOTFILES_ORIGIN="git@github.com:${GITHUB_REPOSITORY}.git";
declare -r DOTFILES_TARBALL_URL="https://github.com/${GITHUB_REPOSITORY}/tarball/master";
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/master/utils/setup_utils.sh"
declare dotfiles_directory="${HOME}/Projects/dotfiles";
declare skipQuestions=false;


function setup() {
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1;

  if [[ -x "utils/setup_utils.sh" ]]; then
    source "utils/setup_utils.sh" || exit 1;
  else
    download_utils || exit 1;
  fi

  # shellcheck disable=SC2034
  skip_questions "$@" && skipQuestions=true

  ask_for_sudo;

  printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null \
    || download_dotfiles;

  # scripts ...

  if cmd_exists "git"; then
    if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
      ./initialize_git_repository.sh "$DOTFILES_ORIGIN"
    fi
    if ! $skipQuestions; then
      ./update_content.sh
    fi
  fi

}

function download() {
  local url="$1"
  local output="$2"

  if command -v "curl" &> /dev/null; then
    curl -LsSo "$output" "$url" &> /dev/null
    return $?;
  elif command -v "wget" &> /dev/null; then
    wget -qO "$output" "$url" &> /dev/null
    return $?;
  fi
  return 1
}

function download_dotfiles() {
  local tmpFile="";

  print_in_purple "\n • Download and extract archive\n\n";

  tmpFile="$(mktemp /tmp/XXXXX)";

  download "$DOTFILES_TARBALL_URL" "$tmpFile";
  print_result $? "Download archive" "true";
  printf "\n";

  # install location
  if ! $skipQuestions; then
    ask_for_confirmation \
      "Do you want to store the dotfiles in '$dotfiles_directory'?";
    if ! answer_is_yes; then
      dotfilesDirectory=""
      while [ -z "$dotfilesDirectory" ]; do
        ask "Please specify another location for the dotfiles (path): ";
        dotfilesDirectory="$(get_answer)"
      done
    fi
    while [[ -e "$dotfilesDirectory" ]]; do
      ask_for_confirmation \
        "'$dotfilesDirectory' already exists, do you want to overwrite it?";
      if answer_is_yes; then
        rm -rf "$dotfilesDirectory";
        break;
      else
        dotfilesDirectory="";
        while [ -z "$dotfilesDirectory" ]; do
          ask "Please specify another location for the dotfiles (path): ";
          dotfilesDirectory="$(get_answer)";
        done
      fi
    done
    printf "\n";
  else
    rm -rf "$dotfilesDirectory" &> /dev/null;
  fi

  mkdir -p "$dotfilesDirectory"
  print_result $? "Create '$dotfilesDirectory'" "true"

  extract "$tmpFile" "$dotfilesDirectory"
  print_result $? "Extract archive" "true"

  rm -rf "$tmpFile"
  print_result $? "Remove archive"

  cd "$dotfilesDirectory/src/os" \
      || return 1
}

function download_utils() {
  local tmpFile="";
  tmpFile="$(mktemp /tmp/XXXXX)";
  download "$DOTFILES_UTILS_URL" "$tmpFile" && {
    . "$tmpFile"
    rm -rf "$tmpFile"
    return 0
  }
  return 1
}

function extract() {
  local archive="$1"
  local outputDir="$2"
  if command -v "tar" &> /dev/null; then
    tar -zxf "$archive" --strip-components 1 -C "$outputDir"
    return $?
  fi
  return 1
}

setup "$@"
