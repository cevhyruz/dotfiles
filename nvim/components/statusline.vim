if &laststatus == 0
 fish
endif

" Focused
let g:status_bg = '235'
let g:status_fg = '248'
" Inactive
let g:statusNC_bg = '235'
let g:statusNC_fg = '243'
" Attributes
let g:status_dim       = '242'
let g:status_identify  = '30'
let g:status_separator = '241'
let g:status_block     = '240'

let s:git_branch = system('git symbolic-ref --short HEAD 2> /dev/null || git rev-parse --short HEAD 2> /dev/null || echo unknown')

execute 'hi statusline cterm=none ctermbg='.g:status_bg.' ctermfg='.g:status_fg.
  \ '| hi statuslineNC cterm=none ctermbg='.g:statusNC_bg ' ctermfg='.g:statusNC_fg.
  \ '| hi User1        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_dim.
  \ '| hi User2        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_identify
  \ '| hi User3        cterm=bold ctermbg='.g:status_bg ' ctermfg='.g:status_separator.
  \ '| hi User4        cterm=bold ctermbg='.g:statusNC_fg ' ctermfg='.g:status_block

set statusline=%!MyStatusLine('active')

function! MyStatusLine(state)
  let s = ''
  let g:separator = '%1* : %0*'
  if a:state ==# 'active'
    let s .= '%4* %n %0*' " Buffer number.
    let s .= '%1* %t' " File name
    let s .= g:separator
    let s .= '%<' " will truncate here.
    let s .= '%2* %0*'
     let s .= '%1*'.s:git_branch[:-2] " Current git branch.
    let s .= '%2* %([%M%R%H]%) %0*' " Buffer flags.
    let s .= '%=' " =============separator==============
    let s .= '%1*'.(&ft == '' ? 'none' : '%2*%{&ft}').'%0*' " Filetype.
    let s .= '%1*(%{&enc})%0*' " File encoding.
    let s .= g:separator
    let s .= '%2* %0*%L' " Line number.
    let s .= g:separator
    let s .= '%2* %0*%3v' " Column number
    let s .= g:separator
    let s .= '%3p%2*%%%0*' " Percentage
    let s .= g:separator
    let s .= '%2*%{AleStatus()}%0*' " Linter
  else
    let s .= '%n' " Buffer number.
    let s .= g:separator
    let s .= '%t' " File name
  endif
  return s
endfunction

function! AleStatus()
  if exists('g:loaded_ale_dont_use_this_in_other_plugins_please')
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? ' ' : printf(
      \   '%dW %dE',
      \   all_non_errors,
      \   all_errors
    \)
  else
    return ''
  endif
endfunction

augroup statusline_state
  autocmd!
  autocmd WinEnter * setlocal statusline=%!MyStatusLine('active')
  autocmd WinLeave * setlocal statusline=%!MyStatusLine('inactive')
augroup END
