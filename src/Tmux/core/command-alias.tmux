# vi:ft=tmux fdm=marker

# Custom format for choose-* commands.

set-option -g command-alias[4] choose-window=\
"choose-tree -F'#{E:_window_tree_format}' -wZ"

set-option -g command-alias[5] choose-session=\
"choose-tree -F'#{E:_window_tree_format}' -sZ"

set-option -g command-alias[6] choose-tree=\
"choose-tree -F'#{E:_window_tree_format}' -K'#{E:_window_tree_key_format}' -Z"

set-option -g command-alias[7] choose-buffer=\
"choose-buffer -F'#{E:_window_buffer_format}' -K'#{E:_window_tree_key_format}' -Z"

# Everything should spawn to current working directory.

set-option -g command-alias[8] vsplit="split-window -hc '#{pane_current_path}'"
set-option -g command-alias[9] split="split-window -vc '#{pane_current_path}'"
set-option -g command-alias[10] popup="display-popup -EE -d '#{pane_current_path}'"
set-option -g command-alias[11] neww="new-window -c '#{pane_current_path}'"
set-option -g command-alias[12] reload="source-file ${DOT_TMUX}/tmux.conf"
set-option -g command-alias[13] alias='display-message "#{version}"'
set-option -g command-alias[14] version='display-message "#{version}"'
set-option -g command-alias[15] checkhealth='display-message "#{version}"'

# set current theme.
# user-options:
#   @theme [theme name]
set-option -g command-alias[16] set-theme=\
'command-prompt -p "(theme):" { '\
'  set-option -sg @theme "%%";'\
'  source-file ${DOT_TMUX}/tmux.conf;'\
'}'

#-----------------------------------------------------------------------------
# config.tmux
#-----------------------------------------------------------------------------

# left and right padding of menu items.
set-option -g @menu-item-padding 2
set-option -g @menu-separator        "│"
set-option -g @menu-separator-style  "bold,fg=colour238"

set-option -g @menu-link-style "fg=cyan"

set-option -g @menu-title-active-style "bold,fg=cyan,bg=#222222"
set-option -g @menu-title-style        "bold,fg=colour244,bg=colour234"

set-option -g @icon-style          "fg=cyan"
set-option -g @icon-disabled-style "fg=colour235,bg=colour233"

%hidden menu_1="#{E:pad}Main#{E:pad}"
%hidden menu_2="#{E:pad}Server#{E:pad}"
%hidden menu_3="#{E:pad}Session#{E:pad}"

%hidden link_next_text="#[push-default #{@menu-link-style}]Next menu"
%hidden link_prev_text="#[push-default #{@menu-link-style}]Prev menu"
%hidden link_path="#[pop-deafult dim]testigo"

%hidden menu_sep="#[push-default #{@menu-separator-style}]#{@menu-separator}#[pop-default default]"

#-----------------------------------------------------------------------------
# choose-tree.tmux
#-----------------------------------------------------------------------------

%hidden session_menu_title=""
%hidden window_menu_title=""
%hidden sign_column=\
"#{?#{e|<:#{line},10},#{line}, "\
"#{?#{e|<:#{line},36},M-#{a:#{e|+:97,#{e|-:#{line},10}}},}}"

set-option command-alias[90] choose-tree-menu=\
'run-shell -C "display-menu -T\"#{E:menu_title}\" -x0 -y0 \"-\" \"\" \"\" \
#{S: \"- #[bold fg=orange]#S \
#{?session_attached,\
#[#{@tree-session-attached-style}]#{@tree-session-attached-format},\
#[#{@tree-session-style}]#{@tree-session-format}}\" \"\" \"\" \
#{W: \"#[push-default fg=colour239]#{?#{==:#{last_window_index},#I},╰─,│ } #I \
#[pop-default default]#{?#{==:#F,*},#W,#W} \
#[align=right bold fg=orange] ─➤    \
\" \"\" \"attach-session -t#S; select-window -t#I\" }\
\"-\" \"\" \"\"} \
\"\" \
\"test\" \">\" \"serverbar\" \
"'

