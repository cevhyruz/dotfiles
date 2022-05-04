# vi:ft=tmux

set-option command-alias[97] sessionbar=\
'display-menu -T" Menu  Server  #[#{@menu-title-active-style}]Session#[default]  Music " -x0 -y0 \
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
  "  #[fg=cyan]Next Menu #[align=right,default,dim]Music" ">" "musicbar"\
  "  #[fg=cyan]Prev Menu #[align=right,default,dim]Server" "<" "serverbar"\
'
