
set showtabline=2
set tabline=%!MyTabLine()

hi! TabFileType cterm=bold ctermfg=250 ctermbg=23
hi! TabLine cterm=none ctermbg=235 ctermfg=242
hi! TabLineFill cterm=none ctermbg=235
hi! TabLineSel cterm=none ctermbg=234 ctermfg=248
hi BufModified cterm=bold ctermfg=red

function! MyTabLine()
  let s = ''

  for i in range(tabpagenr('$'))
    let i = i + 1
    let bufmodified = ''
    if i == tabpagenr()
      let s .= '%#TabLineSel# ' .i
    else
      let s .= '%#Tabline# '.i
    endif
    for buf in tabpagebuflist(i)
      if getbufvar(buf, "&modified")
        let bufmodified = '⁕ '
      endif
    endfor
    let s .= '%' .i. 'T'                      " moust-click start
    let s .= ' %{MyTabLabel(' .i. ')}  '
    let s .= '%#BufModified#'.bufmodified
  endfor
  let s .= '%#TabLineFill#%T'                 " mouse-click end
  let s .= '%<'                               " truncate here
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#'
    let s .= ' '.len(filter(range(1, bufnr('$')), 'buflisted(v:val)')).' '
  endif
  return s
endfunction

function! MyTabLabel(n)
  let tabsplits = len(tabpagebuflist(a:n))
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let filename = fnamemodify(bufname(buflist[winnr - 1]), ':t')
  return (tabsplits == 1 ? '' : '('.tabsplits.')').' '.
        \ WebDevIconsGetFileTypeSymbol(filename).' '.
        \ (filename == '' ? 'Untitled' : filename)
endfunction
