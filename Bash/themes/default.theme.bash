#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2154,SC2016
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Default bash prompt theme when BASH_PROMPT_THEME is not set or is empty.

function main() {
  __set_colorscheme
  __make_dircolors_pallete
  __set_PS1
  __prompt_stdout_color
  # TODO: add version check here.
  __readline_vi_mode
}

function __set_colorscheme() {
  if [[ "${COLORTERM}" =~ ^(truecolor|24bit)$ ]]; then
    bg_black="\e[48;5;234m"  fg_black="\e[38;5;234m"
    bg_red="\e[48;5;203m"    fg_red="\e[38;5;203m"
    bg_green="\e[48;5;35m"   fg_green="\e[38;5;35m"
    bg_yellow="\e[48;5;221m" fg_yellow="\e[38;5;221m"
    bg_blue="\e[34m"         fg_blue="\e[34m"
    bg_magenta="\e[35m"      fg_magenta="\e[35m"
    bg_cyan="\e[36m"         fg_cyan="\e[36m"
    bg_white="\e[37m"        fg_white="\e[37m"
  else
    __load_default_pallete
  fi
}

function __prompt_stdout_color() {
  PRE_COMMAND+=('printf "%b" "${normal}";')
}

function __readline_vi_mode() {
  # distinguishable cursor shapes for vi mode.
  # only works on GNU readline v7.0 (bash 4.3 and up).
  if [[ -z "${BATS_TEST_NAME:-}" ]]; then
    bind 'set show-mode-in-prompt on'
    bind 'set vi-ins-mode-string \1\e[5 q\e]12;cyan\a\2'
    bind 'set vi-cmd-mode-string \1\e[2 q\e]12;cyan\a\2'
  fi
}

function __set_PS1() {
  PS1="\[${reset}${bold}${normal}\]\n"
  local -a ps1=(
    # return arrow that colorize depending on command exit code.
    '$( if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
        printf "%b" "${fg_green}╭─ "
      else
        printf "%b" "${fg_red}╭─ "
      fi )'
    # user @ host string depending on if SSH_TTY is set.
    '$( if [[ -n "${SSH_TTY:-}" ]]; then
        printf "%b" "${reset}${fg_white}\u@\H"
      else
        printf "%b" "${reset}${fg_white}\u@\H"
    fi)'
    # current working directory
    '$( if [[ "${PWD:-}" == "${HOME}" ]]; then
      printf "%b" "${fg_cyan}home"
    else
      printf "%b" "${fg_cyan}\w"
    fi)'
    # display git branch and status if current directory is a git repo.
    '$( ! git rev-parse &> /dev/null && exit
        status="    "
        if [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == false ]]; then
          git update-index --really-refresh -q &> /dev/null
          if ! git diff --quiet --ignore-submodules --cached; then
            status="${status/ /+}"
          fi
          if ! git diff-files --quiet --ignore-submodules --; then
            status="${status/ /!}"
          fi
          if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
            status="${status/ /?}"
          fi
          if git rev-parse --verify refs/stash &> /dev/null; then
            status="${status/ /*}"
          fi
        fi
        git_branch=(
        "$( git symbolic-ref --quiet --short HEAD 2> /dev/null ||
            git rev-parse --short HEAD 2> /dev/null ||
            echo "unknown" )")
        git_prompt=(
          "${bold}${fg_yellow}"
          "("
          "${fg_red}"
          "${git_branch}"
          "${fg_yellow}"
          ")"
          " "
          "${status}" )
        printf "%b" "${git_prompt[@]}" )'
    # return arrow that colorize depending on command exit code.
    '$( return_string="    [ exited ${EXIT_CODE:-} ]"
    if [[ "${EXIT_CODE:-}" -ne 0 ]]; then
        printf "%b" "${resetall}${dim}${return_string}"
    fi )'
    "\n"
    # [╰➤] return arrow that colorize depending on command exit code.
    '$( if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
        printf "%b" "${fg_green}╰➤"
      else
      printf "%b" "${fg_red}╰➤"
      fi )'
    "\[${reset}${dim}\] \$: \[${reset}\]"
    "\[\e[38;5;216m\]") # LightSalmon1

  PS1+="$(printf "%b" "${ps1[@]}")"
}

function __cleanup() {
  unset -f \
    main \
    __set_colorscheme \
    __set_PS1 \
    __prompt_stdout_color \
    __readline_vi_mode \
    __cleanup
}


main && __cleanup
