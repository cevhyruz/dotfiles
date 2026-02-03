# vi:ft=tmux fdm=marker
#
# 3-tab menu using tmux 'display-popup' command
#
#  ┌──│ Server │ Session | Window | Pane │──┐
#  │                                        │
#  │  Menu Description                      │
#  │                                        │
#  │  Menu Group Description                │
#  │      Menu Item 1                      │
#  │      Menu Item 2                      │
#  │      Menu Item 3                      │
#  │                                        │
#  │  Group 2 description                   │
#  │      Action 1                         │
#  │      Action 2                         │
#  │      Action 3                         │
#  │                                        │
#  │  Press <?> for "help"                  │
#  │                                        │
#  ├────────────────────────────────────────┤
#  │ Prev Menu                     Main (<) │
#  │ Next Menu                   Server (>) │
#  └────────────────────────────────────────┘
#
# Menu options:
#
# Menu options should follow the `@component-state-property` formula for
# consistent naming. Ex: @menu-session-attached-active.
#
# styles and formats do not have properties

# Properties
# style
# format
#
# padding
# separator


# buffer,
# client,
# tree
# history
# prompt
# mode
# menu (added by me)
# command
# pop-up
# pane
# window
# session
# server
# key
# layout
# shell
# environment
# hooks
# message
# options


# StatusBar
# Toggle Status Bar Visibility
# Add New Status Bar


# @tree-session-attached-format
# @tree-session-attached-style
# @tree-session-attached-style

# Menu-menuitem-padding

# style
# format

# style configuration


#




# -----------
# Menu Items
# -----------
set -g @menu-item-icon   "#[push-default fg=colour3]#[pop-default default]"
set -g @menu-item-format "#{@menu-item-icon}"
set -g @menu-item-style  ""

# -----------------------
# Menu Group Description
# -----------------------
set -g @menu-group-style ""
set -g @menu-group-format ""

# ----------------
# Menu Navigation
# ----------------
set -g @menu-nav-next-style ""
set -g @menu-nav-next-format ""


set -g @menu-item-padding       1
set -g @menu-separator          "│"
set -g @menu-separator-style    "bg=colour232,fg=colour23"
set -g @menu-link-style         "fg=cyan"
set -g @menu-title-active-style "bold,fg=cyan,bg=#222222"
set -g @menu-title-style        "bold,fg=colour244,bg=colour232"
set -g @icon-style              "fg=cyan"
set -g @icon-disabled-style     "fg=colour235,bg=colour233"


# ------------
#  Tab Names
# ------------
# default tabs
%hidden Tab_1="#{E:pad}Server#{E:pad}"
%hidden Tab_2="#{E:pad}Session#{E:pad}"
%hidden Tab_3="#{E:pad}Window#{E:pad}"
%hidden Tab_4="#{E:pad}Pane#{E:pad}"

# We need to declare this to be able to add styles to the tab separator
# without cluttering style properties everywhere.
%hidden _="#[push-default #{@menu-separator-style}]#{@menu-separator}#[pop-default default]"

# ----------
#  Tab Bar
# ----------
# user options:
#   @menu-title-active-style  [style]
#   @menu-title-style         [style]
%hidden Tab_bar=\
"#{E:_}#[push-default ]#{?#{==:#{name},Main},#[#{@menu-title-active-style}]#{E:Tab_1},#[#{@menu-title-style}]#{E:Tab_1}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Server},#[#{@menu-title-active-style}]#{E:Tab_2},#[#{@menu-title-style}]#{E:Tab_2}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Session},#[#{@menu-title-active-style}]#{E:Tab_3},#[#{@menu-title-style}]#{E:Tab_3}}#[pop-default default]#{E:_}"\
"#[push-default]#{?#{==:#{name},Pane},#[#{@menu-title-active-style}]#{E:Tab_4},#[#{@menu-title-style}]#{E:Tab_4}}#[pop-default default]#[fg=colour202](#{window_panes}) #{E:_}"

%hidden link_next_text="#[push-default #{@menu-link-style}]Next"
%hidden link_prev_text="#[push-default #{@menu-link-style}]Prev"
%hidden link_path="#[pop-deafult dim]testigo"
# --------------------------------------------------------



