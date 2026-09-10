#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=bash fdm=marker ts=2 sw=2 et
#
# Gum plugin for Bash
#
# TODO: refactor this. see fzf.plugin.bash for example

function gum-commit() {
   local -ar __GIT_COMMIT_TYPE=(
     "    Feat : New feature changes"
     "    Fix  : Bug Fix / Hot Fixx"
     "    Docs : Documentation changes"
     "   Style : Formatting / Style changes"
     "Refactor : Code Structure changes"
     "    test : Add / Update tests"
     "   chore : Maintennance changes"
     "  revert : Undoing changes" );

  # A commit can fail with these:
  # - No Stage File
  # - Precommit hook failure
  # - Merge Conflict / Incomplete Merge
  # - Empty Commit Message
 
  TYPE=$(
    gum choose "${__GIT_COMMIT_TYPE[@]}"
  ) || return
  SCOPE=$(gum input --placeholder "scope") || return

  # Since the scope is optional, wrap it in parenthesis if it has a value.
  test -n "$SCOPE" && SCOPE="($SCOPE)"

  SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change") || return
  DESCRIPTION=$(gum write --placeholder "Details of this change") || return

  gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
}

