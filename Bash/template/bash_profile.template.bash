# shellcheck shell=bash
# #!/usr/bin/env bash
# vi:ft=sh fdm=marker ts=2 sw=2 et

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Don't check mail when opening terminal.
unset MAILCHECK

# enable vi-style line editing.
set -o vi

# some really good starting options.
readonly _OPTIONS=(
  "no_empty_cmd_completion" # no auto-completion on empty line
  "autocd"                  # allow omitting `cd` to directory names
  "cdspell"                 # auto-correct typos in path names
  "nocaseglob"              # case-insensitive pathname globbing
  "checkwinsize"            # update `LINES` and `COLUMNS` if needed
  "cmdhist"                 # save multi-line command in one hist entry
  "cdable_vars"             # if dir is not found, cd to value of variable
  "checkhash"               # check if command exists in hashtable before executing
  "checkjobs"               # check if there's any jobs before exiting the shell
  "dirspell"                # directory auto-correction
  "dotglob"                 # include (.)files in file globbing.
  "extglob"                 # extended pattern matching in pathname expansion
  "failglob"                # if fail to match filenames return expansion error
  "globstar"                # ** will match all files and zero more more dir & subdir
  "gnu_errfmt"              # set error messages same as GNU error messages format
  "histappend"              # append to history rather, don't overwrite it
  "histreedit"              # allow readline to re-edit failed history substitution
  "histverify"              # allow further modification for history-substitution results
  "hostcomplete"            # hostname completion if '@' is being completed
  "huponexit"               # send SIGHUP to all jobs when interative login shell exits
  "lithist"                 # save multi-line cmd history with embedded newlines
  "mailwarn"                # warn if mail has been accessed since the last time it was checked
  "nullglob"                # expand patterns with no match to null string
  "xpg_echo")               # expand backslash-escape sequences

for opts in "${_OPTIONS[@]}"; do
  shopt -s "${opts}"
done
unset opts