# ----------------
#  Tab 1 (Server) {{{1
# ----------------

%hidden menu_help="-    Press <#[push-default fg=cyan]?#[pop-default default]> for for \"help\"."


# there are no way to loop through user options/variables
# for now, we'll declare a base number and bump when necessary.
%hidden menu_item_base=0




set -g @tab-server-menu-item-1-label   "  Toggle status bar visibility"
set -g @tab-server-menu-item-1-command "set status"

set -g @tab-server-menu-item-2 "label two"
set -g @tab-server-menu-item-3 "label three"


# [/] double expansion
# [/] dynamic expansion
# [x] iteration expansion




%hidden menu_index=0

# %hidden menu_label_format="##{E:@fulbar#{menu_index}#}" # @fullbar1


%hidden menu_label_format="##{E:@tab-server-menu-item-#{e|+:0,#{menu_index}}#}" # @fullbar1


# this format should be able to expand accordingly and 
# only declared once
%hidden format="##{E:@tab-server-menu-item-#{e|+:1,#{menu_index}}#}" # @fullbar1

set -gF @testigo "##{#{E:menu_label_format}} menu-item-(#{menu_index})"


%hidden menu_index=1
set -gF @menu-item-1 "##{#{E:menu_label_format}} menu-item-(#{menu_index})"
%hidden menu_index=2
set -gF @menu-item-2 "##{#{E:menu_label_format}} menu-item-(#{menu_index})"

# %hidden menu_item_1="#{@fulbar#{e|+:1,#{menu_item_base}}}#{E:pad}Toggle statusline#{E:pad}"



set -gF @foobar "#{E:@testigo}"

# %hidden menu_item_1="#{E:@testigo}"

%hidden menu_item_2="#{E:pad}#[push-default fg=cyan,bold]R#[pop-default default]eload configuration file#{E:pad}"
%hidden menu_item_3="#{e|+:1,#{menu_item_base}}#{E:pad}Break as named pane#{E:pad}"
%hidden menu_item_4="#{E:pad} New named session#{E:pad}"
%hidden menu_item_5="#{E:pad}  Open with Vifm#{E:pad}"


set-option -ag command-alias menubar=\
'setenv -h name "Main";\
display-menu -T"#{E:Tab_bar}" -xW -yW \
  "-" "" ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  New Window " "N" "neww"\
  "#[push-default #{@menu-item-icon-style}]#[default]   New Window After #{window_name}" "n" ""\
  "#[push-default #{@menu-item-icon-style}]#[default]   New Window Before" "b" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}]#[default fg=colour203]   Kill Current Window #[default align=right fg=colour6] #{window_name}" "" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  Move Window To Right      #[default fg=colour6 align=right] " ">" ""\
  "#[push-default #{@menu-item-icon-style}] #[default]  Move Window To Left      #[fg=colour6]#{}" "<" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}] #[default]#{E:@tab-server-menu-item-1-label}" "t" "set status"\
  "#[push-default #{@menu-item-icon-style}]#[default] #{E:menu_item_4}" "" ""\
  "#[push-default #{@menu-item-icon-style}] #[pop-default default]  Show/Hide All Statusbar   #[push-default align=right fg=colour6] #[pop-default default]" "h" "set status"\
  "-" "" ""\
  ""\
  "#[push-default #{@menu-item-icon-style}]#[pop-default default]   #{E:link_next_text}#{E:Tab_2}" "K" serverbar\
'

# ----------------
#  Tab 1 (Server submenu)
# ----------------

# menubar_sub
set-option -ag command-alias menubar_sub=\
'setenv -h name "Main";\
setenv -h menu 1;\
display-menu -T"#{E:Tab_bar}" -xW -yW \
  "-" "" ""\
  "-#[push-default default fg=red normal bright]Break as named Pane" "" ""\
  "-" "" ""\
  "#{E:menu_help}" "" ""\
  "#{E:menu_item_1}" "" ""\
  "#{E:menu_item_2}" "" ""\
  "#{E:menu_item_3}" "" ""\
  "-" "" ""\
  "#{E:menu_item_4}" "" ""\
  "-" "" ""\
  ""\
  "#{E:link_prev_text}#{E:Tab_1}" "J" menubar\
  ""\
  "Help" "?" serverbar\
'

