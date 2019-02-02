let mapleader = ","          " Leader key.

" Edit vimrc.
  nnoremap <silent> <leader>e :edit $VIM/sysinit.vim<cr>

" Reload vim config file
  nnoremap <silent> <leader>r :source $VIM/sysinit.vim<cr>

"------------------------------------
"             Searching              |
"------------------------------------

" Toggle search highlights.
  nnoremap <expr><silent> <space> (&hls == 0 ? ':set hls' : ':set nohls')."<cr>"

"------------------------------------
"           File Editing             |
"------------------------------------
" Write to file.
  nnoremap ;w :w<cr>

" Insert Newline.
  nnoremap mm o<esc>

" Move current line upward / downward.
  nnoremap J mz:m+<cr>`z
  nnoremap K mz:m-2<cr>`z

" Move block of lines upward / downward.
  vnoremap J :m'>+<cr>`<my`>mzgv`yo`z
  vnoremap K :m'<-2<cr>`>my`<mzgv`yo`z

"------------------------------------
"            Navigation              |
"------------------------------------

" Return/Enter key (redraw).
  cnoremap jj <C-l><cr>

" Escape key.
  inoremap kj <esc>
  cnoremap kj <C-c><esc>
  vnoremap kj <esc>

" Faster vertical scrolling (increments by 3).
  nnoremap <C-e> 2<C-e>
  nnoremap <C-y> 2<c-y>

" Faster horizontal scrolling (incremnents by 20)
  nnoremap zl 20zl
  nnoremap zh 20zh

" Split Arrangement.
  nnoremap <M-f> <C-w>J
  nnoremap <M-d> <C-w>K
  nnoremap <M-s> <C-w>H
  nnoremap <M-g> <C-w>L

"------------------------------------
"           Miscellaneous            |
"------------------------------------

" Run the last entered command.
  nnoremap <leader><space> :<up><cr>

" Jump to command bar.
  nnoremap ; :

" Open command bar.
  nnoremap ;<space> q:

" Quit.
  nnoremap ;q :q<cr>

" I think I don't need `;` in Command Mode.
  cnoremap ; :
