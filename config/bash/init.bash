

source "${config_dir}/lib/utils.bash"
source "${config_dir}/lib/prompt.bash"

source "${config_dir}/core/options.bash"
source "${config_dir}/core/xdg.sh"
source "${config_dir}/core/envars.bash"
source "${config_dir}/core/locale.sh"
source "${config_dir}/core/completion.bash"
source "${config_dir}/core/hooks.bash"
source "${config_dir}/core/paths.sh"
source "${config_dir}/core/theme.bash"
source "${config_dir}/core/colors.sh"


for config in "${config_dir}"/{plugins,completions,aliases,functions}/*.*; do
  [[ -f "${config}" ]] || continue
  if ! source "$config"; then
    printf "Error: failed to source %s\n" "$config" >&2
    return 1  # or `exit 1`, depending on whether this loop lives in a function or top-level .bashrc
  fi
done


source "${config_dir}/themes/default.bash"

