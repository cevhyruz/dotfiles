"----------------------------------------------
" nerdtree.vim - tree explorer manager for vim |
"----------------------------------------------

" Keybindings
" ------------
" Should I just left it here? or add to the keybindings.vim component?
nnoremap <C-n> :NERDTreeToggle<CR>

" XXX: if disabled, when hitting <C-o> you would endup to nerdtree buffer.
let NERDTreeCascadeSingleChildDir=1     " Collapse dirs with only one file.
let NERDTreeQuitOnOpen = 1               " Close Nerdtree after opening a file.
let NERDTreeMinimalUI=1                  " Hide help and updir in UI.
let NERDTreeShowHidden=1                 " Show hidden files / (.)files.
let NERDTreeMapActivateNode='<space>'    " Toggle directory or open files.
let g:NERDTreeDirArrowExpandable = ' '   " Hide the close arrow dirs.
let g:NERDTreeDirArrowCollapsible = ' '  " Hide the open arrow in dirs.
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
  autocmd FileType nerdtree setlocal conceallevel=3
    \ | syntax match NERDTreeHideCWD #^[</].*$# conceal
    \ | setlocal concealcursor=n
augroup end

" Hide slashes after each directory node.
" https://github.com/scrooloose/nerdtree/issues/807
augroup nerdtreehidedirslashes
  autocmd!
  autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# 
        \ containedin=NERDTreeDir conceal contained
augroup end

" Always open NERDTree when no files were specified.
augroup nerdtreeopenwhenempty
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter *
    \ if argc() == 0 && !exists("s:std_in")
    \   | NERDTree |
    \ endif
augroup end

" Close neovim if the only buffer left is NERDTree.
autocmd bufenter *
  \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
  \   | q |
  \ endif