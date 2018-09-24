" Reload vim if the current opened file is a vimscript
" otherwise just reload the file normally.
function! functions#ReloadFile()
  echohl MoreMsg
  if expand('%:e') == "vim"
    " TODO: Add exception incase sourcing fails.
    source $VIM/sysinit.vim
    echo " vim reloaded... "
  else
    edit %
    echo " current file reloaded... "
  endif
endfunction