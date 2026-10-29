# lib/timer.bash - measure how long each command ran.
# Needs core/hooks.bash and bash >= 5 (EPOCHREALTIME).

TIMER_THRESHOLD_MS=${TIMER_THRESHOLD_MS-0}   # hide durations below this
CMD_DURATION=                                # human-readable, empty if none
__timer_start=


TIMER_THRESHOLD_MS=10

__timer::stop() {
  CMD_DURATION=
  [[ -n ${HOOK_CMD_START-} ]] || return 0   # empty Enter: no command ran

  local ms=$(( (HOOK_CMD_END - HOOK_CMD_START) / 1000 ))
  unset HOOK_CMD_START
  (( ms >= TIMER_THRESHOLD_MS )) || return 0

  if   (( ms < 1000 ));    then CMD_DURATION="${ms}ms"
  elif (( ms < 60000 ));   then printf -v CMD_DURATION '%d.%02ds' $(( ms / 1000 )) $(( ms % 1000 / 10 ))
  else
    local s=$(( ms / 1000 ))
    if (( s >= 3600 )); then
      printf -v CMD_DURATION '%dh%02dm%02ds' $(( s / 3600 )) $(( s % 3600 / 60 )) $(( s % 60 ))
    else
      printf -v CMD_DURATION '%dm%02ds' $(( s / 60 )) $(( s % 60 ))
    fi
  fi
}

::post_command __timer::stop
