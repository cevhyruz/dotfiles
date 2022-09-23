let g:startify_bookmarks = [
  \ {'c': '~/Projects/dotfiles/nvim/init.vim'},
  \ {'t': '~/Projects/dotfiles/tmux/tmux.conf'},
  \ {'i': '~/Projects/dotfiles/tmux/scripts/init'},
  \]
let g:startify_files_number = 8
let g:startify_update_oldfiles = 0
let g:startify_session_autoload = 0
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 0
let g:startify_padding_left = 7
let g:startify_enable_special = 0
let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
