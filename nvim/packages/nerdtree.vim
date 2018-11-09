nnoremap <silent> <C-n> :NERDTreeToggle<CR>

let NERDTreeMapActivateNode='<space>'
let NERDTreeCascadeSingleChildDir=1
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

autocmd FileType nerdtree :call GitDimIgnoredFiles()

hi NERDTreeDir cterm=bold ctermfg=73
hi NERDTreeCWD cterm=bold
hi! NERDTreeOpenable cterm=bold ctermfg=245
hi! NERDTreeClosable cterm=bold ctermfg=243
hi! NerdIgnored ctermfg=30

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
    endif
      exec 'syntax match NERDTreeDirSlash ' . '#/$#' .
        \ ' containedin=ALL conceal contained'
  endfor
endfunction

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
