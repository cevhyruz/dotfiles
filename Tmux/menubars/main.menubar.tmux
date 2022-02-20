# vi:ft=tmux


set-option command-alias[99] menubar=\
'display-menu -T" #[bold,fg=cyan]Menu#[default]  Server  Session  Music " -x0 -y0 \
  "-" "" ""\
  "  #[fg=cyan]#[default]  Reload tmux session " 'r' {
    source-file ${DOT_TMUX}/tmux.conf
    display-message 'reloaded'
  }\
  "  #[fg=cyan]\uf044#[default]  Quick edit a dotfile               " 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "  #[fg=cyan]\uf1eb#[default]  Wi-Fi #[align=right,dim]${wifi}" 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "-" "" ""\
  "  #[fg=cyan]\uf044#[default]  Spawn new shell #[align=right,dim](${SHELL})#[default]" 'c' {
    display-popup -d${DOTFILES}
  }\
  "  #[fg=cyan]\uf044#[default]  Create new window #[align=right,dim](#{b:pane_current_path})#[default]" 'c' {
    new-window
  }\
  "  #[fg=cyan]\uf044#[default]  Break pane " 'c' {
    break-pane
  }\
  "-" "" ""\
  "  #[fg=cyan]\uf044#[default]  Open with nautilus" 'c' {
    run-shell -b "nautilus #{pane_current_path}"
  }\
  "  #[fg=cyan]\uf044#[default]  Open with vifm" 'c' {
    display-popup -d"#{pane_current_path}" "vifm"
  }\
  "-" "" ""\
  ""\
  "  #[fg=cyan]Next Menu#[align=right,default,dim]Server" ">" "serverbar"\
'
