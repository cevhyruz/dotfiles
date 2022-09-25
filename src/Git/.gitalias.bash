#!/usr/bin/env bash
#
# Custom git aliases, too complicated to write inside gitconfig.

function done() { command git push origin HEAD; }
function typo() { command git commit --amend; }
function amend() { command git commit --amend --no-edit; }
function undo() { command git reset HEAD~1 --quiet --mixed; }
function unstage() { command git reset HEAD --quiet -- "$@"; }
function discard() { command git checkout --quiet "$@"; }
function contrib() { command git shortlog --summary --numbered | cat; }

function s() {
  if _::command_exists "tig"; then
    command tig status
    return $?
  fi
  command git status --short --branch --show-stash --ahead-behind --renames;
}

function a() { command git add "$@"; }
function c() { command git commit; }
function lg() {
  if [[ -n "${1:-}" ]]; then
    command git log --decorate --graph $1
  else
    command git log --decorate --graph -15;
  fi
}
function lga() { command git log --decorate --graph --all --format=detail; }
function br() { command git branch --all; }
function dif() { command git difftool -t nvimdiff; }

# switch or create a branch.
function mb() {
  command git checkout --quiet -b "${1:-}" 2> /dev/null \
    || command git checkout --quiet "${1:-}"
}

function rmb() {
  command git branch --delete --force "${1:-}"
  command git branch --all
}
