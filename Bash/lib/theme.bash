#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC2086,SC2145
# vim: ft=sh fdm=marker ts=2 sw=2 et

function __git_branch () {
  git symbolic-ref --quiet --short HEAD 2> /dev/null \
    || git rev-parse --short HEAD 2> /dev/null \
    || echo "unknown"
}

function __has_modified () {
  if ! git diff-files --quiet --ignore-submodules --; then
    return 0;
  fi;
  return 1
}
function __has_staged () {
  if ! git diff --quiet --ignore-submodules --cached; then
    return 0;
  fi;
  return 1
}

function __has_stash () {
  if git rev-parse --verify refs/stash &> /dev/null; then
    return 0;
  fi;
  return 1
}
function __has_untracked () {
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    return 0;
  fi;
  return 1
}
function __in_git_dir () {
  if [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == 'true' ]]; then
    return 0;
  fi;
  return 1
}

function __in_git_repo () {
  if ! git rev-parse &> /dev/null; then
    return 1;
  fi
}

function __load_ansi_attrib () {
  defaultfg="\e[39m";
  defaultbg="\e[49m";
  reset="\e[0m";
  bold="\e[1m";
  dim="\e[2m";
  italic="\e[3m";
  underline="\e[4m";
  blink="\e[5m";
  reverse="\e[7m";
  hidden="\e[8m";
  strikethrough="\e[9m";
  normal="${defaultfg}${defaultbg}";
  curvyline="${underline::-1}:${italic:3}";
  overline="\e[53m";
  double_underline="${underline::-1}:${dim:3}"
}

function __load_default_pallete () {
  bg_black="\e[40m"   fg_black="\e[30m"
  bg_red="\e[41m"     fg_red="\e[31m"
  bg_green="\e[42m"   fg_green="\e[32m"
  bg_yellow="\e[43m"  fg_yellow="\e[33m"
  bg_blue="\e[44m"    fg_blue="\e[34m"
  bg_magenta="\e[45m" fg_magenta="\e[35m"
  bg_cyan="\e[46m"    fg_cyan="\e[36m"
  bg_white="\e[47m"   fg_white="\e[37m"
}

function __make_dircolors () {
  LS_COLORS=''
  local -r dircolors="${1}"
  set -o noglob
  for entry in ${dircolors[*]}; do
    LS_COLORS+="$entry";
  done;
  set +o noglob
  export LS_COLORS
}

function __make_dircolors_pallete () {
  local -ar __lscolors=(
    '__reset'         '__bg_black'   '__fg_black'
    '__bold'          '__bg_red'     '__fg_red'
    '__italic'        '__bg_green'   '__fg_green'
    '__reverse'       '__bg_yellow'  '__fg_yellow'
    '__defaultfg'     '__bg_blue'    '__fg_blue'
    '__defaultbg'     '__bg_magenta' '__fg_magenta'
    '__underline'     '__bg_cyan'    '__fg_cyan'
    '__strikethrough' '__bg_white'   '__fg_white'
    '__dim'
  );

  local -r __normal="${defaultfg:3:-1};${defaultbg:3:-1}";

  for color in ${__lscolors[*]}; do
    eval "local -r ${color}=$(echo -E \"\$\{${color:2}:3:-1\}\")";
  done;

  __load_dircolors
}

function __make_rgb_colors_from_pallete() {
  local -ar __lscolors=(
    'reset'         'bg_black'   'fg_black'
    'bold'          'bg_red'     'fg_red'
    'italic'        'bg_green'   'fg_green'
    'reverse'       'bg_yellow'  'fg_yellow'
    'defaultfg'     'bg_blue'    'fg_blue'
    'defaultbg'     'bg_magenta' 'fg_magenta'
    'underline'     'bg_cyan'    'fg_cyan'
    'strikethrough' 'bg_white'   'fg_white'
    'dim'
  );
}
