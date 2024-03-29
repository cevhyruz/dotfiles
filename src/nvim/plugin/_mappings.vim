" SECTION: Mappings

let mapleader = ','

" completions
cnoreabbrev <silent>f FZF<cr>

" Show syntax highlighting groups for word under cursor
nnoremap <leader>3 :call vimrc#syn_stack()<CR>

" split navigation (tmux aware)
nnoremap <silent><c-l> :call vimrc#navigate('l')<CR>
nnoremap <silent><c-h> :call vimrc#navigate('h')<CR>
nnoremap <silent><c-k> :call vimrc#navigate('k')<CR>
nnoremap <silent><c-j> :call vimrc#navigate('j')<CR>
nnoremap <silent><c-\> :call vimrc#navigate('p')<CR>

nnoremap <silent> <leader>t :call vimrc#jumpto_prev_tab()<cr>

" Toggles
nnoremap <expr> <space>          (&hls   == 0 ? ":set hls"   : ":set nohls")."<cr>"
nnoremap <expr> <leader>s<space> (&spell == 0 ? ":set spell" : ":set nospell")."<cr>"

" Move line/s upward / downward (alt+j/k)
nnoremap <m-j> mz:m+<cr>`z
vnoremap <m-j> :m'>+<cr>`<my`>mzgv`yo`z
nnoremap <m-k> mz:m-2<cr>`z
vnoremap <m-k> :m'<-2<cr>`>my`<mzgv`yo`z

" preserve state upon running :only
nnoremap <c-w>o :mksession! /tmp/stateB4only.vim <bar> wincmd o<cr>

" revert to previous state after running '<c-w>o'
nnoremap <c-w>u :source /tmp/stateB4only.vim<cr>

" visual line.
nnoremap vv V

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

" paste register" to cmdline.
cnoremap <F9> <C-R>"

" reload vimrc
nnoremap <silent><leader>r :call vimrc#reload_vimrc() <cr>
