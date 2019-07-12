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
 \ 'alt-t':  'tab split'
\}

augroup hide_fzf_statusline
  autocmd!
  autocmd FileType fzf setlocal ls=0 noshowmode noruler nonu nornu fdc=0 scl=no
    \| autocmd BufLeave <buffer> set ls=2 showmode ruler
augroup END
