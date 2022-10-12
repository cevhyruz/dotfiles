#!/usr/bin/env bash
#
# pyenv completion for bash, leaving it here instead in pyenv.plugin.bash
# 'runtime' dotfiles command can pick it up here

_::command_exists "pyenv" || return 0

if [[ -n "${PYENV_ROOT}" ]]; then
  source "${PYENV_ROOT}/completions/pyenv.bash"
else
  echo "pyenv completion: \$PYENVROOT is not set"
fi
