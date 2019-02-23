
if empty($TMUX)
  call g:Message.warn('no active tmux session')
  finish
endi

let s:tmux = {}
let Tmux = s:tmux

function! s:tmux.runCommand(cmd)
  return system('tmux -S '.s:getSocket().' '.a:cmd)
endfunction

function! s:getSocket()
  return split($TMUX, ',')[0]
endfunction
