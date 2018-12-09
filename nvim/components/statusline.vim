
" TODO: Hoping to reduce some runtime resources, UNTESTED!
if &laststatus == 1
  finish
endif

" Custom modes.
  let g:currentmode = {
    \ 'n'  : 'Normal',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ 'no' : 'Normal·Operator Pending',
    \ '' : 'V·Blck',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replce',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Termnal'
  \}

" TODO: Add functions that utilizes a global/local dictionary
" for custom flags symbol/unicode. for a one function-rule-them-all thingy??
" TODO: Autoload this.


" TODO: Maybe I need to add this to autoload?

function! AleStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))

  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? '   ' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
  \)
endfunction

" Custom readonly flag.
function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

" Show current user.
function! ShowUser()
  let g:whoami = expand('$USER')
if winwidth(0) <= 126
  return ''
else
  return g:whoami
endfunction

function! FileEncoding()
if winwidth(0) <= 126
  return ''
else
  return &encoding
endfunction

function! FileFormat()
if winwidth(0) <= 126
  return ''
else
  return &fileformat == 'unix' ? ' ' : ' '
endif
endfunction

function! CurrentMode()
if winwidth(0) <= 126
  return toupper(mode())
else
  return g:currentmode[mode()]
endfunction

function! PasteMode()
if winwidth(0) <= 126
  return (&paste ? 'P' : '')
else
  return (&paste ? ' '.'PASTE ' : '')
endfunction

function! FileTypeSymbol()
  for [key, value] in items(g:icons)
    if index(value, WebDevIconsGetFileTypeSymbol()) >= 0
      if key == 'normal'
        exec 'highlight FileGlyph ctermfg=' . g:palette.base01 .
              \ ' ctermbg=237'
      elseif key == 'emphasize'
        exec 'highlight FileGlyph ctermfg=' . g:palette.base1 .
              \ ' ctermbg=237'
      else
        exec 'highlight FileGlyph ctermfg=' . g:palette[key] .
              \ ' ctermbg=237'
      endif
        return WebDevIconsGetFileTypeSymbol()
    endif
  endfor
endfunction

" TODO: Better hide the {item} instead of displaying
" a useless and ugly truncated string.
" That's a total eyesore!.

set statusline=
set statusline+=%8*%{PasteMode()}      " Paste mode flag
set statusline+=%9*
set statusline+=%4*
set statusline+=%1*%{CurrentMode()}          " Current Mode
set statusline+=%7*%{ShowUser()}                    " Current user
set statusline+=%2*
set statusline+=%3*
set statusline+=%#FileGlyph#\ %{FileTypeSymbol()}   " DevIcons
set statusline+=%5*\ %t\                                 " Filename (tail)
set statusline+=%5*%{ReadOnly()}                         " Readonly flag ()
set statusline+=%5*\ %M\                                 " Modified flag (+)
set statusline+=%6*
set statusline+=%0*\ %<\ %f\                             " File name (full)
set statusline+=%0*\ %h                                  " Help flag '[Help]'
set statusline+=%0*\ %W                                  " Preview flag '[PRV]'

set statusline+=%=

set statusline+=%0*\ %{strlen(&ft)\ ?\ &ft\ :\ 'noft'}\  " Filetype
set statusline+=%6*\ 
set statusline+=%5*%7.5{FileEncoding()}                  " UTF-8
set statusline+=%5*%5.4{FileFormat()}                    " Unix / Dos
set statusline+=%5*\ %{&et\ ?\ 'ET'\ :\ 'noet'}\         " Et / noet
set statusline+=%5*\ \ %{&shiftwidth}\                  " ShiftWidth
set statusline+=%3*
set statusline+=%2*
set statusline+=%1*\ %3p%%                               " Percentage
set statusline+=%7*\ ☰\ %1*%2l,%2v                       " Line / Column
set statusline+=%7*\ %L\                                 " Total lines
set statusline+=%4*
set statusline+=%9*
set statusline+=%8*%{AleStatus()}

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
hi User5 cterm=bold ctermfg=73 ctermbg=237
"second layer closing separator.
hi User6 ctermfg=237 ctermbg=235
" emphasis
hi User7 cterm=bold ctermfg=235 ctermbg=240
" Syntastic errors / warnings, Paste mode
hi User8 cterm=bold ctermfg=237 ctermbg=167
" error separator
hi User9 cterm=bold ctermfg=167 ctermbg=239
