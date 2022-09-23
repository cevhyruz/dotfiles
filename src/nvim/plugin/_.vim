" ------------------------------------------------------------------------------
" File:       plugin/_.vim
" Descripton: library and helper function to my vimrc.
" Author:     John Fred Fadrigalan
" License:    DWTFYWTPL
"------------------------------------------------------------------------------

let g:_ = {}
let s:_ = g:_

" message
let s:_.message = {}

function s:_.message.error(msg)
  echohl ErrorMsg
    echo a:msg
  echohl None
endfunction

function s:_.message.ok(msg)
  echohl Normal
    echo a:msg
  echohl None
endfunction

function s:_.message.warn(msg)
  echohl WarningMsg
    echo a:msg
  echohl None
endfunction

" term
let s:_.term = {}

function! s:_.term.run(command)
  function! s:_.term.on_exit(id, code, event)
    bdelete!
  endfunction

  execute 'botright 15new'
  call termopen(a:command, s:_.term)
  setlocal nospell bufhidden=wipe nobuflisted nonumber nornu
  setfiletype term_window
  startinsert
endfunction

function s:_.term.cmd(bang, ...) abort
  return ''
endfunction

augroup term_window_hide_statusline
  autocmd!
  autocmd FileType term_window setlocal foldcolumn=0 laststatus=0 noshowmode noruler signcolumn=no norelativenumber
    \| autocmd BufLeave <buffer> setlocal laststatus=2 showmode
augroup END

augroup testigo
  autocmd!
  autocmd FileType term_window setlocal foldcolumn=0 laststatus=0 noshowmode noruler signcolumn=no norelativenumber
    \| autocmd BufLeave <buffer> setlocal laststatus=2 showmode
augroup END

execute 'command! -nargs=1 Open    call s:_.term.run(<q-args>)'
