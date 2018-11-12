
set showtabline=2

hi! TabFileType cterm=bold ctermfg=250 ctermbg=23
hi! TabLine cterm=none
hi! TabLineFill cterm=none ctermbg=234

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (i + 1) . 'T'
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine# %{BufCount()} '
  endif
  return s
endfunction

function! BufCount()
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = fnamemodify(bufname(buflist[winnr - 1]), ':t')
  if expand('%:t') == ''
    return WebDevIconsGetFileTypeSymbol(). ' ' . 'New File'
  else
  return WebDevIconsGetFileTypeSymbol(filename). ' ' .filename
endfunction
set tabline=%!MyTabLine()
