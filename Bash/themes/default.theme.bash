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
    bg_cyan="\e[106m"        fg_cyan="\e[36m"
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

# :nocov:
function __set_PS1() {
  PS1='$(
      if [[ "${EXIT_CODE:-}" -eq 0 ]]; then
        arrow_color="\[${fg_green}\]"
        return_str=
      else
        arrow_color="\[${fg_red}\]"
        return_str="\[${resetall}${dim}\]    [ exited ${EXIT_CODE} ]"
      fi

      declare -ar arrow=(
        "${arrow_color}╭─${reset}"
        "${arrow_color}├─${reset}"
        "${arrow_color}╰─➤${reset}"
      )

      if [[ -n "${SSH_TTY:-}" ]]; then
        userhost_color="\[${fg_red}\]"
      else
        userhost_color="\[${fg_white}\]"
      fi

      declare workdir="\[${fg_cyan}\]:${PWD//${HOME}/\~}"

      if [[ -n "${VIRTUAL_ENV:-}" ]]; then
        VIRTUAL_ENV="${VIRTUAL_ENV//${PYENV_ROOT}/PYENV_ROOT}"
        VIRTUAL_ENV="\[${normal}${dim}\]${VIRTUAL_ENV}"
        VIRTUAL_ENV="${arrow[1]} ${VIRTUAL_ENV:-}\n"
      fi

      if git rev-parse &> /dev/null &&
        [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == false ]]; then
          git update-index --really-refresh -q &> /dev/null

          if ! git diff --quiet --ignore-submodules --cached; then
            status+="+"
          fi
          if ! git diff-files --quiet --ignore-submodules --; then
            status+="!"
          fi
          if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
            status+="?"
          fi
          if git rev-parse --verify refs/stash &> /dev/null; then
            status+="*"
          fi

          declare -ra git_prompt=(
            "\[${bold}${fg_yellow}\]"
            "("
            "\[${fg_red}\]"
            "$( git symbolic-ref --quiet --short HEAD 2> /dev/null ||
                git rev-parse --short HEAD 2> /dev/null ||
                echo "unknown" )"
            "\[${fg_yellow}\]"
            ") "
            "${status:-}" )
      fi

      declare -ra prompt=(
        "\[${reset}${bold}${normal}\]\n"
        "${arrow[0]}"
        "${userhost_color} \u@\H"
        "${workdir}"
        "${git_prompt[@]}"
        "${return_str}\n"
        "${VIRTUAL_ENV:-}"
        "${arrow[2]}"
        "\[${reset}${dim}\] \$: ${reset}"
        "\[\e[38;5;216m\]"
      )

      printf "%b" "${prompt[@]}"
    )'
}
# :nocov:

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
