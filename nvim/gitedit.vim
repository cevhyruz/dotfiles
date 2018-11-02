"-----------------------------------------------------------------------
"  gitedit.vim - minimal configuration file used for editing with git.  |
"-----------------------------------------------------------------------

" Disable unneeded global plugins {{{

  let loaded_matchparen    = 1
  let loaded_matchit       = 1
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  let loaded_gzip          = 1
  let g:loaded_zipPlugin   = 1
  let g:loaded_zip         = 1

" }}}

" Basic Settings {{{

  syntax enable                 " Enable syntax highlighting.

  set background=dark           " Disable dark texts on dark backgrounds.
  set number                    " Show linenumbers.
  set clipboard=unnamedplus     " Always use system clipboard.
  set noshowmode                " Hide mode display.
  set colorcolumn=50            " Git subject line character limit.
  set colorcolumn+=72           " Git commit body character limit.
  set shortmess+=F              " Don't display filename at commandbar.

" }}}

" Statusline {{{

" SOURCE: https://vi.stackexchange.com/questions/17704/how-to-remove-character-returned-by-system/17707#17707
function! GitUser()
  let s:name = substitute(
    \ system("git config --get user.name"), '\n', '', 'g')
  return s:name
endfunction

function! GitEmail()
  let s:email = substitute(
    \ system("git config --get user.email"), '\n', '', 'g')
  return substitute(s:email, '.com', '', 'g')
endfunction

function! GitOriginUrl()
  let s:origin = substitute(
    \ system("git config --get remote.origin.url"), '\n', '', 'g')
  return substitute(s:origin , 'git@github.com:', '','g')
endfunction

  set statusline+=%1*\ %{GitUser()}\ 
  set statusline+=%2*
  set statusline+=%3*
  set statusline+=%=
  set statusline+=%0*
  set statusline+=%0*\ %{GitOriginUrl()}
  set statusline+=%=
  set statusline+=%3*
  set statusline+=%2*
  set statusline+=%1*\ %{GitEmail()}\ 

hi! Statusline ctermfg=235 ctermbg=250
hi! User1 cterm=bold ctermbg=23 ctermfg=250
hi! User2 ctermfg=23 ctermbg=237
hi! User3 ctermfg=237 ctermbg=235

" }}}

" Enable basic keybindings.
  source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim

hi! ColorColumn ctermbg=235
hi! SignColumn ctermbg=234
hi! Comment ctermfg=242
hi! EndOfBuffer ctermfg=234
hi! gitcommitSelected cterm=bold ctermfg=106


" Move cursor to the last line.
autocmd BufRead * norm! Go
