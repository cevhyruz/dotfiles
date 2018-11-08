
set showtabline=2

hi! TabFileType cterm=bold ctermfg=250 ctermbg=23
hi! TabLine cterm=none
hi! TabLineFill cterm=none ctermbg=234

function! MyTabLine()
  let s = '%#TabFileType#'
  let s .= '  ' . toupper(&filetype) . '  '
    if 0 + 1 == tabpagenr()  " if tab is the current active buffer.
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '  %{WebDevIconsGetFileTypeSymbol()} ' .
          \'%{MyTabLabel()} %M'
    " right-align the label to close the current tab page
    let s .= '%=%#TabFileType#  buffers : %{BufCount()}  '
  return s
endfunction

function! BufCount()
  return len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
endfunction

function! MyTabLabel()
  let filename = expand('%:t')
  if filename == ''
    return '[No Name]'
  else
    return filename
  endif
endfunction

set tabline=%!MyTabLine()
