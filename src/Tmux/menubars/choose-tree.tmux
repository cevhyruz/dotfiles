# vi:ft=tmux


%hidden session_menu_title=""
%hidden window_menu_title=""

%hidden sign_column="#{?#{e|<:#{line},10},#{line}, #{?#{e|<:#{line},36},M-#{a:#{e|+:97,#{e|-:#{line},10}}},}}"

# #{?#{==:#F,},,#F} flags

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

set-option command-alias[91] choose-tree-menu-session=\
'run-shell -C "display-menu -x0 -y0 #{S: \"#[bold fg=orange] #S\" \"\" \"display #S\" }"'

