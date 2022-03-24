" push last tab number, to be accessed by 'vimrc#jumpto_prev_tab()'
augroup push_tab
  autocmd!
  autocmd TabLeave * let g:prev_tab = tabpagenr()
augroup END

augroup close_if_only_nerdtree
  autocmd!
  autocmd BufEnter *
    \ if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) |
    \ q |
    \ endif
augroup END

augroup change_cursor_shape
  autocmd!
  autocmd VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"'
  autocmd InsertEnter,InsertChange *
    \ if v:insertmode == 'i' |
    \   silent execute '!echo -ne "\e[5 q"' |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' |
    \ endif
  autocmd VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
augroup END
