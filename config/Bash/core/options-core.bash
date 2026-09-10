#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

# enabled options.

set -o nounset  # treat unset variables as an error when substituting.
set -o pipefail # value of pipeline is the status of the last command.
set -o errtrace # ERR trap will be inherited by shell functions.
set -o vi       # enable bash vi mode.

# disabled options

set +o functrace  # disable trap DEBUG on subshells.

# enabled options

shopt -s no_empty_cmd_completion # no auto-completion on empty line.
shopt -s autocd                  # allow omitting `cd` to directory names.
shopt -s cdspell                 # auto-correct typos in path names.
shopt -s nocaseglob              # case-insensitive pathname globbing.
shopt -s checkwinsize            # update `LINES` and `COLUMNS` if needed.
shopt -s cmdhist                 # save multi-line command in one hist entry.
shopt -s cdable_vars             # if dir is not found, cd to value of variable.
shopt -s checkhash               # check if command exists in hashtable before executing.
shopt -s checkjobs               # check if there's any jobs before exiting the shell.
shopt -s dirspell                # directory auto-correction.
shopt -s dotglob                 # include (.)files in file globbing.
shopt -s extglob                 # extended pattern matching in pathname expansion.
shopt -s failglob                # if fail to match filenames return expansion error.
shopt -s globstar                # ** will match all files and zero more more dir & subdir.
shopt -s gnu_errfmt              # set error messages same as GNU error messages format.
shopt -s histappend              # append to history rather, don't overwrite it.
shopt -s histreedit              # allow readline to re-edit failed history substitution.
shopt -s histverify              # allow further modification for history-substitution results.
shopt -s hostcomplete            # hostname completion if '@' is being completed.
shopt -s huponexit               # send SIGHUP to all jobs when interative login shell exits.
shopt -s lithist                 # save multi-line cmd history with embedded newlines.
shopt -s nullglob                # expand patterns with no match to null string.
shopt -s xpg_echo                # expand backslash-escape sequences.

# disabled options

shopt -u mailwarn # Don't check mail when opening terminal.
