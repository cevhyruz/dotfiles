# vi:ft=tmux fdm=marker
#
# 3-tab menu using tmux 'display-popup' command
#
#  ┌──│ Main │ <Session> │ Server │──┐
#  │                                 │
#  │  Menu short description         │
#  │                                 │
#  │  Group 1 description            │
#  │      Item 1                    │
#  │      Item 2                    │
#  │      Item 3                    │
#  │                                 │
#  │  Group 2 description            │
#  │      Action 1                  │
#  │      Action 2                  │
#  │      Action 3                  │
#  │                                 │
#  │  Press <?> for "help"           │
#  │                                 │
#  ├─────────────────────────────────┤
#  │ Prev Menu              Main (<) │
#  │ Next Menu            Server (>) │
#  └─────────────────────────────────┘
#
# User options:
#  @menu-position [x,y]

# style configuration
set -g @menu-item-padding       2
set -g @menu-separator          "│"
set -g @menu-separator-style    "bold,fg=colour238"
set -g @menu-link-style         "fg=cyan"
set -g @menu-title-active-style "bold,fg=cyan,bg=#222222"
set -g @menu-title-style        "bold,fg=colour244,bg=colour234"
set -g @icon-style              "fg=cyan"
set -g @icon-disabled-style     "fg=colour235,bg=colour233"

%hidden menu_1="#{E:pad}Main#{E:pad}"
%hidden menu_2="#{E:pad}Session#{E:pad}"
%hidden menu_3="#{E:pad}Server#{E:pad}"


%hidden menu_sep="#[push-default #{@menu-separator-style}]#{@menu-separator}#[pop-default default]"

# menu header that shows current tab
# user options:
#   @menu-title-active-style  [style]
#   @menu-title-style         [style]
%hidden menu_title=\
"#{E:menu_sep}#[push-default]#{?#{==:#{name},Main},"\
"#[#{@menu-title-active-style}]#{E:menu_1},"\
"#[#{@menu-title-style}]#{E:menu_1}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Server},#[#{@menu-title-active-style}]#{E:menu_2},#[#{@menu-title-style}]#{E:menu_2}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Session},#[#{@menu-title-active-style}]#{E:menu_3},#[#{@menu-title-style}]#{E:menu_3}}#[pop-default default]#{E:menu_sep}"

%hidden link_next_text="#[push-default #{@menu-link-style}]Next menu"
%hidden link_prev_text="#[push-default #{@menu-link-style}]Prev menu"
%hidden link_path="#[pop-deafult dim]testigo"
# --------------------------------------------------------


%hidden menu_help="-Press <#[push-default fg=cyan]?#[pop-default default]> for for \"help\"."

# menubar
%hidden menu_item_1="#{E:pad}New window#{E:pad}"
%hidden menu_item_2="#{E:pad}New named window#{E:pad}"
%hidden menu_item_3="#{E:pad}Break as named pane#{E:pad}"
%hidden menu_item_4="#{E:pad}New named session#{E:pad}"
%hidden menu_item_5="#{E:pad}Open with Vifm#{E:pad}"
set-option -ag command-alias menubar=\
'setenv -h name "Main";\
display-menu -T"#{E:menu_title}" -x0 -y0 \
  "-" "" ""\
  "#{E:menu_help}" "" "hellow"\
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
  "#{E:link_next_text}#{E:menu_2}" "K" serverbar\
'

set-option -ag command-alias menubar_sub=\
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
  "#{E:link_prev_text}#{E:menu_1}" "J" menubar\
  ""\
  "Help" "?" serverbar\
'

# serverbar
%hidden server_item_1="#{E:pad}Reload tmux session#{E:pad}"
%hidden server_item_2="#{E:pad}Quick edit a dotfile config file#{E:pad}"
%hidden server_item_3="#{E:pad}Network connection#{E:pad}"
%hidden server_item_4="#{E:pad}user options status#{E:pad}"
%hidden server_item_5="#{E:pad}Theme styles#{E:pad}"
set-option -ag command-alias serverbar=\
'setenv -h name "Server";\
display-menu -T"#{E:menu_title}" -x0 -y0 \
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
  "#{E:link_prev_text}#{E:menu_1}" "J" menubar \
  "#{E:link_next_text}#{E:menu_3}" "K" sessionbar \
'
# sessionbar
%hidden session_item_1="#{E:pad}Session keybindings#{E:pad}"
%hidden session_item_2="#{E:pad}Session Overrides#{E:pad}"
%hidden session_item_3="#{E:pad}Formatting styles#{E:pad}"
%hidden session_item_4="#{E:pad}Style persisten per Session#{E:pad}"
%hidden session_item_5="#{E:pad}Man Pages#{E:pad}"
set-option -ag command-alias sessionbar=\
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
  "#{E:link_prev_text}#[align=right default dim]#{E:menu_2}" "J" serverbar \
