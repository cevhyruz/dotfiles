"------------------------------------------------------------------------------
"  tmuxease.vim   -  easy vimmy tmux commandline for vim.
"  Maintainer:   John Fred fadrigalan <johnfred.fadriglan@hotmail.com>
"  License:      DWTFYWTPL
"------------------------------------------------------------------------------

" TMUX commandline vs Tease.vim
" 1). better command completion (support for custom arguments)

if empty($TMUX)
  finish
endif

function! s:getTmuxSocket()
  return split($TMUX, ',')[0]
endfunction

 noremap <script> <Plug>TmuxRunCommand  :call <SID>promptCommand(split(input('[tmux]: '), ''))<CR>
 if !hasmapto('<Plug>TypecorrAdd')
   nmap <Leader>t <Plug>TmuxRunCommand
 endif

function! s:promptCommand(...) abort
  let cmd = a:1
  call s:runCommand(join(cmd))
endfunction

function! s:runCommand(cmd) abort
  call system('tmux -S '.s:getTmuxSocket().' '.a:cmd)
endfunction

function s:setCommand(name, index, cmd)
  return system(s:getTmuxSocket()." set-option -s command-alias[".a:index."] ".a:name."=".shellescape(a:cmd))
endfunction

function s:hasAlias(index)
  let alias = s:runCommand('show-option -sv command-alias['.a:index.']')
  echom alias
endfunction

function s:setCommandAlias(name, index, cmd)
  call s:runCommand('set-option -s command-alias['.a:index.'] '.a:name.'='.shellescape(a:cmd))
endfunction

command! -nargs=1 -complete=customlist,EditFileComplete Test call <sid>hasAlias()

" customlist (returns vimLists)
function! EditFileComplete(A,L,P)
  return split(globpath(&path, a:A), "\n")
endfunction

" custom completion (newline separated string)
fun ListUsers(A,L,P)
    return system("cut -d: -f1 /etc/passwd")
endfun
