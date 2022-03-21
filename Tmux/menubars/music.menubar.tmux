# vi:ft=tmux

set-option command-alias[96] musicbar=\
'display-menu -T" Menu  Server  Session  #[bold,fg=cyan]Music#[default] " -x0 -y0 \
  "-" "" ""\
  "-#[fg=cyan]song:   #[default]#(playerctl metadata title)" "" ""\
  "-#[fg=cyan]artist: #[default]#(playerctl metadata artist)" "" ""\
  "-#[fg=cyan]album:  #[default]#(playerctl metadata album)" "" ""\
  "-" "" ""\
  "#[fg=cyan]#[default]  Toggle Play / Pause      " "Space" {
    run-shell "playerctl play-pause"
  }\
  "#[fg=cyan]#[default]  Next      " "" {
    run-shell "playerctl next"
  }\
  "#[fg=cyan]#[default]  Previous      " "" {
    run-shell "playerctl previous"
  }\
  "-" "" ""\
  ""\
  "  #[fg=cyan]Prev Menu #[align=right,default,dim]Session" "<" "sessionbar"\
'
