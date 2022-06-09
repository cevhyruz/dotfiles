# vi:ft=tmux

%hidden _reload=\
"#{@menu-icon-prefix}"\
"#[#{@menu-icon-style}]"\
"#{@fa-redo}"\
"#{@menu-icon-suffix}"\
"Reload tmux session"

%hidden _edit=\
"#{@menu-icon-prefix}"\
"#[#{@menu-icon-style}]"\
"#{@fa-edit}"\
"#{@menu-icon-suffix}"\
"Quick edit a dotfile"

set-option command-alias[99] menubar=\
'display-menu -T " #[#{@menu-title-active-style}]Menu#[default]  Server  Session  Music " -x0 -y0 \
  "-" "" ""\
  "#{E:_reload}" "r" {
    source-file ${DOT_TMUX}/tmux.conf
    display-message 'reloaded'
    display-popup "git lg"
  }\
  "#{E:_reload} show list-windows status" "r" {
    source-file ${DOT_TMUX}/tmux.conf
    display-message 'reloaded'
  }\
  "#{E:_edit}" 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  " #[#{@menu-icon-style}]#{@fa-wifi}  Wi-Fi #[align=right,fg=cyan]${wifi}" 'c' {
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
