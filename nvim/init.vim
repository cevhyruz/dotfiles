scriptencoding utf8
"             /$$
"            |__/
"  /$$    /$$ /$$ /$$$$$$/$$$$   /$$$$$$   /$$$$$$$
" |  $$  /$$/| $$| $$_  $$_  $$ /$$__  $$ /$$_____/
"  \  $$/$$/ | $$| $$ \ $$ \ $$| $$  \__/| $$
"   \  $$$/  | $$| $$ | $$ | $$| $$      | $$$$$$$$
"    \___/   |__/|__/ |__/ |__/|__/       \_______/
"                           of John Fred Fadrigalan

colorscheme gruvbox
syntax      on
filetype    plugin indent on

" SECTION: Options {{{1

set history=10000
set clipboard+=unnamedplus
set updatetime=100
set undofile
set foldcolumn=1
set scrolloff=10
set textwidth=120
set number relativenumber
set spell spelllang=en_us
set foldtext=vimrc#foldtext('.')
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

source ~/Projects/cloned-repo/fzf/plugin/fzf.vim

" SECTION: Commands {{{1

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

" SECTION: AutoCommands {{{1

augroup strip_whitespace
  autocmd!
  autocmd BufWrite,BufWritePre * call vimrc#strip_whitespaces()
augroup END

augroup push_tab
  autocmd!
  autocmd TabLeave * let g:prev_tab = tabpagenr()
augroup END

augroup close_if_only_nerdtree
  autocmd!
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" SECTION: Abbreviations {{{1

" completions
cnoreabbrev <silent>f FZF<cr>

" SECTION: localrc {{{1

let s:local_vimrc = expand('~/Projects/dotfiles/_localrc/local.nvimrc')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
else
  echo 'no local_vimrc'
endif
