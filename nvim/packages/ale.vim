
" let g:ale_open_list = 1   " Always show the location list if there are errors.
" let g:ale_list_window_size = 1  " Fix height for location list.

let g:ale_completion_enabled = 1

" Linter
let g:ale_linters = {
  \  'vim': ['vint'],
  \}


" NOTE: setting "g:ale_open_list = 1" will mess up the statusline.
augroup Customloclist
  autocmd!
  autocmd FileType qf
    \ setlocal laststatus=0
    \| setlocal signcolumn=no
augroup end

