# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et
#
# log.bash - Library for logging.



# __log::err() {
#    printf '[FAIL]: %s (line %s) %s\n' "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$*" >&2
# }

# __log::err [-v] <message>
#   -v   also show the logger's own frame (lib/logger.bash)
__log::err() {
  local verbose=0 rc=$?
  if [[ $1 == -v ]]; then
    verbose=1
    shift
  fi

  # PID header: only on the first error of this shell
  if [[ -z ${__LOG_PID_SHOWN:-} ]]; then
    printf '[pid %s]\n' "$$" >&2
    __LOG_PID_SHOWN=1
  fi


  local i n=${#BASH_SOURCE[@]}
  if (( verbose )); then
    printf '    at %s:%s\n' "${BASH_SOURCE[0]/#"$HOME"/\~}" "$LINENO" >&2
  fi

  for (( i = 1; i < n; i++ )); do
    printf '    at %s:%s\n' "${BASH_SOURCE[i]/#"$HOME"/\~}" "${BASH_LINENO[i-1]}" >&2
  done

  printf '\n' >&2

  return "$rc"           # optional: preserve the original status
}
