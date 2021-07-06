scriptencoding utf8
colorscheme    codedark
syntax         on
filetype       plugin indent on

set cursorline
set colorcolumn=80

set history=10000
set clipboard+=unnamedplus
set updatetime=100
set undofile
set laststatus=2
set showtabline=2
set showcmd
set ttimeout
set ttimeoutlen=50

 "Enable true color 启用终端24位色
"if exists('+termguicolors')
  "let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  "let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  "set termguicolors
"endif

set noswapfile
set foldcolumn=1
set textwidth=120
set number relativenumber
set spelllang=en_us
set foldtext=vimrc#foldtext('-')
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
