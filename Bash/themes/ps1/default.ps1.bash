#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2034
#
# PS1 for default.theme.bash

# ╭─ devs@codelabs:home/Projects/dotfiles(master) +!?*  [ exited 1 ]
# ╰─➤ $:

# current working directory
declare workdir="\[${fg_cyan}\] ${PWD//${HOME}/Home}"

# last command status
if [[ ${EXIT_CODE:-} -eq 0 ]]; then
  arrow_color="\[${bold}${fg_green}\]"
  return_str=
else
  arrow_color="\[${bold}${fg_red}\]"
  return_str="\[${resetall}${dim}\]\\t[ exited ${EXIT_CODE} ]\[${reset}\]"
fi

declare -ar arrow=(
  "${arrow_color}╭─\[${reset}\]"
  "${arrow_color}├─\[${reset}\]"
  "${arrow_color}╰─➤\[${reset}\]"
)

# git
if git rev-parse &>/dev/null \
  && [[ $(git rev-parse --is-inside-git-dir 2>/dev/null) == false ]]; then
  git update-index --really-refresh -q &>/dev/null

  if ! git diff --quiet --ignore-submodules --cached; then
    status+="+"
  fi
  if ! git diff-files --quiet --ignore-submodules --; then
    status+="!"
  fi
  if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    status+="?"
  fi
  if git rev-parse --verify refs/stash &>/dev/null; then
    status+="*"
  fi

  declare -ra git_prompt=(
    "\[${reset}${bold}${fg_yellow}\]"
    " "
    "\[${fg_red}\]"
    "$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
      || git rev-parse --short HEAD 2>/dev/null \
      || echo "unknown")"
    " "
    "\[${fg_yellow}\]"
    "${status:-}")
else
    declare -ra git_prompt=""
fi

# userhost
if [[ -n ${SSH_TTY:-} ]]; then
  userhost_color="\[${fg_red}\]"
else
  userhost_color="\[${fg_white}\]"
fi

# virtual environment
if [[ -n ${VIRTUAL_ENV:-} ]]; then
  declare -a virtual_env=(
    "${arrow[1]}"
    "\[${normal}${dim}\]"
    "${VIRTUAL_ENV//${PYENV_ROOT}/PYENV_ROOT}"
    "\n"
  )
fi

declare -a prompt=(
  "\n"
  "\[${reset}${bold}${normal}\]"
  "${arrow[0]}"
  "${userhost_color} \u@\H"
  "${workdir}"
  "${git_prompt[@]}"
  "${return_str}"
  "\n"
  "${virtual_env[@]}"
  "${arrow[2]}"
  "\[${reset}${dim}\]"
  ' $: '
  "\[${reset}\e[38;5;216m\]"
)

printf "%b" "${prompt[@]}"
