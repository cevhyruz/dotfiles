let mapleader = ','

nnoremap <silent> <leader>t :call vimrc#jumpto_prev_tab()<cr>

" Toggles
nnoremap <expr> <space>          (&hls   == 0 ? ":set hls"   : ":set nohls")."<cr>"
nnoremap <expr> <leader>s<space> (&spell == 0 ? ":set spell" : ":set nospell")."<cr>"

" Breakline.
nnoremap mm i<c-m><esc>

" Move line upward / downward
nnoremap <m-j> mz:m+<cr>`z
vnoremap <m-j> :m'>+<cr>`<my`>mzgv`yo`z
nnoremap <m-k> mz:m-2<cr>`z
vnoremap <m-k> :m'<-2<cr>`>my`<mzgv`yo`z

" preserve state upon running :only
nnoremap <c-w>o :mksession! /tmp/stateB4only.vim <bar> wincmd o<cr>

" revert to previous state after running '<c-w>o'
nnoremap <c-w>u :source /tmp/stateB4only.vim<cr>



" additional accept-line
" not recommended to too good to ignore.
" cnoremap kjj <cr>

" kj | Escaping!
inoremap kj <esc>
xnoremap kj <esc>
cnoremap kj <c-c>
vnoremap kj <esc>

" wrapped-lines traversal
nnoremap j gj
nnoremap k gk

" skimming (increments by 2).
nnoremap <c-e> 2<c-e>
nnoremap <c-y> 2<c-y>

" commandline navigation
cnoremap <c-h> <left>
cnoremap <c-l> <right>

" additonal history navigation
" not recommended but too good to ignore.
" cnoremap kjK <up>

" command history navigation
cnoremap J <down>
cnoremap K <up>

" Run the last entered command.
nnoremap <leader><space> :<up><cr>

" Run a command
nnoremap ; :

" save buffer
nnoremap ;w :w<cr>

" Open command bar.
nnoremap ;<space> q:

" Mouse whell (one line)
noremap <ScrollWheelDown> 1<c-e>
noremap <ScrollWheelUp> 1<c-y>

" visual line.
nnoremap vv V

" paste register" to cmdline.
cnoremap <F9> <C-R>"

" indent whole line
" nnoremap <silent> <tab> ml>>`l :delmarks l<cr>
" Save session
nnoremap <c-s> :mksession! /tmp/mysession.vim<cr>

" reload vimrc
nnoremap <silent><leader>r :source $MYVIMRC <bar> echom 'reloaded'<cr>

" split navigation (tmux aware)
nnoremap <silent><c-l> :NavRight<cr>
nnoremap <silent><c-h> :NavLeft<cr>
nnoremap <silent><c-k> :NavUp<cr>
nnoremap <silent><c-j> :NavDown<cr>
nnoremap <silent><c-\> :NavPrev<cr>
" Show syntax highlighting groups for word under cursor
"
nnoremap <leader>3 :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
