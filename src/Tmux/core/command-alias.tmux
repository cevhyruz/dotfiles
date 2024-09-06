# vi:ft=tmux fdm=marker

set -ugq command-alias

set -ag command-alias split-pane="splitw -vc '#{pane_current_path}'"
set -ag command-alias splitp="splitw -vc '#{pane_current_path}'"
set -ag command-alias info="showmsgs -JT"
set -ag command-alias choose-window="choose-tree -F'#{E:_window_tree_format}' -wZ"
set -ag command-alias choose-session="choose-tree -F'#{E:_window_tree_format}' -sZ"

set -ag command-alias choose-tree=\
"choose-tree -F'#{E:_window_tree_format}' -K'#{E:_window_tree_key_format}' -Z"

set -ag command-alias choose-buffer=\
"choose-buffer -F'#{E:_window_buffer_format}' -K'#{E:_window_tree_key_format}' -Z"

set -ag command-alias vsplit="splitw -hc '#{pane_current_path}'"
set -ag command-alias split="splitw -vc '#{pane_current_path}'"
set -ag command-alias popup="popup -EE -d '#{pane_current_path}'"
set -ag command-alias neww="neww -c '#{pane_current_path}'"

set -ag command-alias zoom="resize-pane -Z"


#'display-popup -BE -xW -yW -h7 -w78 "whiptail --inputbox \"Rename current window to : \" 7 78"; send-keys "\C-c"'
set -ag command-alias rename-current-window=\
'display-popup -BE -xW -yW -h7 -w75 "dialog --no-shadow --inputbox  \"this is a message\" 7 80"'

set -ag command-alias kill_current_pane=\
' display-menu -T"#[reverse bold] #{pane_current_command} #[default]" -xW -yW '\
' "-" "" ""'\
' "-#[bold fg=white bg=colour233]                         #[fg=cyan]       " "" ""'\
' "-#[bold fg=white bg=colour233]  Kill the current pane? #[fg=cyan](y/n)  " "" ""'\
' "-#[bold fg=white bg=colour233]                         #[fg=cyan]       " "" ""'\
' "-" "" ""'\
' "    Yes kill current pane" "y" "kill-pane"'\
' "    No Do not kill pane " "n" ""'\
' "-" "" ""'\
' "-🔻🔻🔻" "" ""'\


# window navigation
set -ag command-alias win1="select-window -t:=1"
set -ag command-alias win2="select-window -t:=2"
set -ag command-alias win3="select-window -t:=3"
set -ag command-alias win4="select-window -t:=4"
set -ag command-alias win5="select-window -t:=5"
set -ag command-alias win6="select-window -t:=6"
set -ag command-alias win7="select-window -t:=7"
set -ag command-alias win8="select-window -t:=8"
set -ag command-alias win9="select-window -t:=9"


# Reload and redraw tmux,
set -ag command-alias reload=\
' refresh-client -S; '\
' source-file "${DOT_TMUX}/tmux.conf"; '\
' set-environment -hF _message "config file reloaded!"'\

set -ag command-alias version='display "#{version}"'

set -ag command-alias set-theme=\
' command-prompt -p "(theme):" {      '\
'   set -sg @theme "%%";              '\
'   source-file ${DOT_TMUX}/tmux.conf '\
' }'

set -ag command-alias current-command="display-message '#{pane_current_command}'"

set -ag command-alias which='run "ps -o state= -o comm -t #{pane_tty}"'

#-----------------------------------------------------------------------------
# choose-tree.tmux
#-----------------------------------------------------------------------------

%hidden session_menu_title=""
%hidden window_menu_title=""
%hidden sign_column=\
"#{?#{e|<:#{line},10},#{line}, "\
"#{?#{e|<:#{line},36},M-#{a:#{e|+:97,#{e|-:#{line},10}}},}}"

set -g command-alias[79] choose-tree-menu=\
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

set -ag command-alias context-menu-mouse=\
'setenv -h context 1; \
setenv -h confirm-question "Do you like to kill current pane?";\
display-menu -O -t= -T" #{pane_current_command} " -x"#{popup_mouse_x}" -y"#{E:ctx_menu_position_bot}" \
"#{?selection_active,,-}#{E:ctx_menu_1}" "" { } \
"#{E:ctx_menu_2}" "" {} \
"#{E:ctx_menu_3}" ""  {
  display-menu -O -T"[#[reverse bold] #{confirm-question} #[default]]" \
    "-" "" ""\
    "Yes," "" ""\
    "No, do not" "" ""\
    "-" "" ""
} \
"#{E:ctx_menu_4}" "" {
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    copy-mode
    send-keys -X select-line
  }
}\
'

set -ag command-alias context-menu=\
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
