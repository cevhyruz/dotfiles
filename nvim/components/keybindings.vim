let mapleader = ","          " Leader key.

" TODO: [temporary] - Add this to the colorscheme file.
hi CursorLine cterm=none ctermbg=235
hi LineNr cterm=none ctermbg=234 ctermfg=239
hi CursorLineNR ctermfg=245
hi Comment ctermfg=red
hi ColorColumn ctermbg=235
hi SignColumn cterm=none ctermbg=235 ctermfg=red
hi Normal ctermbg=234


"sign define piet text=!! texthl=SignColumn
"exe ":sign place 2 line=23 name=piet file=" . expand("%:p")

" Refresh current file
  nnoremap <silent> <leader>r
         \ :e<cr>:redraw<cr>:echo "current file loaded.."<cr>

" Open vim config file
  nnoremap <silent> <leader>e
         \ :e $VIM/sysinit.vim<cr>

" Reload vim config file
  nnoremap <silent> ;r
         \ :call functions#ReloadFile()<cr>
" Add marks.
  nnoremap <silent> m :call components#keybindings#GetNChar()<cr>

" Vim split navigation.
  nnoremap <C-j> <C-W>j
  nnoremap <C-k> <C-W>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

" Escape key
  inoremap kj <esc>
  cnoremap kj <c-c><esc>
  vnoremap kj <esc>

" Delete buffer
  nnoremap ;; :bd<cr>

" Return key
"  inoremap mm <cr>
  cnoremap jj <cr>
"  nnoremap mm o<esc>

" Map command
  nnoremap ; :

" List buffers
  nnoremap ;ls  :ls<cr>

" Visual-block mode
  nnoremap vv V

" Write file.
  nnoremap <leader>w :w<cr> 

" Should be macros
nnoremap ysiw :silent! normal bi"<esc>ea"<esc>