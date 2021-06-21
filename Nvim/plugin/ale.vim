
" let g:ale_open_list = 1   " Always show the location list if there are errors.
" let g:ale_list_window_size = 1  " Fix height for location list.

let g:ale_completion_enabled = 1

let g:ale_sh_shellcheck_options = '-e SC1090'

" Linter
let g:ale_linters = {
  \  'vim': ['vint'],
  \}
