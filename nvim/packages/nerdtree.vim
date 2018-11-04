"----------------------------------------------
" nerdtree.vim - tree explorer manager for vim |
"----------------------------------------------

nnoremap <silent> <C-n> :NERDTreeToggle<CR>

let NERDTreeMapActivateNode='<space>'    " Toggle directory or open files.
let NERDTreeCascadeSingleChildDir=1      " Collapse dirs with only one file.
let NERDTreeQuitOnOpen = 1               " Close Nerdtree after opening a file.
let NERDTreeMinimalUI=1                  " Hide help and updir in UI.
let NERDTreeShowHidden=1                 " Show hidden files / (.)files.
let g:NERDTreeDirArrowExpandable = '❯'   " Set close arrow in dirs.
let g:NERDTreeDirArrowCollapsible = '◿'  " Set open arros in dirs.

" Directory color same as in bash.
hi NERDTreeDir cterm=bold ctermfg=73
hi NERDTreeCWD cterm=bold
hi! NERDTreeOpenable cterm=bold ctermfg=245
hi! NERDTreeClosable cterm=bold ctermfg=243
hi! NerdIgnored ctermfg=30
" let NERDTreeShowLineNumbers=1
" Do not show these files.
let NERDTreeIgnore=[
  \ '\.git$',
  \ '\~$'
  \ ]

" TODO: change /home/devs to use expanded value of $HOME variable.
augroup Hide$HOME
  autocmd! FileType nerdtree
  autocmd FileType nerdtree
    \ setlocal conceallevel=3
    \ | syntax match NERDTreeHideCWD #^[</]home[/]devs[/]# conceal
    \ | setlocal concealcursor=n
augroup end

function! GitDimIgnoredFiles()
  let gitcmd = 'git -c color.status=false status --short --ignored'
  if exists('b:NERDTree')
      let root = b:NERDTree.root.path.str()
  else
      let root = './'
  endif
  let files = split(system(gitcmd.' '.root), '\n')

  call GitFindIgnoredFiles(files)
endfunction

function! GitFindIgnoredFiles(files)
  for file in a:files
    let prefix = file[0:1]
    if prefix == '!!'
      let ignored = split(file[3:], '/')[-1]
      exec 'syntax match NerdIgnored ' .
        \ '#\<'.escape(ignored, '~').'\(\.\)\@!\># containedin=NERDTreeFile'
        echo '#\<'.escape(ignored, '~').'\(\.\)\@!\># containedin=NERDTreeFile'
        echo ignored
    endif

      exec 'syntax match NERDTreeDirSlash ' . '#/$#' .
            \ ' containedin=NERDTreeDir conceal contained'
  endfor
endfunction

autocmd FileType nerdtree :call GitDimIgnoredFiles()

"augroup HideNerdTreeDirSlashes
"  autocmd! FileType nerdtree
"  autocmd FileType nerdtree
"    \ syntax match NERDTreeDirSlash #/$#
"    \ containedin=NERDTreeDir conceal contained
"augroup END

augroup CloseWhenNoBuffer
  autocmd! FileType nerdtree
  autocmd BufEnter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    \| q
    \| endif
augroup END

function! PrettyFile(filename, cterm, bg, fg)
  execute 'autocmd FileType nerdtree highlight ' .
    \ a:filename .
    \ ' cterm='. a:cterm .
    \ ' ctermfg='. a:bg .
    \ ' ctermfg='. a:fg

  execute 'autocmd FileType nerdtree syntax match ' .
    \ a:filename . ' #^\s\+.*'. a:filename .'$#'

endfunction

let g:haha = glob("_localrc/*")

call PrettyFile('gitignore', 'italic', 'none', 'green')
