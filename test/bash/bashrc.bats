#!/usr/bin/env bats
# shellcheck shell=bash
# vi:ft=bash fdm=marker ts=2 sw=2 et


load "${TEST_DIR}/test_helper.bash"

bats_require_minimum_version 1.5.0

setup() {
  TEST_CONFIG_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TEST_CONFIG_DIR"
}

@test "bashrc returns silently when non-interactive" {
  run --separate-stderr bash --norc --noprofile -c "set -x; source '$BASH_CONFIG_DIR/bashrc'"

  [[ "$status" -eq 0 ]]
  [[ -z "$output" ]]
  [[ "$stderr" == *"!= *i*"* ]]
  [[ "$stderr" != *"config_dir="* ]] && [[ "$stderr" != *"config_file="* ]]
}

@test "loads minimal config when init config is missing" {
  cat > "$TEST_CONFIG_DIR/bashrc-minimal.bash" <<'EOF'
MINIMAL_CONFIG_LOADED=1
EOF

  run bash --norc --noprofile -ic "
    export XDG_CONFIG_HOME='$TEST_CONFIG_DIR'
    source '$BASH_CONFIG_DIR/bashrc'
    printf '%s' \"\$MINIMAL_CONFIG_LOADED\"
  "

  [[ "$status" -eq 0 ]]
  [[ "$output" == "1" ]] # should something
}



