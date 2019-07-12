#!/usr/bin/env bash

[[ -n "$PS1" ]] \
 && . /etc/profile;

# supposedly lazyload bash_completion.
# trap 'source /etc/bash_completion ; trap USR1' USR1
# { sleep 0.1 ; builtin kill -USR1 $$ ; } & disown
