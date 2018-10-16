" Sexy airline-like statusline for VIM
"
"    ┌─────────────────────────────────────────────────────────────────┐
"    │~                                                                │
"    │~                      VIM - Vi IMproved                         │
"    │~                                                                │
"    │~                         version 8.0                            │
"    │~                    by Bram Moolenaar et al.                    │
"    │~          Vim is open source and freely distributable           │
"    │~                                                                │
"    │~          type :h :q<Enter>          to exit                    │
"    │~          type :help<Enter> or <F1>  for on-line help           │
"    │~          type :help version8<Enter> for version info           │
"    │~                                                                │
"    │~                                                                │
"    ├─────────────────────────────────────────────────────────────────┤
"    │ [...]   A    B       -C-     V   W  X  Y    Z   [...] │
"    └─────────────────────────────────────────────────────────────────┘
"

" TODO: Hoping to reduce some runtime resources, UNTESTED!
if &laststatus == 1
  finish
endif

" Syntastic statusline format
let g:syntastic_stl_format = " %E{E:%e}%B{, }%W{W:%w} ☰ %F "

" Custom modes.
let g:currentmode = {
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

" TODO: Add functions that utilizes a global/local dictionary
" for custom flags symbol/unicode. for a one function-rule-them-all thingy??
" TODO: Autoload this.

" Syntastic
function! LoadSyntastic()
  if exists('g:loaded_syntastic_plugin')
    return SyntasticStatuslineFlag()
  else
    return ''
  endif
endfunction

" Custom Readonly unicode.
function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

set statusline=                                             " Clear defaults.
set statusline+=%8*%{&paste?\ '\ \ PASTE\ '\ :\ ''}         " Paste mode flag.
set statusline+=%9*                                        " Separator
set statusline+=%4*                                        " Separator
set statusline+=%1*\ %{(g:currentmode[mode()])}\            " Current Mode
set statusline+=%2*                                        " Separator.
set statusline+=%3*                                        " Separator.
set statusline+=%5*\ %t\                                    " File name.
set statusline+=%5*%M\                                      " Modified '+'
set statusline+=%6*                                        " Separator.
set statusline+=%0*\ %{ReadOnly()}                          " Readonly ''
set statusline+=%0*\ %h                                     " Help '[Help]'
set statusline+=%0*\ %W                                     " Preview '[PRV]'
set statusline+=%=
set statusline+=%0*\ %{strlen(&ft)\ ?\ &ft\ :\ 'noft'}\     " Filetype.
set statusline+=%6*                                        " Separator.
set statusline+=%<
set statusline+=%5*\ %{&fenc\ ?\ &fenc\ :&enc}              " UTF-8
set statusline+=%5*(%{&fileformat})\                        " Unix / Dos
set statusline+=%5*\ %{&et\ ?\ 'ET'\ :\ 'noet'}\            " Et / noet
set statusline+=%5*\ SW:%{&shiftwidth}\                     " ShiftWidth
set statusline+=%3*                                        " Separator
set statusline+=%2*                                        " Separator
set statusline+=%1*\ %3p%%                                  " Percentage
set statusline+=%7*\ ☰\ %1*%2l,%2v                          " Line / Column
set statusline+=%7*\ %L\                                    " Total lines
set statusline+=%4*                                        " Separator
set statusline+=%9*                                        " Separator
set statusline+=%8*%{LoadSyntastic()}                       " Syntastic

hi statusline cterm=bold,reverse ctermfg=235 ctermbg=250
hi statuslineNC cterm=bold,reverse ctermfg=235 ctermbg=250
" TODO: Support changing theme here, maybe get the values
" from the main colorscheme file dynamically.
" Apparently this colors looks badass in my secondary monitor.
" How about trying weak to strong tones?
" Fist layer of statusline with backdrop. ( Current Mode )
hi User1 cterm=bold ctermfg=251 ctermbg=240
hi User2 cterm=bold ctermfg=240 ctermbg=238
hi User3 cterm=bold ctermfg=238 ctermbg=237

" TODO: Fix order of User highlight group.

" error separator backdrop
hi User4 cterm=bold ctermfg=239 ctermbg=240

" second layer from statusline color. ( Filename, Fileformat )
hi User5 cterm=bold ctermfg=248 ctermbg=237
"second layer closing separator.
hi User6 ctermfg=237 ctermbg=235
" emphasis
hi User7 cterm=bold ctermfg=235 ctermbg=240
" Syntastic errors / warnings, Paste mode
hi User8 cterm=bold ctermfg=237 ctermbg=167
" error separator
hi User9 cterm=bold ctermfg=167 ctermbg=239