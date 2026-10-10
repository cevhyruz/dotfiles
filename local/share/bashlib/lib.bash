# ~/.local/share/bashlib/import.bash
# shellcheck shell=bash
#
# libimport.bash - utility for importing bashlib/ lib files.
#
# Usage:
#   
#   source "${XDG_DATA_HOME:-$HOME/.local/share}/bashlib/import.bash"
#   import_lib [lib name]...


__BASHLIB_DIR="${BASHLIB_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bashlib}"
declare -gA __BASHLIB_LOADED
 
import_lib() {
    local name file
    for name in "$@"; do
        [[ -n "${__BASHLIB_LOADED[$name]:-}" ]] && continue
        file="$__BASHLIB_DIR/$name.bash"
        if [[ ! -r "$file" ]]; then
            echo "import: no such library: $name" >&2
            return 1
        fi
        __BASHLIB_LOADED[$name]=1
       source "$file"
    done
}
