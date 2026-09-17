# vi:ft=tmux fdm=marker
#
# 3-tab menu using tmux 'display-menu' command

%hidden Tab_bar=\
"#{E:_}#[push-default ]#{?#{==:#{name},Main},#[#{@menu-title-active-style}]#{E:Tab_1},#[#{@menu-title-style}]#{E:Tab_1}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Server},#[#{@menu-title-active-style}]#{E:Tab_2},#[#{@menu-title-style}]#{E:Tab_2}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Session},#[#{@menu-title-active-style}]#{E:Tab_3},#[#{@menu-title-style}]#{E:Tab_3}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Pane},#[#{@menu-title-active-style}]#{E:Tab_4},#[#{@menu-title-style}]#{E:Tab_4}}#[pop-default default]#[fg=colour202](#{window_panes}) #{E:_}"

set-option -ag command-alias menubar=\
'setenv -h name "Main";\
display-menu -T"#{E:Tab_bar}" -xW -yW \
  "-" "" ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  New Window " "N" "command-prompt -p \"(New Window)\" { neww -c '%%' } "\
  "#[push-default #{@menu-item-icon-style}]#[default]   Browse and Open Notes" "n" "note"\
  "#[push-default #{@menu-item-icon-style}]#[default]   New Window Before" "b" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}]#[default fg=colour203]   Kill Current Window #[default align=right fg=colour6] #{window_name}" "" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  Move Window To Right      #[default fg=colour6 align=right] " ">" ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  Move Window To Left      #[fg=colour6]#{}" "<" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}] #[default]#{E:@tab-server-menu-item-1-label}" "t" "tig"\
  "#[push-default #{@menu-item-icon-style}]#[default] #{E:menu_item_4}" "" ""\
  "#[push-default #{@menu-item-icon-style}] #[pop-default default]  Show/Hide All Statusbar   #[push-default align=right fg=colour6] #[pop-default default]" "h" "set status"\
  "-" "" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}]#[pop-default default]   #{E:link_next_text}#{E:Tab_2}" "K" serverbar\
'
