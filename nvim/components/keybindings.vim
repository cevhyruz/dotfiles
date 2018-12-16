
let mapleader = ","          " Leader key.

" Edit vimrc.
  nnoremap <silent> <leader>e :edit $VIM/sysinit.vim<cr>

" Reload vim config file
  nnoremap <silent> <leader>r
 \ :call functions#ReloadFile()<cr>

"------------------------------------
"             Searching              |
"------------------------------------

" Toggle search highlights.
  nnoremap <expr><silent> <space>
  \ (&hls == 0 ? ':set hls' : ':set nohls')."<cr>"

" Search for matching phrase under the cursor.
  nnoremap 8 *

" Search for files in fzf.
  nnoremap <silent> <C-n> :Files<CR>

"------------------------------------
"           File Editing             |
"------------------------------------
" Write to file.
  nnoremap ;w :w<cr>

" Insert Newline.
  nnoremap mm o<esc>

" Move a whole line. " Warning: shadows K (manpage lookup)
  nnoremap J mz:m+<cr>`z
  nnoremap K mz:m-2<cr>`z
  vnoremap J :m'>+<cr>`<my`>mzgv`yo`z
  vnoremap K :m'<-2<cr>`>my`<mzgv`yo`z

" Toggle Paste mode.
  nnoremap <silent> <leader>v :set invpaste<cr>

"------------------------------------
"            Navigation              |
"------------------------------------

" Return/Enter key (redraw).
  cnoremap jj <C-l><cr>

" Escape key.
  inoremap kj <esc>
  cnoremap kj <C-c><esc>
  vnoremap kj <esc>

" Much faster scrolling (increments by 3).
  nnoremap <C-e> 3<C-e>
  nnoremap <C-y> 3<c-y>

  " Split navigation.
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-h> <C-w>h
  nnoremap <C-l> <C-w>l

" Split Arrangement.
  nnoremap <M-f> <C-w>J
  nnoremap <M-d> <C-w>K
  nnoremap <M-s> <C-w>H
  nnoremap <M-g> <C-w>L

"------------------------------------
"           Miscellaneous            |
"------------------------------------

" Run the last command
  nnoremap <leader><space> :<up><cr>

" Jump to command bar.
  nnoremap ; :

" I dont think I need `;` in Command Mode.
  cnoremap ; :

" Run `git loglive` in terminal buffer.
  nnoremap vs :40vs term://git loglive<cr>

