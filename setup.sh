#!/usr/bin/env bash
#
# [?] setup and install necessary things to make dotfiles up and running.


declare -r GITHUB_REPOSITORY="cevhyruz/dotfiles";
declare -r DOTFILES_ORIGIN="git@github.com:${GITHUB_REPOSITORY}.git";
declare -r DOTFILES_TARBALL_URL="https://github.com/${GITHUB_REPOSITORY}/tarball/master";
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/${GITHUB_REPOSITORY}/master/utils/setup_utils.sh"
declare -g dotfiles_dir="${HOME}/Projects/dotfiles";

declare -ag TMP_FILES=();
declare INDENTION="   "

function setup() {
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1;

  if [[ -x "utils/setup_utils.sh" ]]; then
    source "utils/setup_utils.sh" || exit 1;
  else
    download_utils || exit 1;
  fi

  ask::sudo;

  printf "%s" "${BASH_SOURCE[0]}"  \
    | grep "setup.sh" &> /dev/null \
    || download_dotfiles;


  # scripts ...

  if cmd_exists "git"; then
    if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
      #./initialize_git_repository.sh "$DOTFILES_ORIGIN"
      _print::purple "\n • Initialize Git repository\n\n"
      \cd "${dotfiles_dir}" || exit 1;
      #execute "git init && git remote add origin ${DOTFILES_ORIGIN}" \
        #"Initialize dotfiles as Git repository"
        echo "will be installed to - $(dirs)"
    fi
      #./update_content.sh
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

function confirm::location() {
  if ask::confirm "Dotfiles will be installed to '${dotfiles_dir}'"; then
      echo "installing to '${dotfiles_dir}'"
      return 0;
  else
    ask::install_location;
  fi

  while [[ -d "${dotfiles_dir}" ]]; do
    if ask::confirm "'${dotfiles_dir}' already exists, overwrite?"; then
      return 0;
    else
      ask::install_location;
    fi
  done

  return 0;
}

function download_dotfiles() {
  local tmpFile="";

  _print::purple "\n • Download and extract dotfiles tarball\n\n";

  tmpFile="$(mktemp /tmp/XXXXX)";

  download "$DOTFILES_TARBALL_URL" "$tmpFile";
  print::result $? "Download archive" "true";
  printf "\n";

  confirm::location && {
    mkdir -p "$dotfiles_dir"
    print::result $? "Create '${dotfiles_dir}'"

    extract "$tmpFile" "$dotfiles_dir"
    print::result $? "Extract archive"

    rm -rf "$tmpFile"
    print::result $? "Remove archive"
  }
}

function download_utils() {
  local tmpFile="";
  tmpFile="$(mktemp /tmp/XXXXX)";
  download "$DOTFILES_UTILS_URL" "$tmpFile" && {
    source "$tmpFile";
    return 0;
  }
  return 1;
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
