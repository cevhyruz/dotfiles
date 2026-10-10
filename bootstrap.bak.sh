#!/usr/bin/env bash
#
# Dotfiles installer.

declare gh_repo="cevhyruz/dotfiles"
declare dotfiles_tarball="https://github.com/${gh_repo}/tarball/master"
declare utils="utils/setup_utils.sh"

declare dotfilesdir="${HOME}/Projects/dotfiles"
declare skip_questions=false

function download() {
  local url="$1"
  local output="$2"
  if command -v "curl" &> /dev/null; then
    curl -LsSo "$output" "$url" &> /dev/null
    return $?
  elif command -v "wget" &> /dev/null; then
    wget -qO "$output" "$url" &> /dev/null
    return $?
  fi
  return 1
}

function download_utils() {
  local tmpFile=""
  tmpFile="$(mktemp /tmp/XXXXX)"
  download "https://raw.githubusercontent.com/${gh_repo}/master/${utils}" \
    "$tmpFile" && {
    if [[ -s "${tmpFile}" ]]; then
      source  "${tmpFile}" 
      command rm -rf "${tmpFile}"
    fi
    return 0
  }
  return 1
}

function download_dotfiles() {
  local tmpFile=""
  tmpFile="$(mktemp /tmp/XXXXX)"

  print::jobname "Download and extract archive"

  download "${dotfiles_tarbar}" "${tmpFile}"

  print::result $? "Download archive" "true"

  printf "\n"

  if ! $skip_questions; then
    confirm "Do you want to store the dotfiles in '$dotfilesdir'?"
    if ! affirmative; then
      dotfilesdir=""
      while [ -z "$dotfilesdir" ]; do
        ask "Please specify another location for the dotfiles (path): "
        dotfilesdir="$(get_answer)"
      done
    fi
    # Ensure the `dotfiles` directory is available
    while [ -e "$dotfilesdir" ]; do
      confirm "'$dotfilesdir' already exists, do you want to overwrite it?"
      if affirmative; then
        command rm -rf "$dotfilesdir"
        break
      else
        dotfilesdir=""
        while [ -z "$dotfilesdir" ]; do
          ask "Please specify another location for the dotfiles (path): "
          dotfilesdir="$(get_answer)"
        done
      fi
    done
    printf "\n"
  else
    command rm -rf "${dotfilesdir}" &> /dev/null
  fi

  mkdir -p "${dotfilesdir}"
  print::result $? "Create '${dotfilesdir}'" "true"


  # Extract archive in the `dotfiles` directory.
  extract "${tmpFile}" "${dotfilesdir}"
  print::result "$?" "Extract archive" "true"

  command rm -rf "${tmpFile}"
  print::result "$?" "Remove archive"

  cd "$dotfilesdir/src/os" || return 1
}

function main() {
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

  if [[ -f "${utils}" ]]; then
    source "${utils}" || exit 1
  else
    download_utils || exit 1
  fi

  if [[ -n "$1" ]]; then
    source "utils/${1}.sh" || return
    return
  fi

  skip_questions "$@" && skipQuestions=true
  ask_for_sudo


  printf "%s" "${BASH_SOURCE[0]}" \
    | grep "install.sh" &> /dev/null \
    || download_dotfiles

  source utils/create_directories.sh
  source utils/create_symlinks.sh
  source utils/install_apps.sh


  source utils/build_configfiles.sh

  # preferences (privacy, terminal, ui/ux)

  # update dotfiles

  # restart?
}


main "$@"
