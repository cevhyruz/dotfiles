# shellcheck shell=bash disable=SC2034,SC1003
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Bash readline
# export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"

pbcopy() {
  xsel --clipboard --input || { echo "pbcopy: failed" >&2; return 1; }
  [[ -t 2 ]] && echo "copied to clipboard" >&2
  return 0
}

pbpaste() {
  xsel --clipboard --output || { echo "pbpaste: failed" >&2; return 1; }
}

# inputrc can use this binding to also enable yanking into system's
# clipboard on top of the readline's default kill ring.
# for example, to enable yanking the line:
# $: "yy": "mt0Y$`t\C-x\C-y"
bind -m vi-command -x '"\C-x\C-y": printf "%s" "${READLINE_LINE-}" | pbcopy 2>/dev/null'
