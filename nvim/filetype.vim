" My filetype
if exists('did_load_filetypes')
  finish
endif

augroup filetype_detect
  autocmd!
  autocmd BufRead,BufNewFile *.tmux.conf          setfiletype tmux
  autocmd BufRead,BufNewFile *.vifm               setfiletype vifm
  autocmd BufRead,BufNewFile *.tmux               setfiletype tmux
augroup END
