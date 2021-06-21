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
let NERDTreeHijackNetrw           = 0

" hi  NERDTreeClosable cterm=bold ctermbg=none ctermfg=240
" hi  NERDTreeOpenable cterm=bold ctermbg=none ctermfg=237
" hi NERDTreeDir cterm=bold
