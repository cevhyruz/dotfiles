#!/usr/bin/env bash

FOOBAR="bash is loaded"

# If not interactive do nothing.
[[ -n "$PS1" ]] && source /etc/profile;
