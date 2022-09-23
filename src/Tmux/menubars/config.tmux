# vi:ft=tmux

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
