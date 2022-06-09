" vi:fdm=marker
"
"  /$$   /$$ /$$ /$$$$$$/$$$$  /$$$$$$  /$$$$$$$
"  | $$ /$$/| $$| $$_  $$_  $$/$$__  $$/$$_____/
"   \  $$$/ | $$| $$ | $$ | $$ $$  \__/ $$$$$$$$
"    \___/  |__/|__/ |__/ |__/__/      \_______/
"
let g:ycm_key_list_select_completion   = ['J', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['K', '<C-p>', '<Up>']

if has('nvim')
  call plug#begin(stdpath('data') . '/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
  Plug 'aliou/bats.vim',               { 'for': 'bats' }
  Plug 'yuki-ycino/fzf-preview.vim'
  Plug 'digitaltoad/vim-pug',          { 'for': 'pug' }
  Plug 'tomasiser/vim-code-dark'
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree',           { 'on':  'NERDTreeToggle' }
  Plug 'preservim/nerdcommenter'
  Plug 'ryanoasis/vim-devicons'
  Plug 'ycm-core/YouCompleteMe',       { 'do': 'python3 install.py' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'mattn/emmet-vim'
  Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'
  Plug 'junegunn/fzf',                 { 'do': { -> fzf#install() } }
  Plug 'junegunn/vader.vim',           { 'on': 'Vader', 'for': 'vader' }
  Plug 'junegunn/fzf.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'Yggdroot/indentLine'
  Plug 'majutsushi/tagbar',            { 'on': 'TagbarToggle' }
  Plug 'godlygeek/tabular'
  Plug 'benmills/vimux'
  Plug 'easymotion/vim-easymotion'
  Plug 'blueyed/vim-diminactive'
  Plug 'itchyny/lightline.vim'
  " == [ Syntax highlighting ] ==
  Plug 'aliou/bats.vim'
  Plug 'digitaltoad/vim-pug'
  Plug 'yuezk/vim-js'
  " == [ Themes ] ==
  Plug 'tomasiser/vim-code-dark'
  " == [ Linters ] ==
  Plug 'dense-analysis/ale'
  " == [ Completion ] ==
  Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
  " == [ Workflow tools ] ==
  Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-fugitive'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'SirVer/ultisnips'
  Plug 'majutsushi/tagbar'
  Plug 'junegunn/vim-easy-align'
  Plug 'easymotion/vim-easymotion'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'junegunn/vader.vim'
call plug#end()

" section: fzf
"let g:fzf_layout = {'down': '~23%'}

" - Popup window (center of the screen)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

let g:fzf_action = {
\ 'ctrl-h': 'topleft vsplit',
\ 'ctrl-n': 'botright split',
\ 'ctrl-p': 'topleft split',
\ 'ctrl-l': 'botright vsplit',
\ 'alt-h':  'leftabove vsplit',
\ 'alt-j':  'belowright split',
\ 'alt-k':  'aboveleft split',
\ 'alt-l':  'rightbelow vsplit',
\ 'alt-t':  'tab split' }

scriptencoding utf8
colorscheme    codedark
syntax         on
filetype       plugin indent on

" SECTION: Options
" SECTION: Commands

if empty($TMUX)
  command! NavRight call vimrc#navigate('l')
  command! NavLeft  call vimrc#navigate('h')
  command! NavUp    call vimrc#navigate('k')
  command! NavDown  call vimrc#navigate('j')
  command! NavPrev  call vimrc#navigate('p')
else
  command! NavRight call vimrc#tmux_navigate('l')
  command! NavLeft  call vimrc#tmux_navigate('h')
  command! NavUp    call vimrc#tmux_navigate('k')
  command! NavDown  call vimrc#tmux_navigate('j')
  command! NavPrev  call vimrc#tmux_navigate('p')
endif

" SECTION: AutoCommands

" SECTION: Abbreviations


" SECTION: Mappings

let mapleader = ','

"nnoremap <silent> <leader>t :call vimrc#jumpto_prev_tab()<cr>

" Toggles
nnoremap <expr> <space>          (&hls   == 0 ? ":set hls"   : ":set nohls")."<cr>"
nnoremap <expr> <leader>s<space> (&spell == 0 ? ":set spell" : ":set nospell")."<cr>"

" Breakline.
nnoremap mm i<c-m><esc>

" Move line/s upward / downward
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
"inoremap kj <esc>
"xnoremap kj <esc>
"cnoremap kj <c-c>
"vnoremap kj <esc>

" wrapped-lines traversal
"nnoremap j gj
"nnoremap k gk

" skimming (increments by 2).
"nnoremap <c-e> 2<c-e>
"nnoremap <c-y> 2<c-y>

" commandline navigation
"cnoremap <c-h> <left>
"cnoremap <c-l> <right>

" additonal history navigation
" not recommended but too good to ignore.
" cnoremap kjK <up>

" command history navigation
"cnoremap J <down>
"cnoremap K <up>

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

" indent whole line
" nnoremap <silent> <tab> ml>>`l :delmarks l<cr>
" Save session
nnoremap <c-s> :mksession! /tmp/mysession.vim<cr>

" reload vimrc
nnoremap <silent><leader>r :call <SID>reload_vimrc() <cr>

if !exists('g:reload')
  function s:reload_vimrc()
    let g:reload=1
    let s:prettify_nerdtree = expand('~/.config/nvim/nerdtree_plugin/prettify.vim')
    let s:vimrc = expand($MYVIMRC)
    if filereadable(expand(s:vimrc))
      execute ':source' s:vimrc
      call webdevicons#hardRefresh()
      execute ':source' s:prettify_nerdtree
      echom '[vimrc] config reloaded..'
    endif
  endfunction
endif

function! s:syn_stack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" SECTION: localrc

let s:local_vimrc = expand('~/Projects/dotfiles/localrc/local.nvimrc')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif
