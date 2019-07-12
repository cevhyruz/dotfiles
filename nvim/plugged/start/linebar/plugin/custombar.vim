" ------------------------------------------------------------------------------
" File:       plugin/custom-line.vim
" Descripton: Set the statusline and tabline
" Type:       feature
" Author:     John Fred Fadrigalan <github.com/cevhyruz>
" License:    DWTFYWTPL
"------------------------------------------------------------------------------
"
" TODO: please support:
" glyphicons,  ([x] raw codes, [x] patched-font support)
" https://unix.stackexchange.com/questions/61118/how-to-enter-non-ascii-characters-using-hex-or-octal-codes-in-vi
"https://vi.stackexchange.com/questions/2299/how-to-translate-unicode-escape-sequences-to-the-unicode-character
"https://stackoverflow.com/questions/14664293/vim-replace-with-unicode-character
"
" status_type, (minimal, powerliner, developer, haxxor)
" local colorscheme (config)
"
" support startify

" Focused
let g:status_bg = '237'
let g:status_fg = '248'
" Inactive
let g:statusNC_bg = '236'
let g:statusNC_fg = '243'
" Attributes
let g:status_dim       = '242'
let g:status_identify  = '30'
let g:status_separator = '241'
let g:status_block     = '240'

" focused
" dim
" background
" foreground
" contrast
" accent

let s:git_branch = system('git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null || echo unknown')

execute 'hi statusline cterm=none ctermbg='.g:status_bg.' ctermfg='.g:status_fg.
  \ '| hi statuslineNC cterm=none ctermbg='.g:statusNC_bg ' ctermfg='.g:statusNC_fg.
  \ '| hi User1        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_dim.
  \ '| hi User2        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_identify
  \ '| hi User3        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_separator.
  \ '| hi User4        cterm=bold ctermbg='.g:statusNC_fg ' ctermfg='.g:status_block

set statusline=%!MyStatusLine('active')


function! s:get_status()
  let status = get(g:, 'status_name', 'default')
endfunction

function! MyStatusLine(state)
endfunction

augroup statusline_state
  autocmd!
  autocmd WinEnter * setlocal statusline=%!MyStatusLine('active')
  autocmd WinLeave * setlocal statusline=%!MyStatusLine('inactive')
augroup END

" ------------------------------------------------------------------
" tabline
" ------------------------------------------------------------------
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
    let s .= ' '.getcwd()
  endif
  return s
endfunction

function! MyTabLabel(n)
  let tabsplits = len(tabpagebuflist(a:n))
  let _buflist = tabpagebuflist(a:n)
  let _winnr = tabpagewinnr(a:n)
  let filename = fnamemodify(bufname(_buflist[_winnr - 1]), ':t')
  if exists('g:loaded_webdevicons')
    let icon = WebDevIconsGetFileTypeSymbol(filename)
    return icon.' '.(filename ==# '' ? 'New Tab' : filename).' '.(tabsplits == 1 ? '' : '('.tabsplits.')')
  endif
  return (filename ==# '' ? 'Untitled' : filename). ' '.(tabsplits == 1 ? '' : '('.tabsplits.')')
endfunction
