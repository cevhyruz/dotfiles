up() {
  local n=${1:-1} path=
  while (( n-- > 0 )); do path+=../; done
  cd "${path:-.}"
}
