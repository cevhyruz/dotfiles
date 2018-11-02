" Customize fzf colors to match your
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'PmenuSel'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', ''],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment']
\}

 "   call fzf#run({'options': '--reverse --prompt "C:\\Program Files\\"'})
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'

let $FZF_DEFAULT_OPTS =
  \ '--header="[j, k] for navigation. <space> to open, <TAB> to select" ' .
  \ '--reverse ' .
\ '--inline-info '

let g:fzf_layout = { 'down': '~35%' }


" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

augroup FzfConfig&Keybindings
  autocmd! FileType fzf
  autocmd FileType fzf tnoremap k <C-k>
    \| tnoremap q <C-c><cr>
    \| tnoremap j <C-j>
    \| tnoremap <space> <C-m>
    \| setlocal signcolumn=no showtabline=0 laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> setlocal laststatus=2 showmode ruler
    \| tmapclear
augroup end
