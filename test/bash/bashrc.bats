#!/usr/bin/env bats
# shellcheck shell=bash
# vi:ft=bash fdm=marker ts=2 sw=2 et


load "${TEST_DIR}/test_helper.bash"

bats_require_minimum_version 1.5.0

local_setup() {
  TEST_CONFIG_DIR="$(mktemp -d)"
  cp "${BASH_CONFIG_DIR}/bashrc" "${TEST_CONFIG_DIR}/bashrc"
}

local_teardown() {
  rm -rf "$TEST_CONFIG_DIR"
}

@test "bashrc returns silently when non-interactive" { # {{{
  run --separate-stderr bash --norc --noprofile -c "set -x; source '$BASH_CONFIG_DIR/bashrc'"

  [[ "$status" -eq 0 ]]
  [[ -z "$output" ]]
  [[ "$stderr" == *"!= *i*"* ]]
  [[ "$stderr" != *"config_dir="* ]] && [[ "$stderr" != *"config_file="* ]]
}


@test "loads bashrc-minimal config when init config is cannot be sourced" { # {{{1
  mkdir -p "$TEST_CONFIG_DIR/bash"
  cat > "$TEST_CONFIG_DIR/bash/bashrc-minimal.bash" <<'EOF'
MINIMAL_CONFIG_LOADED=1
EOF

  run bash --norc --noprofile -i -c "
    export XDG_CONFIG_HOME='$TEST_CONFIG_DIR'
    source '$TEST_CONFIG_DIR/bashrc'
    rc=\$?
    printf '%s:%s' \"\$MINIMAL_CONFIG_LOADED\" \"\$rc\"
  "

  [[ "$status" -eq 0 ]]
  [[ "$output" == "1:1" ]]
}
