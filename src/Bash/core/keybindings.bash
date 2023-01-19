#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2016
# vim: ft=sh fdm=marker ts=2 sw=2 et

# exit vi-insert editing mode
# bind -m vi-insert '"kj": vi-movement-mode'

bind -r '"v"'

# terminate current bash session
bind -m vi-command '";q": "dd\C-d"'
