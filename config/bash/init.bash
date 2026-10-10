source "${XDG_DATA_HOME:-$HOME/.local/share}/bashlib/lib.bash"
import_lib "common" "log" "path"

# source "${config_dir}/lib/logger.bash"
source "${config_dir}/lib/utils.bash"
source "${config_dir}/lib/tui.bash"
source "${config_dir}/lib/hooks.bash"
source "${config_dir}/lib/theme.bash"
source "${config_dir}/lib/prompt.bash"
source "${config_dir}/lib/bash-completion.bash"

source "${config_dir}/functions/cmd.bash"

source "${config_dir}/core/options.bash"      # basic options
source "${config_dir}/core/xdg.sh"            # xdg-specs (so we know where to locate which)
source "${config_dir}/core/envars.bash"       # basic variables
source "${config_dir}/core/term.sh"           # terminal capability detection
source "${config_dir}/core/locale.sh"         # set locale
# source "${config_dir}/core/hooks.bash"     
source "${config_dir}/core/paths.sh"          # basic default path

# plugins
source "${config_dir}/plugins/autopairs.bash"

# for config in "${config_dir}"/{completions,aliases}/*.*; do
for config in "${config_dir}"/aliases/*.*; do
  [[ -f "${config}" ]] || continue

  app="${config##*/}"
  app="${app%.*}"

  # require cmd
  if ! command -v "$app" &>/dev/null 2>&1; then
    true
  fi


  # filenames starting with '_' don't have a command requirement
  # if [[ "$app" != _* ]]; then
  #   # skip sourcing if the required command doesn't exist
  #   __util::command_exists "$app" || continue
  # fi

  if ! source "$config"; then
    printf "Error: failed to source %s\n" "$config" >&2
    # stop loading configs immediately
    return 1
  fi
done


# lib/theme.bash     - theme utility functions
# core/prompt.bash    - prompt library functions
# themes/default.bash - colorschemes


THEME_VARIANT=dark
__theme::init default && __theme::main_handle


# The only files that should introduce a functions are
#
# 1.) Library files - because they are reusable (must have a namespace)
# 2.) Plugins       - because they may contain feature that can only be
#                     triggered interactively, like changing the default command,
#                     loading,unloading paths, changing paths
#                   - must also have a namespace
#   A plugin can also contain:
#     aliases
#     functions
#     PATHS/Exports
#     ENV variables
#                     


# [/] case 1: (cding using keybinding)
#     bind -m vi-command '"?": "icd /etc\C-m"'

# [/] case 2:  (cding into output of an executable that has an interactive state using 'read' )
# bind -m vi-command '"?": "i_d=\"$(dotfiles)\" && [[ -n \"$_d\" ]] && cd \"$_d\"\C-m" || unset -v _d'


