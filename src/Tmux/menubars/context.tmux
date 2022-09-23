# vi:ft=tmux

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
%hidden ctx_menu_4="#{E:ctx_icon_3}Select Line"

# "#{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]W"

set-option command-alias[94] context-menu-mouse=\
'setenv -h context 1; \
display-menu -O -t= -x"#{popup_mouse_x}" -y"#{popup_mouse_y}" \
"#{?selection_active,,-}#{E:ctx_menu_1}" "" { } \
"#{E:ctx_menu_2}" "" {} \
"#{E:ctx_menu_3}" "" {} \
"#{E:ctx_menu_4}" "" {
  if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
    copy-mode
    send-keys -X select-line
  }
}'

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
