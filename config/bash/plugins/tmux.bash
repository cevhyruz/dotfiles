# ──────────────────────────────────────────────────────────────────────────────
# tmux → gnome-terminal: report the working directory (OSC 7)
#
# Why:    gnome-terminal (VTE) decides where Ctrl+Shift+N / Ctrl+Shift+T open
#         from the cwd the shell reports via OSC 7. Inside tmux, the VTE
#         integration (/etc/profile.d/vte-2.91.sh) returns early because
#         $TERM is tmux-256color, so nothing is reported and new windows
#         open in the wrong directory.
#
# How:    On every prompt, print OSC 7 wrapped in tmux's DCS passthrough
#         (\033Ptmux; ... \033\\) so tmux forwards it to the outer terminal.
#         Switching panes/windows is handled separately by hooks in
#         ~/.tmux.conf, since this only fires when a prompt is drawn.
#
# Needs:  - tmux 3.3+ with `set -g allow-passthrough on`
#         - bash 5.1+ (PROMPT_COMMAND+=( ) on a string value)
#         - optional: /usr/libexec/vte-urlencode-cwd (falls back to raw $PWD)
#
# Scope:  Only runs inside tmux; plain terminals keep using the VTE script.
# ──────────────────────────────────────────────────────────────────────────────
if [[ -n "${TMUX-}" ]]; then
  __osc7_tmux() {
    local LC_ALL=C str=$PWD out= safe byte
    while [[ -n $str ]]; do
      safe=${str%%[!a-zA-Z0-9/:_.~@-]*}   # longest run of safe chars
      out+=$safe
      str=${str#"$safe"}
      if [[ -n $str ]]; then
        printf -v byte '%%%02X' "'${str:0:1}"   # first unsafe byte -> %XX
        out+=$byte
        str=${str:1}
      fi
    done
    printf '\033Ptmux;\033\033]7;file://%s%s\007\033\\' "$HOSTNAME" "$out"
  }

  PROMPT_COMMAND+=(__osc7_tmux)
fi
