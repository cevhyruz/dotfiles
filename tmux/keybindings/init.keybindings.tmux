# setup prefixes
set  -g prefix  `
bind -T prefix  ` send-prefix
set  -g prefix2 C-b

# keybindings that I don't use or have been remapped
unbind -T prefix %   # vertical split
unbind -T prefix '"' # horizontal split
unbind -T prefix \;  # last-pane

# client key tables
source ~/Projects/dotfiles/tmux/keybindings/root.keybindings.tmux
source ~/Projects/dotfiles/tmux/keybindings/prefix.keybindings.tmux
source ~/Projects/dotfiles/tmux/keybindings/custom-client-table/navigate.keybindings.tmux

%if #{==:#{mode-keys},vi}
  unbind -aT copy-mode
  source -q ~/Projects/dotfiles/tmux/keybindings/copy-mode-vi.keybindings.tmux
%else
  unbind -aT copy-mode-vi
  source -q ~/Projects/dotfiles/tmux/keybindings/copy-mode.keybindings.tmux
%endif


# TODO: I can just move this check in init.tmux(sh)
