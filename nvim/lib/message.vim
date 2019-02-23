
let s:message = {}
let Message = s:message

function! s:message.warn(msg)
  echohl WarningMsg
  redraw | echom a:msg
  echohl Normal
endfunction

function! s:message.error(msg)
  echohl ErrorMsg
  redraw | echom a:msg
  echohl Normal
endfunction
