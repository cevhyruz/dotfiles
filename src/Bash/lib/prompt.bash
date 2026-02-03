#!/usr/bin/env bash
#
# Library functions for building bash prompts.

# =========== PS4 ============

# TODO: if possible
# [x] Add return status.
# [x] Merge the same stack (tree-like view).
# [x] Dim color for stdout.
function _ps4_callstack() {
  set +u
  for (( i = ${#FUNCNAME[@]}; i > 0; i-- )); do
    printf '\e[33m%b\e[36m%b\e[38;5;187m%b\e[0m \e[1;31m>\e[0m ' \
      "${BASH_SOURCE[i]##*/}:" "${FUNCNAME[i]:+():}" "${BASH_LINENO[i]}"
  done
  set -u
}

# =========== PS1 ============

# Display current working directory full path.
function __cwd() { 
    local separator='/'
    # local separator_color="\e[1;38;5;130m" # bold orange
    local separator_color="\e[0;1m" # red
    local pwd="${PWD//${HOME}/${separator_color}\~}"
    local dir_colors="\e[1;38;5;74m"       # bold blue

    pwd="${resetall}${pwd////${separator_color}${separator}\\e\[1;38;5;74m}${resetall}"

    printf "%b" "${pwd}"
}


# =========== Git prompt ============

# Display current git branch/HEAD.
function _prompt_git_head() {
  local head_file head
  local dir="$PWD"

  while [[ -n "$dir" ]]; do
    head_file="$dir/.git/HEAD"
    if [[ -f "$dir/.git" ]]; then
      read -ra head_file < "${dir}/.git" && head_file="${dir}/${head_file#gitdir: }/HEAD"
    fi

    [[ -e "$head_file" ]] && break
    dir="${dir%/*}"
  done

  if [[ -e "$head_file" ]]; then
    read -r head < "$head_file" || return
    printf "${bold}${Bggreen}"
    case "$head" in
      ref:*) printf "${head#ref: refs/heads/}" ;;
      "")    printf "uknown" ;;
      *)     printf "${head:0:9}" ;;
    esac
    return 0
  fi
  return 1
}

# Checks if the current directory is/or within a git repository.
# return: 0 if dir is a/inside git repository, 1 otherwise.
function _is_git() {
  local relative_path
  if [[ -d .git ]]; then
    return 0
  fi
  IFS="/" read -ra dir <<< "${PWD//${HOME}\//}"
  for entry in "${dir[@]}"; do
    relative_path+="../"
    if [[ -d "${PWD}/${relative_path}.git" ]]; then
      return 0
    fi
  done
  return 1
}

# show git branch and status in prompt.
# output:  [HEAD] [status icons]
# sample:  master +!?
function __my_git_ps1() {
  _is_git || return

  local status=''

  _prompt_git_head   "${bold}${Bggreen}" "${Bgred}" "${Bgyellow}" "${Bgwhite}:" 

  command git update-index --really-refresh &> /dev/null

  # tags ~5ms
  printf " " && command git describe --tags 2> /dev/null

  # ~4ms staged
  command git diff --quiet --ignore-submodules --cached ||
    status+="+"

  # ~4ms modified
  command git diff-files --quiet --ignore-submodules -- ||
    status+="!"

  # ~7ms untracked
  test -n "$(command git ls-files --others --exclude-standard :/)" &&
    status+="?"

  # ~4ms stashed
  command git rev-parse --verify refs/stash > /dev/null 2>&1 &&
    status+="*"

  printf "%b" "${1-$Bgwhite} ${status}"

}
