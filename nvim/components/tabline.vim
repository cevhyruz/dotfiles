
set showtabline=2

hi! TabFileType cterm=bold ctermfg=250 ctermbg=23
hi! TabLine cterm=none
hi! TabLineFill cterm=none ctermbg=234


function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'
    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction


function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = fnamemodify(bufname(buflist[winnr - 1]), ':t')
  return WebDevIconsGetFileTypeSymbol(filename) .' '. filename
endfunction


set tabline=%!MyTabLine()
