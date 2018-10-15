" default statusline.
" set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Status Line Custom
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ 'no' : 'Normal·Operator Pending',
    \ '' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \}

function! CheckIfItemExistsFirst()

" Add checking for syntastic errors
" and warning here first. before displaying
" Unicode symbols and counts.

endfunction

let g:syntastic_stl_format = " %E{E:%e}%B{, }%W{W:%w} ☰ %F "

set statusline=                                    " Reset default statusline.
set statusline+=%1*\ %{(g:currentmode[mode()])}\   " The current mode.
set statusline+=%2*                               " Separator
set statusline+=%3*\                              " Separator.
set statusline+=%5*%t\                             " File name.
set statusline+=%6*                               " Separator.
set statusline+=%0*\ %m\ \%r\ %h\ %w\              " Status Flags.
set statusline+=%=                                 " Right Side.
set statusline+=%6*                               " Separator.
set statusline+=%<                                 " Truncate here;
set statusline+=%5*\ %{strlen(&ft)?&ft:'none'}\    " Filetype
set statusline+=%5*(%{&ff})\ \                     " FileFormat(unix/dos).
set statusline+=%5*%{&fileencoding?&fileencoding:&encoding}\ \ 
set statusline+=%5*\%{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}\ 
set statusline+=%3*                               " Separator.
set statusline+=%2*                               " Separator.
set statusline+=%7*\ ☰\ %1*%02l,%02v\              " Column number.
set statusline+=%1*%3p%%\                          " Percentage of document.
set statusline+=%4*                               " Separator.
set statusline+=%9*                               " Separator.
set statusline+=%8*%{SyntasticStatuslineFlag()}                                     " Separator

hi statusline cterm=bold,reverse ctermfg=235 ctermbg=250
hi statuslineNC cterm=bold,reverse ctermfg=235 ctermbg=250
" TODO: Support changing theme here, maybe get the values
" from the main colorscheme file dynamically.
"  Apparently this colors looks badass in my secondary monitor.
" How about trying weak to strong tones?
" Fist layer of statusline with backdrop. ( Current Mode )
hi User1 cterm=bold ctermfg=251 ctermbg=240
hi User2 cterm=bold ctermfg=240 ctermbg=238
hi User3 cterm=bold ctermfg=238 ctermbg=237
" second layer from statusline color. ( Filename, Fileformat )
hi User5 cterm=bold ctermfg=248 ctermbg=237
"second layer closing separator.
hi User6 ctermfg=237 ctermbg=235
" emphasis
hi User7 cterm=bold ctermfg=235 ctermbg=240
" error
hi User8 cterm=bold ctermfg=237 ctermbg=167
" error separator
hi User9 cterm=bold ctermfg=167 ctermbg=239
" error separator backdrop
hi User4 cterm=bold ctermfg=239 ctermbg=240