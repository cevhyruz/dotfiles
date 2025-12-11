#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# general functions that is too complicated to be an alias
# and/or to small to be a plugin nor core functions.

# Creates an archive (*.tar.gz) from given directory.
# function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

# Create a ZIP archive of a file or folder.
# function makezip() { zip -r "${1%%/}.zip" "$1" ; }

# create directory and enter it.
# usage: md [directory]
function md() {
  local directory="${1:-}"
  mkdir -p "${directory}" && cd "$_" || return 1
}

function fs() {
  echo "Determine size of a file or total size of a directory"
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

# =============
# Color System
# =============

# print a nice 256colors chart
function colormap() {
  for (( i = 0; i < 256; i++ )); do
    printf "\e[48;5;${i}m%s" "$i"
    printf '\e[0m'
    [ ! $(( (i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
  done
  unset i
}

# CoreUI's color mixins translated.
# https://github.com/coreui/coreui/blob/main/scss/functions/_color.scss

# Tint a color: mix a color with white.
function tint-color() {
  true;
}

# Shade a color: mix a color with black.
function shade-color() {
true;
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

printf "\x1b[58;2;255;0;0m\x1b[4msingle\x1b[21mdouble\x1b[60mcurly\x1b[61mdotted\x1b[62mdashed\x1b[0m"

  echo
  echo -e "\e[58;2;50;168;90m set underline color to specified true color RGB"

  echo
  echo -e "\e[58;5;39m set underline color to palette index I (0-255)"

  echo
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

  # echo "========================="
  # echo "underlines"
  # echo "========================="
  # echo
  # echo -e "\e[4:2m mdouble underline"
  # echo
  # echo -e "\e[4:3m curvy underline"
  # echo
  # echo -e "\e[4:4m dotted line"
  # echo
  # echo -e "\e[4:5m dashed line"

# pretty print and colorize value of 'LS_COLORS'.
function lscolors() {
  local -A dircolors="(
    [no]='NORMAL, NORM'
    [fi]='File'
    [di]='DIR'
    [ln]='SYMLINK, LINK, LNK'
    [or]='ORPHAN'
    [mi]='MISSING'
    [bd]='BLOCK, BLK'
    [cd]='CHAR, CHR'
    [ex]='EXEC'
    [do]='DOOR'
    [so]='SOCK'
    [pi]='FIFO, PIPE'
    [sg]='SETGID'
    [su]='SETUID'
    [st]='STICKY'
    [tw]='STICKY_OTHER_WRITABLE'
    [ow]='OTHER_WRITABLE'
  )"
  set -f;
  for item in ${LS_COLORS//:/ }; do
    printf "%b" "\e[0m"
    echo " [\e[${item#*=}m  ${dircolors[${item%=*}]}  \e[0m]";
  done
  set +f;
}

# print current theme palette.
function palette() {
  echo
  echo " palette"
  for bg in 4 10; do
    for (( i = 0; i < 8; i++ )); do
      echo -en " \e[${bg}${i}m   ${resetall}"
    done
    echo
  done
  echo

  echo " LS_COLORS"
  lscolors
}

function foobar() {
  echo "$Bgblack hellow $resetall"
  echo "$Bgred hellow $resetall"
  echo "$Bggreen hellow $resetall"
  echo "$Bgyellow hellow $resetall"
  echo "$Bgblue hellow $resetall"
  echo "$Bgmagenta hellow $resetall"
  echo "$Bgcyan hellow $resetall"
  echo "$Bgwhite hellow $resetall"
  echo
  echo "$bgblack hellow $resetall"
  echo "$bgred hellow $resetall"
  echo "$bggreen hellow $resetall"
  echo "$bgyellow hellow $resetall"
  echo "$bgblue hellow $resetall"
  echo "$bgmagenta hellow $resetall"
  echo "$bgcyan hellow $resetall"
  echo "$bgwhite hellow $resetall"
  echo
  echo "$Fgblack hellow $resetall"
  echo "$Fgred hellow $resetall"
  echo "$Fggreen hellow $resetall"
  echo "$Fgyellow hellow $resetall"
  echo "$Fgblue hellow $resetall"
  echo "$Fgmagenta hellow $resetall"
  echo "$Fgcyan hellow $resetall"
  echo "$Fgwhite hellow $resetall"
  echo
  echo "$fgblack hellow $resetall"
  echo "$fgred hellow $resetall"
  echo "$fggreen hellow $resetall"
  echo "$fgyellow hellow $resetall"
  echo "$fgblue hellow $resetall"
  echo "$fgmagenta hellow $resetall"
  echo "$fgcyan hellow $resetall"
  echo "$fgwhite hellow $resetall"
}
