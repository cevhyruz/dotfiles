# vi:ft=tmux

set-option command-alias[96] musicbar=\
'display-menu -T" Menu  Server  Session  #[bold,fg=cyan]Music#[default] " -x0 -y0 \
  "-" "" ""\
  "  #[fg=cyan]#[default]  Play " 'C-l' {
    source-file ${DOT_TMUX}/tmux.conf
    display-message 'reloaded'
  }\
  "  #[fg=cyan]\uf6ff#[default]  Shuffle Play" 'c' {
    display-popup -d${DOTFILES} "nvim $(fzf)"
  }\
  "  #[fg=cyan]\uf044#[default]  Adjust Volume" 'c' {
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
  "  #[fg=cyan]Prev Menu #[align=right,default,dim]Session" "<" "sessionbar"\
'
