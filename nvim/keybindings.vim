let mapleader = ","          " Leader key.

" Refresh current file
  nnoremap <silent> <leader>r :e<cr>:redraw<cr>:echo " current file loaded.."<cr>

" Open vim config file
  nnoremap <leader>e :e $MYVIMRC<cr> 

" Reload vim config file
  nnoremap <silent> ;r :so $MYVIMRC<cr>:redraw<cr>:echo " vim reloaded.. "<cr>

" Window navigation
  nnoremap <C-j> <C-W>j
  nnoremap <C-k> <C-W>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l

" Escape key
  inoremap kj <esc>
  cnoremap kj <c-c><esc>
  vnoremap kj <esc>

" Return key
  inoremap mm <cr>
  cnoremap mm <cr>

" Insert newline
  nnoremap mm o<esc>

" Map command
  nnoremap ; :
" List buffers
  nnoremap ;ls  :ls<cr>

" Visual-line mode
  nnoremap vv V

" Write file.
  nnoremap <leader>w :w<cr> 


" Should be "macros"
nnoremap ysiw :silent! normal bi"<esc>ea"<esc>