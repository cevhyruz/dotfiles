scriptencoding utf-8

if exists('g:loaded_prettify')
  finish
endif
let g:loaded_prettify = 1

" Idea from zeorin's dotfiles
" https://github.com/zeorin/dotfiles/blob/e01cebf/.vimrc#L864-L900

let g:palette   = {
  \ 'base03'    : 8,
  \ 'base02'    : 0,
  \ 'base01'    : 240,
  \ 'base00'    : 11,
  \ 'base0'     : 12,
  \ 'base1'     : 6,
  \ 'base2'     : 7,
  \ 'base3'     : 15,
  \ 'shade'     : 0,
  \ 'yellow'    : 3,
  \ 'orange'    : 130,
  \ 'red'       : 1,
  \ 'magenta'   : 5,
  \ 'violet'    : 13,
  \ 'blue'      : 4,
  \ 'cyan'      : 6,
  \ 'green'     : 2
\}
augroup hide_project_root

  autocmd!
  autocmd! FileType nerdtree syntax match NERDTreeHideCWD /\/\c[a-z]*/ containedin=NERDTreeCWD conceal
" augroup efor r in {200..255..5}; do fb=4;g=1;b=1;printf '\e[0;%s8;2;%s;%s;%sm   ' "$fb" "$r" "$g" "$b"; done; echond

augroup hide_nerdtree_dir_slash
  autocmd!
  autocmd! FileType nerdtree syntax match NERDTreeDirSlash /\/$/ containedin=NERDTreeDir conceal
augroup END

augroup dim_vcs_ignored_files
  autocmd!
  autocmd FileType nerdtree :call GitDimIgnoredFiles()
augroup END

function! s:prettify_glyphs(config)
    for color in keys(a:config)
      if color is# 'normal'
        execute 'autocmd FileType nerdtree highlight devicons_'.color.
            \' cterm=bold ctermbg=none ctermfg='.g:palette.base01
      elseif color is# 'emphasize'
        execute 'autocmd FileType nerdtree highlight devicons_'.color.
            \' cterm=bold ctermbg=none ctermfg='.g:palette.base1
      else
        execute 'autocmd FileType nerdtree highlight devicons_'.color.
            \' cterm=bold ctermbg=none ctermfg='.g:palette[color]
      endif
      execute 'autocmd FileType nerdtree syntax match devicons_'.color.
        \ ' /\v'.join(a:config[color], '|').'/ containedin=ALL'
    endfor
endfunction

function! s:prettify_extension(filenames)
  for file in keys(a:filenames)
    " there must be a better way to increment index.
    execute 'autocmd FileType nerdtree hi '.file.' cterm='.a:filenames[file][0].
      \ ' ctermbg='a:filenames[file][1].' ctermfg='.a:filenames[file][2]
    execute 'autocmd FileType nerdtree syntax match '.file.' /^\s\+.*'.file.'$/'
  endfor
endfunction

function! s:nerd_overlap()
  " NERDTreeWinSize 35 (default: 31)
endfunction

call s:prettify_extension(get(g:, 'prettify_extension', {
\ 'gitignore': ['bold', 'none', '23'],
\ 'md':        ['none', 'none', '23'],
\ 'sh':        ['none', 'none', '23'],
\}))

" TODO: make this theme-customizable
call s:prettify_glyphs(get(g:, 'prettify_glyphs', {
  \ 'emphasize': [''],
  \ 'normal':    ['', '', '', ''],
  \ 'green':     ['', ''  ],
  \ 'blue':      ['', '', ''  ],
  \ 'yellow':    ['', '', '', '' ],
  \ 'magenta':   ['', '' ],
  \ 'orange':    ['', ''  ],
  \ 'red':       [''  ],
  \ 'violet':    [''  ],
  \ 'cyan':      ['', '', '', '']
\}))

function! GitDimIgnoredFiles()
    let gitcmd = 'git status --ignored --porcelain'
    if exists('b:NERDTree')
      let root = b:NERDTree.root.path.str()
    else
      let root = './'
    endif
    let files = split(system(gitcmd.' '.root), '\n')
    return GitFindIgnoredFiles(files)
endfunction

function! GitFindIgnoredFiles(files)
  for file in a:files
    let pre = file[0:1]
    if pre ==? '!!'
      let ignored = split(file[3:], '/')[-1]
      exec 'syn match Comment /\<'.ignored.'\(\.\)\@!\>/ containedin=ALL'
    endif
  endfor
endfunction
