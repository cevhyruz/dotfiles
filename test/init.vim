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
  let g:which_vim = 'nvim'
  call plug#begin(stdpath('data') . '/plugged')
else
  let g:which_vim = 'vim'
  call plug#begin('~/.vim/plugged')
endif
  Plug 'aliou/bats.vim'
  Plug 'yuki-ycino/fzf-preview.vim'
  Plug 'digitaltoad/vim-pug'
  Plug 'tomasiser/vim-code-dark'
  Plug 'dense-analysis/ale'
  Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'preservim/nerdcommenter'
  Plug 'ryanoasis/vim-devicons'
  " TODO: Add catch here for YCM breaking change commit.
  " https://github.com/ycm-core/YouCompleteMe/issues/3764
  Plug 'ycm-core/YouCompleteMe'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'
  Plug 'jiangmiao/auto-pairs'
  Plug 'SirVer/ultisnips'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/vader.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'yuezk/vim-js'
  Plug 'airblade/vim-gitgutter'
  Plug 'Yggdroot/indentLine' " hides startup message
  Plug 'majutsushi/tagbar'
  Plug 'godlygeek/tabular'
  Plug 'benmills/vimux'
  Plug 'easymotion/vim-easymotion'
  Plug 'blueyed/vim-diminactive'
  Plug 'itchyny/lightline.vim'
  Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" section: fzf
let g:fzf_layout = {'down': '~23%'}

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
let g:fzf_colors = {
\ 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Error'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'Comment', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'Error', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] }

"# changes current selected highlight color
" \ 'bg':      ['bg', 'Normal'],

" FIXME: Please stop using autocommands for everything,
" specially for *Leave, *Enter events.
augroup hide_fzf_statusline
  autocmd!
  autocmd FileType fzf setlocal ls=0 noshowmode noruler nonu nornu fdc=0 scl=no
    \| autocmd BufLeave <buffer> set ls=2 showmode ruler
augroup END

augroup change_cursor_shape
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"'
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
augroup END

scriptencoding utf8
colorscheme    codedark
syntax         on
filetype       plugin indent on

" SECTION: Options

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

"augroup strip_whitespace
"  autocmd!
"  autocmd BufWrite,BufWritePre * call vimrc#strip_whitespaces()
"augroup END


augroup push_tab
  autocmd!
  autocmd TabLeave * let g:prev_tab = tabpagenr()
augroup END

augroup close_if_only_nerdtree
  autocmd!
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" SECTION: Abbreviations

" completions
cnoreabbrev <silent>f FZF<cr>

" SECTION: Mappings

let mapleader = ','

nnoremap <silent> <leader>t :call vimrc#jumpto_prev_tab()<cr>

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

" indent whole line
" nnoremap <silent> <tab> ml>>`l :delmarks l<cr>
" Save session
nnoremap <c-s> :mksession! /tmp/mysession.vim<cr>

" reload vimrc
nnoremap <silent><leader>r :call <SID>reload_vimrc() <cr>

function! s:reload_vimrc()
  let s:vimrc = expand($MYVIMRC)
  let s:prettify_nerdtree = expand('~/.config/nvim/nerdtree_plugin/prettify.vim')
  if filereadable(expand(s:vimrc))
    execute ':source' s:vimrc
    call webdevicons#hardRefresh()
    execute ':source' s:prettify_nerdtree
    echom '[vimrc] config reloaded..'
  endif
endfunction

" split navigation (tmux aware)
nnoremap <silent><c-l> :NavRight<cr>
nnoremap <silent><c-h> :NavLeft<cr>
nnoremap <silent><c-k> :NavUp<cr>
nnoremap <silent><c-j> :NavDown<cr>
nnoremap <silent><c-\> :NavPrev<cr>
" Show syntax highlighting groups for word under cursor
"
nnoremap <leader>3 :call <SID>syn_stack()<CR>
function! s:syn_stack()
  if !exists('*synstack')
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

let NERDTreeMapActivateNode       = '<space>'
let NERDTreeCascadeSingleChildDir = 1
let NERDTreeQuitOnOpen            = 1
let NERDTreeMinimalUI             = 1
let NERDTreeShowHidden            = 1
let NERDTreeDirArrowExpandable    = "\u00a0" " 
let NERDTreeDirArrowCollapsible   = "\u00a0" " 
let NERDTreeWinPos                = 'left'
let NERDTreeIgnore                = [ '\.git$', '\~$', 'node_modules' ]
let NERDTreeWinSize               = 35

" SECTION: localrc

let s:local_vimrc = expand('~/Projects/dotfiles/localrc/local.nvimrc')
if filereadable(s:local_vimrc)
  execute 'source' s:local_vimrc
endif

set cursorline
set colorcolumn=80

" SECTION: UltiSnips

" Location of the snippet files.
let g:UltiSnipsSnippetDirectories = [
  \ '/home/devs/Projects/dotfiles/nvim/UltiSnips',
  \ 'UltiSnips']

" let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsEditSplit='vertical'        " Always open snip file in vsplit.

" This is actually the default.
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
" let g:UltiSnipsListSnippets = ""


" Plug: GitGutter

  let g:sign = ' ┃'                " Git Gutter Sign.
  let g:gitgutter_map_keys = 0     " Dont set mappings.

  let g:gitgutter_sign_added = g:sign
  let g:gitgutter_sign_modified = g:sign
  let g:gitgutter_sign_removed = g:sign
  let g:gitgutter_sign_removed_first_line = g:sign
  let g:gitgutter_sign_modified_removed = g:sign

  " [?] I remember this cause massive lag.
   augroup UpdateGitGutterOnSave
     autocmd! UpdateGitGutterOnSave
     autocmd BufWritePost * GitGutter
   augroup end

" SECTION: indentLine

nnoremap <leader>i<space> :IndentLinesToggle <cr>

let g:indentLine_char                 = '┆'
let g:indentLine_first_char           = '┆' "┃
let g:indentLine_color_term           = 240
"TODO: toggle this in dim_inactive_window
let g:indentLine_bgcolor_term         = 234
let g:indentLine_indentLevel          = 14
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileType             = ['vim', 'sh']
let g:indentLine_fileTypeExclude      = []
let g:indentLine_bufTypeExclude       = ['help', 'terminal']
let g:indentLine_bufNameExclude       = ['_.*', 'NERD_tree.*']

let g:lightline = {
      \ 'component': {
   \   'lineinfo': ' %3l:%-2v',
   \ },
   \ 'component_function': {
   \   'readonly': 'LightlineReadonly',
   \   'fugitive': 'LightlineFugitive'
   \ },
   \ 'separator': { 'left': '', 'right': '' },
   \ 'subseparator': { 'left': '', 'right': '' }
\ }

function! LightlineReadonly()
 return &readonly ? '' : ''
endfunction
function! LightlineFugitive()
 if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ''.branch : ''
 endif
return ''
endfunction
