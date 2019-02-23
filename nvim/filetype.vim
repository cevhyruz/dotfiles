
" My filetype
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  autocmd! BufRead,BufNewFile *.tmux.conf          setfiletype tmux
augroup END
