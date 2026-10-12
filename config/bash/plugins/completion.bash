#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2034,SC1003
# vim: ft=sh fdm=marker ts=2 sw=2 et

# Loads the bash-completion framework (if installed) and provides small helpers
# for inspecting which completions are available vs. loaded.

# source "${config_dir}/bash_completion" || echo 'plugin: bash-completion error' >&2


# To override a completion for a specific command, you can install your own completion
# file for the command into an appropriate place.
# User-specific completion files defaults to '$XDG_DATA_HOME/bash-completion'
# or '~/.local/share/bash-completion'
BASH_COMPLETION_USER_DIR="${config_dir}"
BASH_COMPLETION_USER_FILE="${config_dir}/bash_completion"

# bash-completion 2.x needs bash >= 4.2
if (( BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 2) )); then
  echo "bash-completion: requires bash >= 4.2 (found: ${BASH_VERSION})" >&2
  return 0
fi


# We don't need to to do anything if it's already enabled
[[ ${BASH_COMPLETION_VERSINFO-} ]] && return 0


_bashcomp_main=
for _f in \
  /mnt/5edb692f-316d-428b-b10d-43b9b9ad2988/Projects/reference/bash-completion/bash_completion \
  /usr/share/bash-completion/bash_completion \
  /etc/bash_completion
do
  if [[ -r $_f ]]; then
    _bashcomp_main=$_f
    break
  fi
done
unset _f

if [[ -z $_bashcomp_main ]]; then
  echo "bash-completion: not installed (install the 'bash-completion' package)" >&2
  unset _bashcomp_main
  return 0
fi

# TODO: Some completions produce errors with 'nounset' enabled, I can maybe
# just turn if off around here and just re-enable after.
source "$_bashcomp_main" || echo "bash-completion: failed to source $_bashcomp_main" >&2
unset _bashcomp_main


# Directories searched for lazy-loaded completion files, one per line
bashcomp_dirs() {
  local d
  printf '%s\n' "${BASH_COMPLETION_USER_DIR%/}/completions"
  local IFS=:
  for d in ${XDG_DATA_DIRS:-/usr/local/share:/usr/share}; do
    [[ -n $d ]] && printf '%s\n' "${d%/}/bash-completion/completions"
  done
}

# How man
bashcomp_dirs_completions() {
  :;
}

# Command names that have a completion registered in THIS shell
bashcomp_loaded() {
  local line i
  local -a w
  while IFS= read -r line; do
    # `complete -p` output is shell-quoted by bash itself, so eval is safe here
    eval "w=($line)"
    for (( i = 1; i < ${#w[@]}; i++ )); do
      case ${w[i]} in
        -[ACFGPSWX]) (( i++ )) ;;              # options that take an argument
        -*) ;;                                  # plain flags (-o x is handled below)
        *) printf '%s\n' "${w[@]:i}"; break ;;
      esac
    done
  done < <(complete -p) | sort -u
}

# Completion files that COULD be lazy-loaded (file name == command name)
bashcomp_available() {
  local d
  while IFS= read -r d; do
    [[ -d $d ]] && ls -1 "$d"
  done < <(bashcomp_dirs) | sort -u
}

# Available but not yet loaded (approximate: one file may register several commands)
bashcomp_pending() {
  comm -23 <(bashcomp_available) <(bashcomp_loaded)
}

# Which file would be loaded for a command?
bashcomp_which() {
  local cmd=${1:?usage: bashcomp_which COMMAND} d
  while IFS= read -r d; do
    [[ -r $d/$cmd ]] && { printf '%s\n' "$d/$cmd"; return 0; }
    [[ -r $d/$cmd.bash ]] && { printf '%s\n' "$d/$cmd.bash"; return 0; }
  done < <(bashcomp_dirs)
  echo "bashcomp_which: no completion file found for '$cmd'" >&2
  return 1
}

# Force-load a command's completion without pressing Tab
bashcomp_load() {
  local cmd=${1:?usage: bashcomp_load COMMAND}
  if declare -F _comp_load >/dev/null; then
    _comp_load -- "$cmd"                        # bash-completion >= 2.12
  elif declare -F _completion_loader >/dev/null; then
    _completion_loader "$cmd"                   # older versions
  else
    echo "bashcomp_load: no loader function found" >&2
    return 1
  fi
  complete -p "$cmd" 2>/dev/null
}
