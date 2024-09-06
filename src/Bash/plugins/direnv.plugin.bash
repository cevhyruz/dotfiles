
function _direnv_hook() {
  export DIRENV_LOG_FORMAT=""
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$("/usr/bin/direnv" export bash)" \
  trap - SIGINT;
  return $previous_exit_status;
}

::post_command _direnv_hook
