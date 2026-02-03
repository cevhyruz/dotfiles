# vi:ft=tmux fdm=marker

# reset all global command-aliases quietly including tmux defaults
set -ugq command-alias

# Unsets default indexed command-alias so we can override later on.
set -ugq command-alias[0] # split-pane
set -ugq command-alias[1] # splitp

# ------
# Pane {{{1
# ------

# display-menu -TTestigo -x5 -y5 'name' 'c' 'select-window'

# spliting panes should always use the current location.
set -ag command-alias split-pane="splitw -vc '#{pane_current_path}' -e \"OLDPWD=~/Downloads/\""
set -ag command-alias splitp="splitw -vc '#{pane_current_path}' -e \"OLDPWD='~/Downloads\""
set -ag command-alias split="splitw -vc '#{pane_current_path}'"
set -ag command-alias vsplit="splitw -hc '#{pane_current_path}'"

# zoom a pane
set -ag command-alias zoom="resize-pane -Z"

# kill current pane
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


# set -ag command-alias colormap="run-shell 'for ((i=0; i<256; i++)) do printf \"\e[48;5;\${i}m%s\" \"\$i\"; printf '\e[0m';  [ ! \$(( (i-15) % 6 )) -eq 0 ] && printf ' ' || printf '\n'; done; unset i; '"
#


set -ag command-alias colormap="run-shell 'bash -c \"for ((i=0; i<256; i++)) do printf \\\"\e[48;5;\\\$im%s\\\" \\\"\\\$i    \n \\\" ; done\"' "


# ------
# Tree {{{1
# ------
# choose-* commands should always at fullscreen.
set -ag command-alias choose-tree="choose-tree -F'#{E:_window_tree_format}' -K'#{E:_window_tree_key_format}' -Z"
set -ag command-alias choose-window="choose-tree -F'#{E:_window_tree_format}' -wZ"
set -ag command-alias choose-session="choose-tree -F'#{E:_window_tree_format}' -sZ"
set -ag command-alias choose-buffer="choose-buffer -F'#{E:_window_buffer_format}' -K'#{E:_window_tree_key_format}' -Z"

# ---------
# terminal {{{1
# ---------
# set -ag command-alias info="showmsgs -JT"
set -ag command-alias fulbar=\
'setenv -h name "Session";\
display-menu -T"#{E:menu_title}" -xC -yC \
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Tmux" "" ""\
  "-#[none]   Command Alias              #[push-default fg=colour6]#{E:current_path}" "" ""\
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Host" "" ""\
  "-#[none]    WiFi Status               #[push-default fg=colour6]#{E:ind_wlan}" "" ""\
  "-#[none]    Battery Status            #[push-default fg=colour6]#{E:ind_wlan}" "" ""\
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Server" "" ""\
  "-#[none]    Server User               #[fg=colour6]#{user}@#{host}" "" ""\
  "-#[none]    Server Config File/s      #[us=colour202 underscore fg=colour6]#{config_files}" "" ""\
  "-#[none]    Server Sessions           #[fg=colour6]#{server_sessions}" "" ""\
  "-#[none]    Server UID                #[fg=colour6]#{uid}" "" ""\
  "-#[none]    Server Socket Path        #[fg=colour6]#{socket_path}" "" ""\
  "-#[none]    Start Time                #[fg=colour6]#{t:start_time}" "" ""\
  "-#[none]    Server Version            #[fg=colour6]#{version}" "" ""\
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Session" "" ""\
  "-#[none]    Session Name              #[fg=colour6]#S" "" ""\
  "-#[none]    Session Current Path      #[push-default us=colour202 underscore fg=colour6]#{E:current_path}" "" ""\
  "-#[none]    Session Windows           #[fg=colour6]#{session_windows}" "" ""\
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Window" "" ""\
  "-#[none]    Active Window             #[fg=colour6]#{window_name}" "" ""\
  "-#[none]    Window Panes              #[fg=colour45]#{window_panes}" "" ""\
  "-#[none]    Window Linked Session/s   #[fg=colour6]#{window_linked_sessions} (#{window_linked_sessions_list})" "" ""\
  "-#[none]    Window Active Session/s   #[fg=colour6]#{window_active_sessions} (#{window_active_sessions_list})" "" ""\
  "-#[none]    Window Active Client/s    #[fg=colour6]#{window_active_clients} (#{window_active_clients_list})" "" ""\
  "-#[none]    Window Last Activity      #[fg=colour6]#{t:window_activity}" "" ""\
  ""\
  "Copy" "" ""\
  "Close" "" ""
'

# Visual Test for terminfo

