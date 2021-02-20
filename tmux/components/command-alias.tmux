# vi:ft=tmux

 #navigation {{{2

#set-option -s command-alias[6] down='
  #if-shell "$IS_VIM || $IS_FZF" {
    #if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
      #select-pane -D
    #} {
      #send-keys C-j
    #}
  #} { select-pane -D }'

#set-option -s command-alias[11] down="if-shell "'${IS_FZF}" "send-keys C-j""

#set-option -g command-alias[7] up='
#if-shell "$IS_VIM || $IS_FZF" {
   #if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
       #select-pane -U
   #} {
    #send-keys C-k
   #}
#} { select-pane -U }'

#set-option -s command-alias[8] right='
#if-shell "$IS_VIM" {
  #if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    #select-pan  -R
  #} {
    #send-keys c-l
  #}
#} { select-pane -R }'


#set-option -s command-alias[9] left='
#if-shell "$IS_VIM" {
  #if-shell -F "#{m/r:(copy|view)-mode,#{pane_mode}}" {
    #select-pane -L
  #} {
    #send-keys c-h
  #}
#} { select-pane -L }'


#set-option -s command-alias[10] lastpane='
#if-shell "$IS_VIM" {
  #send-keys C-\
#} { last-pane }'

### resizing {{{1

#set-option -s command-alias[11]  _resize-pane-down='resize-pane -D 1'
#set-option -s command-alias[12]    _resize-pane-up='resize-pane -U 1'
#set-option -s command-alias[13] _resize-pane-right='resize-pane -R 1'
#set-option -s command-alias[14]  _resize-pane-left='resize-pane -L 1'

#set-option -s command-alias[32] term='
#command-prompt -p "[${shell}]" {
  #display-popup -keer "%1"
#}'

#set-option -s command-alias[100] version='display "#{version}"'

### Miscellaneous

#set-option -s command-alias[20] reload='
  #source-file "/etc/tmux.conf";
  #display-message " Config file reloaded";
#'

#set-option -s command-alias[24] vsplit='split-window -h'
