
let g:sign = ' ┃'                " Git Gutter Sign.
let g:gitgutter_map_keys = 0     " Dont set mappings.

let g:gitgutter_sign_added = g:sign
let g:gitgutter_sign_modified = g:sign
let g:gitgutter_sign_removed = g:sign
let g:gitgutter_sign_removed_first_line = g:sign
let g:gitgutter_sign_modified_removed = g:sign

hi! GitGutterAdd ctermfg=64
hi! GitGutterChange ctermfg=67
hi! GitGutterDelete ctermfg=203

" [?] I remember this cause massive lag.
" augroup UpdateGitGutterOnSave
"   autocmd! UpdateGitGutterOnSave
"   autocmd BufWritePost * GitGutter
" augroup end
