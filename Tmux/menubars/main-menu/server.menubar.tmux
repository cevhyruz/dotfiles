# vi:ft=tmux


set-option command-alias[98] serverbar=\
'display-menu -T" Menu  #[#{@menu-title-active-style}]Server#[default]  Session  Music " -x0 -y0 \
  "-" "" ""\
  "  #[fg=cyan]#[default]  Reload tmux session " 'C-l' {
    source-file ${DOT_TMUX}/tmux.conf
    display-message 'reloaded'
  }\
  "  #[fg=cyan]\uf044#[default]  Quick edit a dotfile config file " 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "  #[fg=cyan]\uf6ff#[default]  Network Connection (#[dim]${wifi}#[default])" 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "-" "" ""\
  "  #[fg=cyan]\uf044#[default]  Quick edit a dotfile config file " 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "  #[fg=cyan]\uf044#[default]  Wi-Fi (${wifi})" 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "-" "" ""\
  ""\
  "  #[fg=cyan]Next Menu #[align=right,default,dim]Session" ">" "sessionbar"\
  "  #[fg=cyan]Prev Menu #[align=right,default,dim]Menu" "<" "menubar"\
'
