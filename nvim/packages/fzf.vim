let g:fzf_layout = { 'down': '~30%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_action = {
  \ 'ctrl-l': 'botright vsplit',
  \ 'ctrl-h': 'topleft vsplit',
  \ 'alt-t': 'tab split',
  \ 'alt-i': 'split'
  \}

augroup fzf_hide_statusline
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler signcolumn=no
    \| autocmd BufLeave <buffer> set laststatus=2 showmode
augroup end

cabbrev <silent>f :FZF<cr>
