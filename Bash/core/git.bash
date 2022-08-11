#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2207
# ------------------------------------------------------------------
# Git wrapper for bash.
# ------------------------------------------------------------------

_::command_exists "git" || return 0
export git_core_loaded=1
export aliases=

function git() {
  local method="${1:-}"
  local exit_code

  old_func_def="$(declare -F)"
  source "${DOTFILES}/Git/.gitalias.bash"
  git_func="$(declare -F)"

  local -ar func_defs=( $(diff --rcs <(echo "${old_func_def}") <(echo "${git_func}") \
    | grep 'declare' \
    | awk '{print $3}') )

  function cleanup() {
    for func in "${func_defs[@]}"; do
      unset -f "${func}"
    done
    unset -v old_func_def git_func
    unset -f cleanup
  }

  # list and select alias interactively.
  if [[ "${method}" == "alias" ]]; then
    local -ar fzf_opts=(
      "--ansi"
      "--bind='ctrl-e:preview-down+preview-down'"
      "--bind='ctrl-y:preview-up+preview-up'"
      "--bind='ctrl-space:accept'"
      "--bind='ctrl-s:toggle-sort'"
      "--bind='ctrl-o:clear-selection'"
      "--bind='^:beginning-of-line'"
      "--bind='ctrl-/:toggle-preview'"
      "--bind='?:jump-accept'"
      "--multi"
      "--pointer='❱'"
      "--prompt='➤ '"
      "--height=20"
      "--marker='✸ '"
      "--no-bold"
      "--border=horizontal"
      "--layout=reverse"
      "--preview-window=60%:border-sharp"
      "--preview='cat {}'"
      "--inline-info"
      "--header='' "
    )
    FZF_DEFAULT_OPTS="${fzf_opts[*]}"

    printf "%s\n" "${func_defs[@]}" \
      | fzf --preview "source ${DOTFILES}/Git/.gitalias.bash \
      && source ${DOT_BASH}/lib/apidoc.bash \
      && reference {} || echo 'no available information' "
    cleanup
    return
  fi

  if [[ -z "${method}" ]]; then
      cleanup
      command git
      return $?
  fi

  if declare -F "${method}" &> /dev/null; then
    shift
    "${method}" "$@"
    exit_code=$?
    cleanup
    return $exit_code
  fi

  cleanup
  command git "$@"
}