# -----------------
#  Tab 2 (Session) {{{1
# -----------------

# Session Tab
%hidden server_item_1="#{E:pad}Reload tmux haaha#{E:pad}"
%hidden server_item_2="#{E:pad}Quick edit a dotfile config file#{E:pad}"
%hidden server_item_3="#{E:pad}Network connection#{E:pad}"
%hidden server_item_4="#{E:pad}user options status#{E:pad}"
%hidden server_item_5="#{E:pad}Theme styles#{E:pad}"
set-option -ag command-alias serverbar=\
'setenv -h name "Server";\
display-menu -T"#{E:Tab_bar}" -xW -yW \
  "-" "" ""\
  "-    Session Name               #[fg=colour6]#S" "" ""\
  "-    Session Path               #[fg=colour6]#{session_path}" "" ""\
  "-    Session Windows            #[fg=colour6]#{session_windows}" "" ""\
  "-" "" ""\
  "#{E:server_item_1}" "" "select-pane -e"\
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
  "#[push-default fg=colour14 bold] Next Menu  #[align=right] Window " "K" sessionbar \
  " #{E:link_prev_text}#{E:Tab_1}" "J" menubar \
'

# -----------------
#  Tab 3 (Window) {{{1
# -----------------

# sessionbar
%hidden session_item_1="#{E:pad}Session keybindings#{E:pad}"
%hidden session_item_2="#{E:pad}Session Overrides#{E:pad}"
%hidden session_item_3="#{E:pad}Formatting styles#{E:pad}"
%hidden session_item_4="#{E:pad}Style persisten per Session#{E:pad}"
%hidden session_item_5="#{E:pad}Man Pages#{E:pad}"
set-option -ag command-alias sessionbar=\
'setenv -h name "Session";\
display-menu -T"#{E:Tab_bar}" -xW -yW \
  "-" "" ""\
  "Active Window            #[#{@menu-item-right-style}]#{window_name}" "" ""\
  "Window Panes             #[#{@menu-item-right-style}]#{window_panes}" "" ""\
  "Window Linked Session/s  #[#{@menu-item-right-style}]#{window_linked_sessions} (#{window_linked_sessions_list})" "" ""\
  "Window Active Session/s  #[#{@menu-item-right-style}]#{window_active_sessions} (#{window_active_sessions_list})" "" ""\
  "Window Active Client/s   #[#{@menu-item-right-style}]#{window_active_clients} (#{window_active_clients_list})" "" ""\
  "Window Last Activity     #[#{@menu-item-right-style}]#{t:window_activity}" "" ""\
  "-" "" ""\
  "#{E:session_item_1}" "" ""\
  "#{E:session_item_2}" "" ""\
  "-" "" ""\
  "#{E:session_item_3}" "" ""\
  "#{E:session_item_4}" "" ""\
  "#{E:session_item_5}" "" ""\
  "-" "" ""\
  ""\
  "#[push-default fg=colour14 bold] Next Menu #[align=right] Pane" "K" panetab \
  "#[push-default] Prev Menu " "J" serverbar \
'

# -----------------
#  Tab 4 (Session) {{{1
# -----------------

# sessionbar
%hidden session_item_1="#{E:pad}Session keybindings#{E:pad}"
%hidden session_item_2="#{E:pad}Session Overrides#{E:pad}"
%hidden session_item_3="#{E:pad}Formatting styles#{E:pad}"
%hidden session_item_4="#{E:pad}Style persisten per Session#{E:pad}"
%hidden session_item_5="#{E:pad}Man Pages#{E:pad}"
set-option -ag command-alias panetab=\
'setenv -h name "Pane";\
display-menu -T"#{E:Tab_bar}" -xW -yW \
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
  "#{E:link_prev_text}#[align=right default dim]#{E:Tab_2}" "J" sessionbar \
'
