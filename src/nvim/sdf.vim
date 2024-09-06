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
  Plug 'junegunn/vim-easy-align'
  Plug 'airblade/vim-gitgutter'
  Plug 'Yggdroot/indentLine'
  Plug 'majutsushi/tagbar',            { 'on': 'TagbarToggle' }
  Plug 'godlygeek/tabular'
  Plug 'benmills/vimux'
  Plug 'easymotion/vim-easymotion'
  Plug 'blueyed/vim-diminactive'
  Plug 'itchyny/lightline.vim'
  Plug 'christoomey/vim-tmux-navigator'
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

echo "sdf.vim"

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
