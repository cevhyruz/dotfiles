#!/usr/bin/env bash
#
# fzf as i3wm program launcher


exec i3-msg -q "bash -ic exec --no-startup-id $(compgen -c | fzf --reverse)"
