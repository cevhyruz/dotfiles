#!/usr/bin/env bash
# shellcheck shell=bash
# vim: ft=sh fdm=marker ts=2 sw=2 et

function main() {
  if [[ -d '/usr/lib/Android' ]]; then

    export readonly ANDROID_HOME='/usr/lib/Android'
    export readonly ANDROID_SDK_ROOT="${ANDROID_HOME}"
    export readonly GRADLE_HOME='/opt/gradle/gradle-5.6.2'

    declare -ra _ANDROID_PATH=(
      "${ANDROID_HOME}"
      "${ANDROID_HOME}/tools"
      "${ANDROID_HOME}/tools/bin"
      "${ANDROID_HOME}/platform-tools"
      "${ANDROID_SDK_ROOT}"
      "${GRADLE_HOME}")

    for path in "${_ANDROID_PATH[@]}"; do
      _::add_to_path "${path}"
    done

    unset path
  fi
}

main
