#!/usr/bin/env bash

exit_code=0

function _print_error() {
  printf "%b" " \e[38;5;238m┃\e[0m $1 \n"
  exit_code=1
}

for file in "$@"; do

  printf "%b" "\n\e[38;5;203m${file}\e[0m\n"

  # Confirm file is executable
  if [[ ! -x "${file}" ]]; then
    _print_error ".sh file should be only executables"
  fi

  # Confirm expected shebang header
  LINE1="$(head -n 1 "${file}")"
  if [[ "${LINE1}" != "#!/usr/bin/env bash" ]]; then
    _print_error "bad/missing shebang"
  fi
done

exit $exit_code
