#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null
for file in "${DOT_BASH}/lib"/*; do
  source "${file}"
  unset file
done

cite _about _env _group _return _param

# initliaze configurations.
_::source_files_from "${DOT_BASH}/core"

# ordered
_::source_files_from "${DOT_BASH}/plugins"
_::source_files_from "${DOT_BASH}/aliases"

_::source_files_from "${DOT_BASH}/functions"

_::source_file "${DOT_BASH}/themes/${BASH_THEME:-default}.theme.bash"

# local config file.
_::source_file "${DOT_BASH}/.bashrc.local"
