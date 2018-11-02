"----------------------------------------------
" nerdtree.vim - tree explorer manager for vim |
"----------------------------------------------

nnoremap <silent> <C-n> :NERDTreeToggle<CR>

let NERDTreeMapActivateNode='<space>'    " Toggle directory or open files.
let NERDTreeCascadeSingleChildDir=1      " Collapse dirs with only one file.
let NERDTreeQuitOnOpen = 1               " Close Nerdtree after opening a file.
let NERDTreeMinimalUI=1                  " Hide help and updir in UI.
let NERDTreeShowHidden=1                 " Show hidden files / (.)files.
" let g:NERDTreeDirArrowExpandable = '❯'   " Set close arrow in dirs.
"let g:NERDTreeDirArrowCollapsible = '◿'  " Set open arros in dirs.

" Directory color same as in bash.
hi NERDTreeDir cterm=bold ctermfg=73
hi NERDTreeCWD cterm=bold
hi! NERDTreeOpenable cterm=bold ctermfg=245
hi! NERDTreeClosable cterm=bold ctermfg=243
" let NERDTreeShowLineNumbers=1
" Do not show these files.
let NERDTreeIgnore=[
  \ '\.git$',
  \ '\~$'
  \ ]

" TODO: change /home/devs to use expanded value of $HOME variable.
"augroup Hide$HOME
"  autocmd! FileType nerdtree
"  autocmd FileType nerdtree
"    \ setlocal conceallevel=3
"    \ | syntax match NERDTreeHideCWD #^[</]home[/]devs[/]# conceal
"    \ | setlocal concealcursor=n
"augroup end

augroup HideNerdTreeDirSlashes
  autocmd! FileType nerdtree
  autocmd FileType nerdtree
    \ syntax match NERDTreeDirSlash #/$#
    \ containedin=NERDTreeDir conceal contained
augroup END

augroup CloseWhenNoBuffer
  autocmd! FileType nerdtree
  autocmd bufenter *
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

" let g:gitfile = readfile("/home/devs/Projects/dotfiles/.gitignore")
" let c=0

" for entry in g:gitfile
"   let g:gitEntry = entry   " Get the file

    " Get all files in wildcard entry.
"     let g:pathToBeGlobbed = split(
 "      \ substitute(
  "         \ glob(
   "          \ g:gitEntry
    "       \),
     "    \ g:gitEntry,
      "   \ '',
"         \ 'g'
"       \)
"     \)

"   if matchstr(g:gitEntry, "*") != ''
"       for file in g:pathToBeGlobbed
"         echo file
"        exec 'autocmd FileType nerdtree highlight ' .
"              \ file .
"              \ ' ctermfg=red'
"
"        exec 'autocmd FileType nerdtree syntax match ' .
"              \ file . ' #^\s\+.*'. file .'$#'
"      "  echo 'haha'
"      endfor
"  else
"    " exec
"  endif
"
"  let c += 1
"  echo 'gitfile entry count '. c
"endfor

let g:gitcmd = 'git -c color.status=false status -s --ignored'

if exists('b:NERDTree')     " if NERDTree is opened.
  let g:root = b:NERDTree.root.path.str()
else
  let root = './'
endif

let g:files = split(
      \ system('git -c color.status=false status -s --ignored '.
        \ g:root
      \),
    \ '\n')
" -----------------------------------------------------

for file in g:files
  let prefix = file[0:1]
  if prefix == '!!'
    let ignored = split(file[3:], '/')[-1]
    echo ignored
  endif
endfor







let g:haha = glob("_localrc/*")

call PrettyFile('gitignore', 'italic,bold', 'none', 'green')
"call PrettyFile('vim', 'italic,bold', 'none', 'green')

"let g:test = {}
let g:test=split(glob("_localrc/*"))
