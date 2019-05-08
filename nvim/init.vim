call plug#begin()
call plug#end()

set background=dark
colorscheme tpope
" syntax on
" filetype plugin indent on
set history=10000
set clipboard=unnamedplus
set updatetime=100
set undofile
set foldcolumn=1
set scrolloff=10
set nomodeline
set textwidth=120
set number relativenumber
set spell spelllang=en_us
set foldtext=dotvim#myFoldText()
set showbreak=↳
set listchars=trail:~,tab:\▸\ ,extends:❯,precedes:❮,nbsp:␣
set guicursor=cr-c-ci:hor20,i-ve:ver25,r:hor20,o:hor50,n-v-sm:block,a:Cursor/lCursor
set list
set splitbelow
set splitright
set noshowmode
set nowrap
set ignorecase
set signcolumn=yes
set smartcase
set expandtab
set tabstop=2
set softtabstop=2
set smartindent
set cindent
set shiftwidth=2
set mouse=a
set backupdir=/tmp//,.
set directory=/tmp//,.
set undodir=/tmp//,.

" generate helptags
" call execute('helptags ALL', 'silent')

" ------------------------------------------------------------------
"  [?] Mapping
" ------------------------------------------------------------------
let mapleader = ","
" wrapped-lines traversal
nnoremap j gj
nnoremap k gk
" Toggles
nnoremap <expr> <space> (&hls == 0 ? ":set hls" : ":set nohls")."<cr>"
nnoremap <expr> <leader>s<space> (&spell == 0 ? ":set spell" : ":set nospell")."<cr>"
" Saving
nnoremap <silent> ;w :w<cr>
" Breakline.
nnoremap mm i<c-m><esc>
" Move line upward / downward
nnoremap J mz:m+<cr>`z
vnoremap J :m'>+<cr>`<my`>mzgv`yo`z
nnoremap K mz:m-2<cr>`z
vnoremap K :m'<-2<cr>`>my`<mzgv`yo`z
" kj | Escaping!
inoremap kj <esc>
xnoremap kj <esc>
cnoremap kj <c-c>
vnoremap kj <esc>
" Scrolling/skimming (increments by 3).
nnoremap <c-e> 2<c-e>
nnoremap <c-y> 2<c-y>
" commandline navigation.
cnoremap <c-h> <left>
cnoremap <c-l> <right>
" command history navigation
cnoremap J <down>
cnoremap K <up>
" Run the last entered command.
nnoremap <leader><space> :<up><cr>
" Run a command
nnoremap ; :
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
nnoremap <silent> <tab> ml>>`l :delmarks l<cr>
" Save session
nnoremap <c-s> :mksession! /tmp/mysession.vim<cr>


" [?] Plugin mapping
" nmap <leader>5 <Plug>(TriggerPrompt)

" [?] Navigation
" simplified version of christoomey's vim-tmux-navigator
" https://github.com/christoomey/vim-tmux-navigator

  nnoremap <silent><c-l> :NavRight<cr>
  nnoremap <silent><c-h> :NavLeft<cr>
  nnoremap <silent><c-k> :NavUp<cr>
  nnoremap <silent><c-j> :NavDown<cr>
  nnoremap <silent><c-\> :NavPrev<cr>

if empty($TMUX)
  command NavRight call vimrc#navigate('l')
  command NavLeft  call vimrc#navigate('h')
  command NavUp    call vimrc#navigate('k')
  command NavDown  call vimrc#navigate('j')
  command NavPrev  call vimrc#navigate('p')
else
  command NavRight call vimrc#tmuxNav('l')
  command NavLeft  call vimrc#tmuxNav('h')
  command NavUp    call vimrc#tmuxNav('k')
  command NavDown  call vimrc#tmuxNav('j')
  command NavPrev  call vimrc#tmuxNav('p')
endif

" [?] localrc
if filereadable("/home/devs/Projects/dotfiles/_localrc/local.nvimrc")
  source /home/devs/Projects/dotfiles/_localrc/local.nvimrc
endif
