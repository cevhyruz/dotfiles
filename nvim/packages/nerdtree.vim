"----------------------------------------------
" nerdtree.vim - tree explorer manager for vim |
"----------------------------------------------

set number
" Keybindings
" ------------
nnoremap <C-n> :NERDTreeToggle<CR>
let NERDTreeMapActivateNode='<space>'   " Toggle directory or open files.
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
" XXX: if disabled, when hitting ctrl-o you would endup
" to last NERDTree buffer instead of last file buffer
" which is very annoying!
let NERDTreeQuitOnOpen = 1           " Close Nerdtree after opening a file.

let NERDTreeMinimalUI=1               " Hide help and updir in UI.
let NERDTreeShowHidden=1              " Show hidden files / (.)files.

" Don't display these files.
let NERDTreeIgnore=[
   \ '\.git$',  
   \ '\~$'
   \ ]

" Open NERDtree when neovim starts up and no files were specified.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter *
  \ if argc() == 0 && !exists("s:std_in")
  \   | NERDTree |
  \ endif
  
" Close neovim if the only buffer left is NERDTree.
autocmd bufenter * 
  \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
  \   | q |
  \ endif

" TODO: Add this to the main colorscheme file
" Custom colorschemes
hi NERDTreeDir cterm=bold ctermfg=73
hi NERDTreeOpenable cterm=bold ctermfg=243
hi NERDTreeCWD cterm=bold ctermbg=236 ctermfg=250
hi NERDTreeClosable cterm=bold ctermfg=166
hi NerdtreeDirSlash ctermfg=234
hi NERDTreeFile cterm=bold ctermfg=243