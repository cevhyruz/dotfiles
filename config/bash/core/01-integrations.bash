# VTE’s shell-integration signal emitter. It tells the terminal about shell
# lifecycle events (a prompt is about to be drawn, a command is about to start,
# a command just finished), and it’s part of the “termprops” mechanism in
# recent VTE versions (roughly 0.78+).
__vte_termprop_signal() {
    local errsv="$?"
    printf '\033]666;%s!\033\\' "$1"
    return $errsv
}
