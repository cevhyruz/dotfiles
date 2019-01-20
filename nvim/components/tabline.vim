set showtabline=2
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    let i = i + 1
    if i == tabpagenr()
      let s .= ' %#TabLineSel# '.i            " active tab
    else
      let s .= ' %#Tabline# '.i               " inactive tab
    endif
    let s .= '%' .i. 'T'                      " mouse-click start
    let s .= '   %{MyTabLabel(' .i. ')} '
  endfor
  let s .= '%#TabLineFill#%T'                 " mouse-click end
  let s .= '%<'                               " truncate here
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#'                   " separator
    " all opened tab count
    let s .= ' '.len(filter(range(1, bufnr('$')), 'buflisted(v:val)')).' '
  endif
  return s
endfunction

function! MyTabLabel(n)
  let tabsplits = len(tabpagebuflist(a:n))
  let _buflist = tabpagebuflist(a:n)
  let _winnr = tabpagewinnr(a:n)
  let filename = fnamemodify(bufname(_buflist[_winnr - 1]), ':t')
  if exists("g:loaded_webdevicons")
    let icon = WebDevIconsGetFileTypeSymbol(filename)
    return icon.' '.(filename == '' ? 'New Tab' : filename).' '.(tabsplits == 1 ? '' : '('.tabsplits.')')
  endif
  return (filename == '' ? 'Untitled' : filename). ' '.(tabsplits == 1 ? '' : '('.tabsplits.')')
endfunction
