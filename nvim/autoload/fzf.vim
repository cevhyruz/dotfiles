
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
  \ 'options': [ '--header', 'Order Scriptnames', '--ansi', '--reverse', '--preview', '{}'],
  \ 'source': split(s:capture('scriptnames'), '\n')
  \})
endfunction
