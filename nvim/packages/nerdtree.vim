"----------------------------------------------
" nerdtree.vim - tree explorer manager for vim |
"----------------------------------------------

" Keybindings
" ------------
" Should I just left it here? or add to the keybindings.vim component?
nnoremap <silent> <C-n> :NERDTreeToggle<CR>

" XXX: if disabled, when hitting <C-o> you would endup to nerdtree buffer.
let NERDTreeCascadeSingleChildDir=1     " Collapse dirs with only one file.
let NERDTreeQuitOnOpen = 1               " Close Nerdtree after opening a file.
let NERDTreeMinimalUI=1                  " Hide help and updir in UI.
let NERDTreeShowHidden=1                 " Show hidden files / (.)files.
let NERDTreeMapActivateNode='<space>'    " Toggle directory or open files.
let g:NERDTreeDirArrowExpandable = ' '   " Hide the close arrow dirs.
"
let g:NERDTreeDirArrowCollapsible = '◿'  " Hide the open arrow in dirs.
"◿

" Directory color same as in bash.
hi NERDTreeDir cterm=bold ctermfg=73
hi NERDTreeCWD cterm=bold

" let NERDTreeShowLineNumbers=1
" Do not show these files.
let NERDTreeIgnore=[
  \ '\.git$',
  \ '\~$'
  \ ]

" Hide pathline at the first line of NERDTREE.
" https://github.com/scrooloose/nerdtree/issues/806
augroup nerdtreehidecwd
  autocmd!
  autocmd FileType nerdtree
    \ setlocal conceallevel=3
    \ | syntax match NERDTreeHideCWD #^[</]home[/]devs[/]# conceal
    \ | setlocal concealcursor=n
augroup end

" Hide slashes after each directory node.
" https://github.com/scrooloose/nerdtree/issues/807
augroup nerdtreehidedirslashes
  autocmd!
  autocmd FileType nerdtree
        \ syntax match NERDTreeDirSlash #/$#
        \ containedin=NERDTreeDir conceal contained
augroup end

" Close neovim if the only buffer left is NERDTree.
augroup closewhennobuffer
autocmd bufenter *
  \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
  \   | q |
  \ endif
augroup end