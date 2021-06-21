function! DimInactiveWindows()
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let l:range = ""
    if i != winnr()
      if &wrap
        " HACK: when wrapping lines is enabled, we use the maximum number
        " of columns getting highlighted. This might get calculated by
        " looking for the longest visible line and using a multiple of
        " winwidth().
        let l:width=256 " max
      else
        let l:width=winwidth(i)
      endif
      let l:range = join(range(1, l:width), ',')
    endif
    call setwinvar(i, '&colorcolumn', l:range)
  endfor
endfunction

" augroup diminactivewindows
" autocmd!
" autocmd WinEnter * call DimInactiveWindows()
" augroup END


" augroup remove_cul_in_inactive_windows
"   autocmd!
"   autocmd WinEnter * call Remove_Cul()
" augroup END
"
" function! Remove_Cul()
"   setlocal cul
" endfunction
"
