#!/usr/bin/env bash
# shellcheck shell=bash
# vi:ft=sh fdm=marker ts=2 sw=2 et
#
# Initialize Dotfiles Bash configuration.

# load utility helper file.
# shellcheck source=/dev/null
#for file in "${DOT_BASH}/lib"/*; do
  #source "${file}"
  #unset file
#done

source "${DOT_BASH}/lib/apidoc.bash"
source "${DOT_BASH}/lib/helpers.bash"
source "${DOT_BASH}/lib/logger.bash"
source "${DOT_BASH}/lib/theme.bash"
source "${DOT_BASH}/lib/util.bash"

# initliaze configurations.
#_::source_files_from "${DOT_BASH}/core"
source "${DOT_BASH}/core/autopairs.bash"
source "${DOT_BASH}/core/envars.bash"
source "${DOT_BASH}/core/hooks.bash"
source "${DOT_BASH}/core/keybindings.bash" # ~17
source "${DOT_BASH}/core/options.bash"

# ordered
#_::source_files_from "${DOT_BASH}/plugins"
source "${DOT_BASH}/plugins/android_dev.plugin.bash" # ~2
source "${DOT_BASH}/plugins/command_not_found.plugin.bash"
source "${DOT_BASH}/plugins/fzf.plugin.bash"
source "${DOT_BASH}/plugins/golang.plugin.bash"
source "${DOT_BASH}/plugins/less.plugin.bash"
source "${DOT_BASH}/plugins/man.plugin.bash"
source "${DOT_BASH}/plugins/nvm.plugin.bash"
source "${DOT_BASH}/plugins/pyenv.plugin.bash"
source "${DOT_BASH}/plugins/term.plugin.bash"

#_::source_files_from "${DOT_BASH}/aliases"
source "${DOT_BASH}/aliases/general.aliases.bash"

#time _::source_files_from "${DOT_BASH}/functions"
source "${DOT_BASH}/functions/fzf.functions.bash"
source "${DOT_BASH}/functions/general.functions.bash"

#time _::source_file "${DOT_BASH}/themes/${BASH_THEME:-default}.theme.bash"
source "${DOT_BASH}/themes/default.theme.bash"

# local config file.
 #_::source_file "${DOT_BASH}/.bashrc.local"
source "${DOT_BASH}/.bashrc.local"
