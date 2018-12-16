
set showtabline=2
set tabline=%!MyTabLine()

hi! TabFileType cterm=bold ctermfg=250 ctermbg=23
hi! TabLine cterm=none ctermbg=237 ctermfg=245
hi! TabLineFill cterm=none ctermbg=234
hi! TabLineSel cterm=none ctermbg=235 ctermfg=250
hi BufModified cterm=bold ctermfg=red

function! MyTabLine()
  let s = ''

  for i in range(tabpagenr('$'))
    let i = i + 1
    let bufmodified = ''
    if i == tabpagenr()
      let s .= '%#User6#'
      let s .= ' '.i.'%#TabLineSel# '
    else
      let s .= '%#User5# '.i.' '
      let s .= '%#TabLine#'
    endif
    for buf in tabpagebuflist(i)
      if getbufvar(buf, "&modified")
        let bufmodified = '⁕ '
      endif
    endfor
    let s .= '%' .i. 'T'
    let s .= '%{MyTabLabel(' .i. ')} '
    let s .= '%#BufModified#'.bufmodified
    let s .= '%#User2#┃'
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
