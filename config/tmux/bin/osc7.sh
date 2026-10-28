#!/bin/sh
#
# osc7.sh <client_tty> <pane_path>

tty=$1 path=$2

encoded=$(printf '%s' "$path" | LC_ALL=C awk '
BEGIN { for (i = 1; i < 256; i++) ord[sprintf("%c", i)] = i }
{
  n = length($0); out = ""
  for (i = 1; i <= n; i++) {
    c = substr($0, i, 1)
    if (c ~ /[A-Za-z0-9\/_.~-]/) out = out c
    else out = out sprintf("%%%02X", ord[c])
  }
  printf "%s", out
}')

printf '\033]7;file://%s%s\033\\' "$(uname -n)" "$encoded" > "$tty"
