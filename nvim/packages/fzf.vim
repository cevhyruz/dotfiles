" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

autocmd! FileType fzf tnoremap <buffer> <leader><space>  <c-c>


let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

"function! s:fzf_statusline()
  " Override statusline as you like
"  highlight fzf1 ctermfg=161 ctermbg=251
"  highlight fzf2 ctermfg=23 ctermbg=251
"  highlight fzf3 ctermfg=237 ctermbg=251
"  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
"endfunction

"autocmd! User FzfStatusLine call <SID>fzf_statusline()