%hidden placeholder="The Brown Fox Jumps Over The Lazy Dog"
set -ag command-alias terminfo=\
'setenv -h name "Session";\
display-menu -T"#{E:menu_title}" -xC -yC \
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Tmux" "" ""\
  "-#[none]    acs                 #[push-default fg=colour6 acs]#{placeholder}" "" ""\
  "-#[none]    bright (or bold)    #[push-default fg=colour6 bold]#{placeholder}" "" ""\
  "-#[none]    dim                 #[push-default fg=colour6 dim]#{placeholder}" "" ""\
  "-#[none]    underscore          #[push-default fg=colour6 underscore]#{placeholder}" "" ""\
  "-#[none]    blink               #[push-default fg=colour6 blink]#{placeholder}" "" ""\
  "-#[none]    reverse             #[push-default fg=colour6 reverse]#{placeholder}" "" ""\
  "-#[none]    hidden              #[push-default fg=colour6 hidden]#{placeholder}" "" ""\
  "-#[none]    italics             #[push-default fg=colour6 italics]#{placeholder}" "" ""\
  "-#[none]    overline            #[push-default fg=colour6 overline]#{placeholder}" "" ""\
  "-#[none]    strikethrough       #[push-default fg=colour6 strikethrough]#{placeholder}" "" ""\
  "-#[none]    double-underscore   #[push-default fg=colour6 double-underscore]#{placeholder}" "" ""\
  "-#[none]    curly-underscore    #[push-default fg=colour6 curly-underscore]#{placeholder}" "" ""\
  "-#[none]    dotted-underscore   #[push-default fg=colour6 dotted-underscore]#{placeholder}" "" ""\
  "-#[none]    dashed-underscore   #[push-default fg=colour6 dashed-underscore]#{placeholder}" "" ""\
  "-" "" ""\
  "-#[push-default none bold fg=colour45]Extended Underline (OSC 58 / 24-bit underline color)" "" ""\
  "-#[none]    overline            #[push-default us=color202 fg=colour6 overline]#{placeholder}" "" ""\
  "-#[none]    strikethrough       #[push-default us=color202 fg=colour6 strikethrough]#{placeholder}" "" ""\
  "-#[none]    underscore          #[push-default us=color202 fg=colour6 underscore]#{placeholder}" "" ""\
  "-#[none]    double-underscore   #[push-default us=color202 fg=colour6 double-underscore]#{placeholder}" "" ""\
  "-#[none]    curly-underscore    #[push-default us=colour202 fg=colour6 curly-underscore]#{placeholder}" "" ""\
  "-#[none]    dotted-underscore   #[push-default us=colour202 fg=colour6 dotted-underscore]#{placeholder}" "" ""\
  "-#[none]    dashed-underscore   #[push-default us=color202 fg=colour6 dashed-underscore]#{placeholder}" "" ""\
'


# ---------
# popup {{{1
# ---------
set -ag command-alias popup="popup -EE -d '#{pane_current_path}'"

# ---------
# window {{{1
# ---------
# new window
set -ag command-alias neww="neww -c '#{pane_current_path}'"

# rename current window
set -ag command-alias rename-current-window=\
'display-popup -BE -xW -yW -h7 -w78 "whiptail --inputbox \"Rename current window to : \" 7 78 #{window_name}"; send-keys "\C-c"'


set-option -g @message-log "";

set -ag command-alias clear-message-log=" refresh-client -S; set-option -ugq @message-log;"

# Reload and redraw tmux,
set -ag command-alias reload=\
' refresh-client -S; '\
' source-file "${DOT_TMUX}/tmux.conf"; '\
' set-option -ag @message-log "config file reloaded!"'\

# set -ag command-alias reload=\
# ' refresh-client -S; '\
# ' source-file "${DOT_TMUX}/tmux.conf"; '\
# ' set-environment -hF _message "config file reloaded!"'\

set -ag command-alias version='display "#{version}"'

# set -ag command-alias set-theme=\
# ' command-prompt -p "(theme):" {      '\
# '   set -sg @theme "%%";              '\
# '   source-file ${DOT_TMUX}/tmux.conf '\
# ' }'

  # "#[push-default none bold fg=colour45]  █" "" ""\
  # "#[push-default none bold fg=colour45]  █" "" ""\

set -ag command-alias set-theme=\
'setenv -h name "Session";\
display-menu -T"#{E:menu_title}" -x0 -y0 \
  "-" "" ""\
  "Default  #[push-default none bold fg=colour45 align=right] ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇" "" "set -sg @theme default; source-file ${DOT_TMUX}/tmux.conf"\
  "Base16   #[push-default none bold fg=colour45 align=right] ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇" "" "set -sg @theme default; source-file ${DOT_TMUX}/tmux.conf"\
  "Powerline#[push-default none bold fg=colour45 align=right] ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇ ▇▇▇" "" "set -sg @theme powerline; source-file ${DOT_TMUX}/tmux.conf"\
'


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
