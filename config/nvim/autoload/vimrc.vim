scriptencoding utf-8

if exists('g:loaded_vimrc')
  finish
endif
let g:loaded_vimrc = 1

let s:vimrc = {}
let g:vimrc = s:vimrc

function! vimrc#jumpto_prev_tab() abort
  if exists('g:prev_tab')
    try
      execute 'tabn' g:prev_tab
    catch /^Vim\%((\a\+)\)\=:E474/ " Invalid argument
      echom 'cant find tab '. g:prev_tab
    endtry
  else
     echom 'no previous tab/s'
  endif
endfunction

function! vimrc#navigate(direction) abort
  execute 'wincmd' a:direction
endfunction

function! vimrc#tmux_navigate(direction) abort "{{{1
  let l:curwin = winnr()

  if a:direction !=# 'p'
    call vimrc#navigate(a:direction)
  endif
  if (l:curwin is# winnr())
    let l:pane = shellescape($TMX_PANE)
    let l:jump = 'select-pane -t ' . l:pane . ' -' .tr(a:direction, 'phjkl', 'lLDUR')
    call system('tmux -S'.split($TMUX, ',')[0].' '.l:jump)
  endif
endfunction

function! s:editor_width() abort
  return (winwidth(0) - &foldcolumn - (&number ? &numberwidth : 0) - (&scl ==# 'yes' ? 2 : 0))
endfunction

function! s:foldline_percentage() abort
  let l:fold_size = (1 + (v:foldend - v:foldstart))
  let l:line_count = line('$')
  if has('float')
    try
      return '[' . printf('%4s', printf('%.1f', (l:fold_size * 1.0) / l:line_count * 100)) . '%]'
    catch #^Vim\%((\a\+)\)\=:E806# " using Float as a String
        return printf('[of %d lines] ', l:line_count)
    endtry
  endif
endfunction

function! vimrc#foldtext(delim) abort " {{{1

  if exists('+termguicolors')
    highlight Folded gui=none guifg=#d7d7d7 guibg=#efefef
  else
    highlight Folded cterm=none ctermbg=234 ctermfg=203
  endif

  let l:line = substitute(getline(v:foldstart), split(&commentstring, '%s')[0] . '\|{{{\d\=', '', 'g')
  " indent foldtext corresponding to foldlevel
  let l:indent = repeat(' ', shiftwidth())
  let l:foldLevelStr = repeat(l:indent, v:foldlevel - v:count1)
  let l:foldLineHead = substitute(l:line, '^\s*', l:foldLevelStr, '')
  " size foldtext according to window width
  let l:foldSize = (1 + (v:foldend - v:foldstart))
  " estimate fold length
  let l:foldSizeStr = ' ' . l:foldSize . ' lines '
  " build up foldtext
  let l:foldLineTail = l:foldSizeStr . s:foldline_percentage()
  let l:lengthTail = strwidth(l:foldLineTail)
  let l:lengthHead = (s:editor_width() - (lengthTail + indent))
  if strwidth(l:foldLineHead) > l:lengthHead
    let l:foldLineHead = strpart(l:foldLineHead, 0, l:lengthHead - 2) . '...'
  endif
  let l:foldlineWidth = 80
  let l:lengthMiddle = (s:editor_width() - strwidth(l:foldLineHead.l:foldLineTail))
  " truncate foldtext according to window width
  let l:expansionString = repeat(a:delim, l:lengthMiddle)
  let l:conceal = repeat(' ', (s:editor_width() - l:foldlineWidth))
  return l:foldLineHead . l:expansionString . l:foldLineTail. l:conceal
endfunction


" Section: Help
function! vimrc#helptab() abort
  if &buftype ==# 'help'
    execute 'wincmd T'
    nnoremap <buffer> q :q<cr>
  endif
endfunction

" Section: Fuzzy finder {{{1

let s:callback = {}
let s:fzf_action = {
  \ 'ctrl-l': 'botright vsplit',
  \ 'ctrl-h': 'topleft vsplit',
  \ 'alt-t': 'tab split',
  \ 'alt-i': 'split' }

function! s:callback.on_exit(id, status, event) abort
  bdelete!
endfunction

function! vimrc#execute(cmd) abort
  let height = 13
  execute 'botright' height 'new'
  call termopen(a:cmd, s:callback)
  setlocal nospell bufhidden=wipe nobuflisted nonumber nornu
  setfiletype fzf
  startinsert
endfunction
