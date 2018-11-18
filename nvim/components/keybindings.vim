
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

" Move a whole line.
  nnoremap J mz:m+<cr>`z
  nnoremap K mz:m-2<cr>`z
  vnoremap J :m'>+<cr>`<my`>mzgv`yo`z
  vnoremap K :m'<-2<cr>`>my`<mzgv`yo`z

" Append text at the end of the line (shadows 'a').
  nnoremap a A

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

" Vim split navigation.
  nnoremap <C-j> <C-W>j
  nnoremap <C-k> <C-W>k
  nnoremap <C-h> <C-w>h
  nnoremap <C-l> <C-w>l

"------------------------------------
"           Miscellaneous            |
"------------------------------------

" Jump to command bar.
  nnoremap ; :

" I dont think I need `;` in Command Mode.
  cnoremap ; :

" Run `git loglive` in terminal buffer.
  nnoremap vs :40vs term://git loglive<cr>

