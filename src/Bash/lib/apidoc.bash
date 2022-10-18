#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# modified Apidoc functions from composure.sh by erichs.
# https://github.com/erichs/composure

# print paragraph where pattern reside.
# awk -v RS= '/_::add_to_path()/' ~/Projects/dotfiles/Bash/lib/util.bash

function main() {
  local functions=(
    'about' 'example' 'group' 'param'
    'about-alias' 'about-plugin' 'plugin-group' 'about-completion'
    '_about' '_env' '_group' '_return' '_param' )

  for func in ${functions[*]}; do
    eval "$func() { :; }"
  done
}

function _typeset_functions_about() {
  local func func_list

  func_list="$(declare -F | awk '{ print $3 }')"

  for func in $func_list; do
    declare -f -- "$func" \
      | grep -qE "^about[[:space:]]|[[:space:]]about[[:space:]]" \
      && echo -- "$func"
  done
}

function _letterpress() {
  local rightcol="$1"
        leftcol="${2:- }"
        leftwidth="${3:-20}"
  if [[ -z "${rightcol}" ]]; then
    return
  fi

  printf \
    "${fgyellow=\e[38;5;221m}%-*s${reset=\e[0m}%s\n" \
    "${leftwidth}" \
    "${leftcol}" \
    "${rightcol}"
}

function reference() {
  about 'displays apidoc help for a specific function'
  param '1: function name'
  example '$ reference revise'
  group 'composure'

  local func="${1:-}"
  local line about author

  if [[ -z "$func" ]]; then
    printf '%s\n' 'missing parameter(s)'
    reference reference
    return 1
  fi

  about="$(declare -f "$func" | metafor about)"
  _letterpress "$about" "$func"

  author="$(declare -f "$func" | metafor author)"
  if [[ -n "$author" ]]; then
    _letterpress "$author" 'author:'
  fi

  if [[ -n "$(declare -f "$func" | metafor param)" ]]; then
    printf "parameters:\n"
    declare -f "$func" | metafor param | while read -r line
    do
      _letterpress "$line"
    done
  fi

  if [[ -n "$(declare -f "$func" | metafor example)" ]]; then
    printf "examples:\n"
    declare -f "$func" | metafor example | while read -r line
    do
      _letterpress "$line"
    done
  fi
}

function metafor() {
  about 'prints function metadata associated with keyword'
  param '1: meta keyword'
  example '$ declare -f glossary | metafor example'
  group 'composure'

  local keyword="${1:-}"

  if [[ -t 0 ]]; then
    echo 'requires some data piped on standard input.'
    echo
    reference metafor
    return 1
  elif [[ -t 1 ]] && [[ $# -eq 0 ]]; then
    printf '%s\n' 'missing parameter(s)'
    reference metafor
    return 1
  fi

  sed -n "/$keyword / s/['\";]*\$//;s/^[ 	]*$keyword ['\"]*\([^([].*\)*\$/\1/p"
}

function glossary() {
  about 'displays help summary for all functions, or for a group of functions'
  param '1: optional, group name'
  example '$ glossary'
  example '$ glossary misc'
  group 'composure'

  local functionlist maxwidth
  local group targetgroup=${1:-}
  local about aboutline=

  functionlist="$(_typeset_functions_about)"
  maxwidth="$(echo "$functionlist" \
    | awk 'BEGIN{ maxlength=0 } {
      for(i=1;i<=NF;i++)
      if (length($i)>maxlength) {
        maxlength=length($i)
      }
    }
    END{ print maxlength }' \
    | awk '{ print $1 + 5 }'
  )"

  for func in ${functionlist}; do
    group="$(declare -f -- "${func}" | metafor group)"
    if [[ "X${targetgroup}X" != "XX" ]]; then
      if [[ "$group" != "$targetgroup" ]]; then
        continue  # skip non-matching groups, if specified
      fi
    elif [[ "${group}" == 'composure' ]]; then
      continue # skip composure group, unless specified
    fi
    about="$(declare -f -- "$func" | metafor about)"
    echo "$about" \
      | fmt \
      | while read -r aboutline; do
        _letterpress "${aboutline}" "${func}" "${maxwidth}"
      func=' ' # only display function name once
    done
  done
  unset func
}

main unset -f main
