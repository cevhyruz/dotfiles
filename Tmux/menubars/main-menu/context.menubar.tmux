# vi:ft=tmux

%hidden ctx_title="#[bold]#{pane_current_command}"
%hidden ctx_padding=" "

%hidden ctx_icon_style="#[push-default fg=cyan]"

# context icons.
%hidden ctx_icon_1="#{ctx_icon_style}#{ctx_padding}  #{reset}"
%hidden ctx_icon_2="#{ctx_icon_style}#{ctx_padding}  #{reset}"
%hidden ctx_icon_3="#{ctx_icon_style}#{ctx_padding}  #{reset}"

# context item formats.
%hidden ctx_menu_1="#{E:ctx_icon_1}Copy#{ctx_padding}"
%hidden ctx_menu_2="#{E:ctx_icon_2}Paste#{ctx_padding}"
%hidden ctx_menu_3="#{E:ctx_icon_3}Select Line#{ctx_padding}"

set-option command-alias[95] context-menu=\
'display-menu -T" #{E:ctx_title} " -O -t= -xM -yM \
  "#{?selection_active,,-}#{E:ctx_menu_1}" "" { } \
  "#{?selection_active,,-}#{E:ctx_menu_1}As" "" { } \
  "#{E:ctx_menu_2}" "" { } \
  "#{E:ctx_menu_3}" "" {
    if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" {
      copy-mode
      send-keys -X select-line
    }
  } \
'
