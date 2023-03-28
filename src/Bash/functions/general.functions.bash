#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# general functions that is too complicated to be an alias
# and/or to small to be a plugin nor core functions.

# Creates an archive (*.tar.gz) from given directory.
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# create directory and enter it.
# usage: md [directory]
function md() {
  local directory="${1:-}"
  mkdir -p "${directory}" && cd "$_" || return 1
}

# Determine size of a file or total size of a directory
function fs() {
  if [[ -n "$*" ]]; then
    du -sh -- "$@";
  else
   du -sh .[^.]* ./*;
  fi
}

# prettify JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
function json() {
  if [ -t 0 ]; then # argument
    python -mjson.tool <<< "$*" | pygmentize -l javascript;
  else # pipe
    python -mjson.tool | pygmentize -l javascript;
  fi;
}

# generate dataURL from a file
function dataurl() {
  local mimeType
  local file="${1:-}"
  mimeType=$(file -b --mime-type "${file}");
  if [[ "$mimeType" == text/* ]]; then
    mimeType="$mimeType;charset=utf-8"
  echo "data:$mimeType;base64,$(openssl base64 -in "$1" | tr -d '\n')" \
     | xclip -selection clipboard
  echo "dataturl copied into clipboard";
  fi
}

# print a nice 256colors chart
function colormap() {
  for (( i = 0; i < 256; i++ )); do
    printf "\e[48;5;${i}m%s" "$i"
    printf '\e[0m'
    [ ! $(( (i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
  done
  unset i
}

# https://gist.github.com/cevhyruz/c0a95a927d59c9690e6a2c63c038a77d
# print a nice truecolors rgb strip
function truecolors() {
  awk 'BEGIN {
      s="          "; s=s s s s s s s s;
      for (colnum = 0; colnum<77; colnum++) {
          r = 255-(colnum*255/76);
          g = (colnum*510/76);
          b = (colnum*255/76);
          if (g>255) g = 510-g;
          printf "\033[48;2;%d;%d;%dm", r,g,b;
          printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
          printf "%s\033[0m", substr(s,colnum+1,1);
      }
      printf "\n";
  }'
}

# simple note-taking tool.
# shellcheck shell=bash disable=SC2164,SC2181
function note() {
  local note
  local location="${1:-${HOME}/Documents/notes}"

    pushd "${location}" &> /dev/null || return
    note="$(find "${location}" -maxdepth 1 -type f -exec basename {} ';' \
      | fzf --height=50% --sort --preview "cat ${location}/{}")"
    if [[ $? -ne 0 ]]; then
      popd &> /dev/null
      return 1
    fi
    "${EDITOR}" "${location}/${note}"
    popd &> /dev/null
}

# terminfo test
function terminfo() {
  echo -e "\e[1mbold\e[0m"
  echo
  echo -e "\e[2mdim\e[0m"
  echo
  echo -e "\e[3mitalic\e[0m"
  echo
  echo -e "\e[4mstraight underline\e[0m"
  echo
  echo -e "\e[9mstrikethrough\e[0m"
  echo
  echo -e "\e[31mred foreground\e[0m"
  echo
  echo -e "\033[53moverline\033[55m"
  echo
  echo -e "\e[4:2mdouble underline"
  echo
  echo -e "\e[4:3mcurvy underline"
}

# pretty print and colorize value of 'LS_COLORS'.
function lscolors() {
  set -f;
  for item in ${LS_COLORS//:/ }; do
    echo "${item%=*} [\e[${item#*=}m ${item#*=} \e[0m]";
  done
  set +f;
}

# print current theme palette.
function palette() {
  echo
  for bg in 4 10; do
    for (( i = 0; i < 8; i++ )); do
      echo -en " \e[${bg}${i}m   ${reset}"
    done
    echo
  done
}

function foobar() {
  echo "$Bgblack hellow $reset"
  echo "$Bgred hellow $reset"
  echo "$Bggreen hellow $reset"
  echo "$Bgyellow hellow $reset"
  echo "$Bgblue hellow $reset"
  echo "$Bgmagenta hellow $reset"
  echo "$Bgcyan hellow $reset"
  echo "$Bgwhite hellow $reset"
  echo
  echo "$bgblack hellow $reset"
  echo "$bgred hellow $reset"
  echo "$bggreen hellow $reset"
  echo "$bgyellow hellow $reset"
  echo "$bgblue hellow $reset"
  echo "$bgmagenta hellow $reset"
  echo "$bgcyan hellow $reset"
  echo "$bgwhite hellow $reset"
  echo
  echo "$Fgblack hellow $reset"
  echo "$Fgred hellow $reset"
  echo "$Fggreen hellow $reset"
  echo "$Fgyellow hellow $reset"
  echo "$Fgblue hellow $reset"
  echo "$Fgmagenta hellow $reset"
  echo "$Fgcyan hellow $reset"
  echo "$Fgwhite hellow $reset"
  echo
  echo "$fgblack hellow $reset"
  echo "$fgred hellow $reset"
  echo "$fggreen hellow $reset"
  echo "$fgyellow hellow $reset"
  echo "$fgblue hellow $reset"
  echo "$fgmagenta hellow $reset"
  echo "$fgcyan hellow $reset"
  echo "$fgwhite hellow $reset"
}
