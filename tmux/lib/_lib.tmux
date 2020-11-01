# vi:ft=tmux

# dotfiles location.
# FIXME: this should be setup upon dotfiles installation.
set-option -s @LIB:DOTFILES_DIR "${HOME}/Projects/dotfiles"

# tmux dotfiles location.
set-option -sF @LIB:TMUX_DIR "#{@LIB:DOTFILES_DIR}/tmux"

# tmux helper files.
set-option -sF @LIB:TMUX_LIB "#{@LIB:TMUX_DIR}/lib"

# tmux extra config logation.
set-option -sF @LIB:TMUX_LOCALR "#{@LIB:DOTFILES_DIR}/_localrc"

# theme directory location.
set-option -sF @LIB:TMUX_THEME "#{@LIB:TMUX_DIR}/themes"

# plugin directory location.
set-option -sF @LIB:TMUX_PLUG "#{@LIB:TMUX_DIR}/plugins"

# process checks
%hidden IS_FZF="ps -o comm= -t '#{pane_tty}' | grep -q fzf"
%hidden IS_VIM="ps -o comm= -t '#{pane_tty}' | grep -iqE '(view|n?vim?x?)(diff)?$'"
