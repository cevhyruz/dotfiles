let g:fzf_layout = {'down': '~25%'}

let g:fzf_action = {
\ 'ctrl-h': 'topleft vsplit',
\ 'ctrl-n': 'botright split',
\ 'ctrl-p': 'topleft split',
\ 'ctrl-l': 'botright vsplit',
\ 'alt-h':  'leftabove vsplit',
\ 'alt-j':  'belowright split',
\ 'alt-k':  'aboveleft split',
\ 'alt-l':  'rightbelow vsplit',
\ 'alt-t':  'tab split' }

let g:fzf_colors = {
\ 'fg':      ['fg', 'Normal'],
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

"# changes current selected highlight color
" \ 'bg':      ['bg', 'Normal'],
augroup hide_fzf_statusline
  autocmd!
  autocmd FileType fzf setlocal ls=0 noshowmode noruler nonu nornu fdc=0 scl=no
    \| autocmd BufLeave <buffer> set ls=2 showmode ruler
augroup END
