
if exists('g:autoloaded_fzf') || &cp
  finish
endif
let g:autoloaded_fzf = 1

" ------------------------------------------------------------------
" Script
" ------------------------------------------------------------------
function! s:capture(cmd) abort
  try
    redir => l:out
    exe 'silent '.a:cmd
  finally
    redir END
  endtry
  return l:out
endfunction

function! fzf#scriptnames()
  return fzf#run({
  \ 'options': [ '--header', 'Order Scriptnames', '--ansi', '--reverse', '--preview', '{2}'],
  \ 'source': split(s:capture('scriptnames'), '\n'),
  \ 'sink': 'edit ${2}'
  \})
endfunction

" -------------------------------------------------------------------
" Gadd/reset
" -------------------------------------------------------------------
function! s:handler(line)
  let b:file = split(a:line, '')
  echom b:file[2]
  let l:status = system('git status --short '. b:file[2])[:1]
  if l:status ==# 'A ' || l:status ==# 'M '
    call system('git reset '.b:file[2])
  else
    call system('git add '.b:file[2])
  endif
endfunction

" TODO: Add support for truecolors, optimize and add filetype icons.
" Add gitconfig color.status detection.
" Add devicons folder icon for directories.
function! s:colorize(prefix)
  if a:prefix[0:1] == 'A '
    let l:prefix = "\e[0;32m  ".strcharpart(a:prefix, 0, 2).
    \ " \e[0m  ".WebDevIconsGetFileTypeSymbol(a:prefix).
    \ strcharpart(a:prefix, 2)
  elseif a:prefix[0:1] ==# 'M '
    let l:prefix = "\e[0;32m  ".strcharpart(a:prefix, 0, 2).
    \ " \e[0m  ".WebDevIconsGetFileTypeSymbol(a:prefix).
    \ strcharpart(a:prefix, 2)
  elseif a:prefix[0:1] ==# ' M'
    let l:prefix = "\e[0;33m  ".strcharpart(a:prefix, 0, 2).
    \ " \e[0m  ".WebDevIconsGetFileTypeSymbol(a:prefix).
    \ strcharpart(a:prefix, 2)
  else
    let l:prefix = "\e[0;31m  ".strcharpart(a:prefix, 0, 2).
    \ " \e[0m  ".WebDevIconsGetFileTypeSymbol(a:prefix).
    \ strcharpart(a:prefix, 2)
  endif
  return l:prefix
endfunction

function! fzf#git_add_reset()
  let g:git_files = split(system('git status --short'), '\n')
  call map(g:git_files, 's:colorize(v:val)')
  return fzf#run({
  \ 'options':[ '--header', 'Status Files', '--ansi', '--reverse', '--preview', 'git diff --color=always ${3}' ],
  \ 'sink': function('s:handler'),
  \ 'source': g:git_files
  \ })
endfunction
