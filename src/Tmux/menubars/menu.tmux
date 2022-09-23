# vi:ft=tmux fdm=marker
#
# 3 Tabs tmux menu.

%hidden menu_title=\
"#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Main},#[#{@menu-title-active-style}]#{E:menu_1},"\
"#[#{@menu-title-style}]#{E:menu_1}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Server},#[#{@menu-title-active-style}]#{E:menu_2},#[#{@menu-title-style}]#{E:menu_2}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Session},#[#{@menu-title-active-style}]#{E:menu_3},#[#{@menu-title-style}]#{E:menu_3}}#[pop-default default]#{E:menu_sep}"

# Display menu {{{1


%hidden menu_help="-Press <#[push-default fg=cyan]?#[pop-default default]> for for \"help\"."

# menubar {{{2
%hidden menu_item_1="#{E:pad}New window#{E:pad}"
%hidden menu_item_2="#{E:pad}New named window#{E:pad}"
%hidden menu_item_3="#{E:pad}Break as named pane#{E:pad}"
%hidden menu_item_4="#{E:pad}New named session#{E:pad}"
%hidden menu_item_5="#{E:pad}Open with Vifm#{E:pad}"
set-option command-alias[99] menubar=\
'setenv -h name "Main";\
display-menu -T"#{E:menu_title}" -x0 -y0 \
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "#{E:menu_item_1}" "" ""\
  "#{E:menu_item_2}" "" ""\
  "#{E:menu_item_3} -->" "" "menubar_sub"\
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "#{E:menu_item_4}" "" ""\
  "#{E:menu_item_5}" "" ""\
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "#{E:menu_item_4}" "" ""\
  "-" "" ""\
  ""\
  "#{E:link_next_text}#{E:menu_2}" ">" serverbar\
'

set-option command-alias[96] menubar_sub=\
'setenv -h name "Main";\
setenv -h menu 1;\
display-menu -T"#{E:menu_title}" -x0 -y0 \
  "-" "" ""\
  "-#[push-default default fg=red normal bright]Break as named Pane" "" ""\
  "-" "" ""\
  "#{E:menu_item_1}" "" ""\
  "#{E:menu_item_2}" "" ""\
  "#{E:menu_item_3}" "" ""\
  "-" "" ""\
  "#{E:menu_item_4}" "" ""\
  "-" "" ""\
  ""\
  "#{E:link_prev_text}#{E:menu_1}" "<" menubar\
  ""\
  "Help" "?" serverbar\
'


# serverbar {{{2
%hidden server_item_1="#{E:pad}Reload tmux session#{E:pad}"
%hidden server_item_2="#{E:pad}Quick edit a dotfile config file#{E:pad}"
%hidden server_item_3="#{E:pad}Network connection#{E:pad}"
%hidden server_item_4="#{E:pad}user options status#{E:pad}"
%hidden server_item_5="#{E:pad}Theme styles#{E:pad}"
set-option command-alias[98] serverbar=\
'setenv -h name "Server";\
display-menu -T"#{E:menu_title}"  -x0 -y0 \
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "-" "" ""\
  "#{E:server_item_1}" "" ""\
  "#{E:menu_item_4}" "" ""\
  "-" "" ""\
  "#{E:menu_item_5}" "" ""\
  "#{E:menu_item_1}" "" ""\
  "#{E:server_item_2}" "" ""\
  "#{E:server_item_3}" "" ""\
  "-" "" ""\
  "#{E:server_item_2}" "" ""\
  "#{E:server_item_3}" "" ""\
  "-" "" ""\
  "#{E:menu_item_5}" "" ""\
  "#{E:menu_item_1}" "" ""\
  "#{E:server_item_2}" "" ""\
  "#{E:server_item_3}" "" ""\
  "-" "" ""\
  ""\
  "#{E:link_prev_text}#{E:menu_1}" "<" menubar \
  "#{E:link_next_text}#{E:menu_3}" ">" sessionbar \
'
# sessionbar {{{2
%hidden session_item_1="#{E:pad}Session keybindings#{E:pad}"
%hidden session_item_2="#{E:pad}Session Overrides#{E:pad}"
%hidden session_item_3="#{E:pad}Formatting styles#{E:pad}"
%hidden session_item_4="#{E:pad}Style persisten per Session#{E:pad}"
%hidden session_item_5="#{E:pad}Man Pages#{E:pad}"
set-option command-alias[97] sessionbar=\
'setenv -h name "Session";\
display-menu -T"#{E:menu_title}" -x0 -y0 \
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "-" "" ""\
  "#{E:session_item_1}" "" ""\
  "#{E:session_item_2}" "" ""\
  "-" "" ""\
  "#{E:session_item_3}" "" ""\
  "#{E:session_item_4}" "" ""\
  "#{E:session_item_5}" "" ""\
  "-" "" ""\
  ""\
  "#{E:link_prev_text}#[align=right,default,dim]#{E:menu_2}" "<" serverbar \
'
