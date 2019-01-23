nnoremap <silent> <C-n> :NERDTreeToggle<CR>

let NERDTreeMapActivateNode='<space>'
let NERDTreeCascadeSingleChildDir=1
let NERDTreeQuitOnOpen = 0
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let NERDTreeIgnore=[
  \ '\.git$',
  \ '\~$'
  \ ]

function! PrettyNerdTree(config)
  let colors = keys(a:config)
  augroup devicons_colors
    autocmd!
    for color in colors
      if color == 'normal'
        exec 'autocmd FileType nerdtree' .
          \ 'highlight devicons_' . color .
          \ ' cterm=none ctermfg=' . g:palette.base01
      elseif color == 'emphasize'
        exec 'autocmd FileType nerdtree' .
          \ 'highlight devicons_' . color .
          \ ' cterm=none ctermfg=' . g:palette.base1
      else
        exec 'autocmd FileType nerdtree highlight devicons_' . color .
          \ ' cterm=none ctermfg='. g:palette[color]
      endif
      exec 'autocmd FileType nerdtree syntax match devicons_' . color .
        \ ' /\v' . join(a:config[color], '|') . '/ containedin=ALL'
    endfor
  augroup END
endfunction

function! PrettyFile(filename, cterm, bg, fg)
  execute 'autocmd FileType nerdtree highlight ' .
    \ a:filename .
    \ ' cterm='. a:cterm .
    \ ' ctermfg='. a:bg .
    \ ' ctermfg='. a:fg
  execute 'autocmd FileType nerdtree syntax match ' .
    \ a:filename . ' #^\s\+.*'. a:filename .'$#'
endfunction

function! GitDimIgnoredFiles()
    let gitcmd = 'git -c color.status=false status -s --ignored'
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
        let pre = file[0:1]
        if pre == '!!'
            let ignored = split(file[3:], '/')[-1]
            exec 'syn match Comment #\<'.escape(ignored, '~').'\(\.\)\@!\># containedin=NERDTreeFile'
        endif
    endfor
endfunction

" TODO: change /home/devs to use expanded value of $HOME variable.
augroup Hide$HOME
  autocmd! FileType nerdtree
  autocmd FileType nerdtree
    \ setlocal conceallevel=3
    \ | syntax match NERDTreeHideCWD #^[</]home[/]devs[/]# conceal
    \ | setlocal concealcursor=n
augroup end

augroup hide_nerdtree_dir_slash
  autocmd!
  autocmd! FileType nerdtree syntax match NERDTreeDirSlash
    \ #/$# containedin=ALL conceal
augroup END

augroup CloseWhenNoBuffer
  autocmd! FileType nerdtree
  autocmd BufEnter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    \| q
    \| endif
augroup END

augroup hide_nerd_signcolumn
  autocmd! FileType nerdtree
  autocmd FileType nerdtree setlocal signcolumn=no
augroup END

call PrettyFile('gitignore', 'italic', 'none', 'green')
call PrettyNerdTree(g:icons)
autocmd FileType nerdtree :call GitDimIgnoredFiles()
