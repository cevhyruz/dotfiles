# vi:ft=tmux

set-option command-alias[96] musicbar=\
'display-menu -T" Menu  Server  Session  #[#{@menu-title-active-style}]Music#[default] " -x0 -y0 \
  "-" "" ""\
  "-#[fg=cyan]song:   #[default]#(playerctl metadata title)" "" ""\
  "-#[fg=cyan]artist: #[default]#(playerctl metadata artist)" "" ""\
  "-#[fg=cyan]album:  #[default]#(playerctl metadata album)" "" ""\
  "-" "" ""\
  "#[fg=cyan]#[default]  Toggle Play / Pause      " "" {
    run-shell "playerctl play-pause";
    run-shell "tmux musicbar"
  }\
  "#[fg=cyan]#[default]  Next      " "" {
    run-shell "playerctl next"
    run-shell "tmux musicbar"
  }\
  "#[fg=cyan]#[default]  Previous      " "" {
    run-shell "playerctl previous"
    run-shell "tmux musicbar"
  }\
  "-" "" ""\
  ""\
  "  #[fg=cyan]Prev Menu #[align=right,default,dim]Session" "<" "sessionbar"\
'
