#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC1003
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Use bash-completion, if available, and avoid double-sourcing
# FIXME: Sourcing time is ~30ms, Find a way to reduce this

if [[ ! ${BASH_COMPLETION_VERSINFO:-} && -f /usr/share/bash-completion/bash_completion ]]; then
   source /usr/share/bash-completion/bash_completion
fi
