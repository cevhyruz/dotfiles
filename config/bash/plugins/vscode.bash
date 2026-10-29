# https://code.visualstudio.com/docs/terminal/shell-integration#_manual-installation
if [[ "${TERM_PROGRAM-}" == "vscode" ]]; then
  _has_nounset=0
  [[ $- == *u* ]] && _has_nounset=1
  set +u
  source "$(code --locate-shell-integration-path bash)"
  (( _has_nounset )) && set -u
  unset _has_nounset
fi


# https://ghostty.org/docs/features/shell-integration#manual-shell-integration-setup
#
# Ghostty shell integration for Bash. This should be at the top of your bashrc!
# if [[ -n "${GHOSTTY_RESOURCES_DIR-}" ]]; then
#   _has_nounset=0
#   [[ $- == *u* ]] && _has_nounset=1
#   set +u
#   source "${GHOSTTY_RESOURCES_DIR-}/shell-integration/bash/ghostty.bash"
#   unset _has_nounset
# fi
#
#