#-----------------------------------------------------------------------------
# context.tmux
#-----------------------------------------------------------------------------

%hidden ctx_style="#[push-default #{@context-menu-style}]"
%hidden ctx_icon_disabled_style="#[push-default #{@context-icon-disabled-style}]"

%hidden ctx_reset="#[pop-default default]"

%hidden ctx_icon_style="#{props_begin}"

# context icons
# @FIXME: use padding from user option.
%hidden ctx_icon_1="#{p2:}#{props_begin}\uf01e#{ctx_reset}#{p2:}"
%hidden ctx_icon_2="#{p2:}#{props_begin}\uf044#{ctx_reset}#{p2:}"
%hidden ctx_icon_3="#{p2:}#{props_begin}\uf6ff#{ctx_reset}#{p2:}"

# context menu item
%hidden ctx_menu_1="#{E:ctx_icon_1}Copy"
%hidden ctx_menu_2="#{E:ctx_icon_2}Paste"
%hidden ctx_menu_3="#{E:ctx_menu_2} from buffer"
%hidden ctx_menu_3="#{E:ctx_icon_2}Kill pane"
%hidden ctx_menu_4="#{E:ctx_icon_3}Select Line"

# "#{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]W"

# display menu at the bottom where user clicks.
%hidden ctx_menu_position_bot="#{e|+:#{popup_mouse_y},6}"

# %hidden offset_y="#{e|>:#{pane_height},}"

set-option command-alias[94] context-menu-mouse=\
'setenv -h context 1; \
setenv -h confirm-question "Do you like to kill current pane?";\
display-menu -O -t= -T" #{pane_current_command} " -x"#{popup_mouse_x}" -y"#{E:ctx_menu_position_bot}" \
"#{?selection_active,,-}#{E:ctx_menu_1}" "" { } \
"#{E:ctx_menu_2}" "" {} \
"#{E:ctx_menu_3}" ""  "confirm-menu-mouse" \
"#{E:ctx_menu_4}" "" {
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    copy-mode
    send-keys -X select-line
  }
}\
'

set-option command-alias[89] confirm-menu=\
'display-menu -T"Do you like to?"\
  "test" "test" "test"\
'

set-option command-alias[89] confirm-menu-mouse=\
'display-menu -O -t= -T"[#[reverse bold] #{confirm-question} #[default]]"\
  "-" "" ""\
  "Yes, #{confirm_agree}" "" ""\
  "No, do not #{config_disagree}" "" ""\
  "-" "" ""\
'

set-option command-alias[95] context-menu=\
'display-menu -x"#{copy_cursor_x}" -y"#{copy_cursor_y}" \
"#{?selection_active,,-}#{E:ctx_menu_1}" "" { } \
"#{?selection_active,,-}#{E:ctx_menu_1}As" "" { } \
"#{E:ctx_menu_2}" "" { } \
"#{E:ctx_menu_3}" "" {
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    copy-mode
    send-keys -X select-line
  }
}'

#-----------------------------------------------------------------------------
# menu.tmux
#-----------------------------------------------------------------------------

# 3 Tabs tmux menu.

%hidden menu_title=\
"#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Main},#[#{@menu-title-active-style}]#{E:menu_1},"\
"#[#{@menu-title-style}]#{E:menu_1}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Server},#[#{@menu-title-active-style}]#{E:menu_2},#[#{@menu-title-style}]#{E:menu_2}}#[pop-default default]#{E:menu_sep}"\
"#[push-default]#{?#{==:#{name},Session},#[#{@menu-title-active-style}]#{E:menu_3},#[#{@menu-title-style}]#{E:menu_3}}#[pop-default default]#{E:menu_sep}"

%hidden menu_help="-Press <#[push-default fg=cyan]?#[pop-default default]> for for \"help\"."

# menubar
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

# serverbar
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
# sessionbar
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
