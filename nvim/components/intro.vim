
"https://vi.stackexchange.com/questions/627/how-can-i-change-vims-start-or-intro-screen#answer-715
function! WelcomeMessage()
  " Don't run if: we have commandline arguments, we don't have an empty
  " buffer, if we've not invoked as vim or gvim, or if we'e start in insert mode
  if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
    return
  endif
  enew | setlocal
    \ bufhidden=wipe
    \ buftype=nofile
    \ nobuflisted
    \ nocursorcolumn
    \ nocursorline
    \ colorcolumn=
    \ nospell
    \ nolist
    \ nonumber
    \ noswapfile
    \ norelativenumber
  "call append('$', "ttest")

  for line in split(system('nvim_intro'), '\n')
    call append('$', '  ' . l:line)
  endfor

  setlocal nomodifiable nomodified
  nnoremap <buffer><silent> e :enew<CR>
  nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
  nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
endfunction
