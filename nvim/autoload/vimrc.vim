"------------------------------------------------------------------------------
" File:     autoload/vimrc.vim
" Author:   John Fred Fadrigalan <github.com/cevhyruz>
" License:  DWTFYWTPL
"------------------------------------------------------------------------------

let s:vimrc = {}
let g:vimrc = s:vimrc

function vimrc#strip_whitespaces() "{{{1
  let l:save_curpos = getpos(".")
  let l:old_query = getreg("/")
  %s/\s\+$//e
  call setpos(".", l:save_curpos)
  call setreg("/", l:old_query)
endfunction

function! vimrc#jumpto_prev_tab()
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

function vimrc#navigate(direction)
  execute "wincmd" a:direction
endfunction

function vimrc#tmux_navigate(direction) "{{{1
  let l:curwin = winnr()
  if a:direction !=# 'p'
    call vimrc#navigate(a:direction)
  endif
  if (l:curwin is# winnr())
    let l:pane = shellescape($TMX_PANE)
    let l:jump = "select-pane -t " . l:pane . " -" .tr(a:direction, "phjkl", "lLDUR")
    call system("tmux -S".split($TMUX, ",")[0]." ".l:jump)
  endif
endfunction

function s:editor_width()
  return (winwidth(0) - &fdc - (&nu ? &nuw : 0) - (&scl ==# "yes" ? 2 : 0))
endfunction

function s:foldline_percentage()
  let l:fold_size = (1 + (v:foldend - v:foldstart))
  let l:line_count = line("$")
  if has("float")
    try
      return "[" . printf("%4s", printf("%.1f", (l:fold_size * 1.0) / l:line_count * 100)) . "%]"
    catch #^Vim\%((\a\+)\)\=:E806# " using Float as a String
        return printf("[of %d lines] ", l:line_count)
    endtry
  endif
endfunction

function vimrc#foldtext(delim) " {{{1
  let l:line = substitute(getline(v:foldstart), split(&cms, '%s')[0] . '\|{{{\d\=', '', 'g')
  " indent foldtext corresponding to foldlevel
  let l:indent = repeat(' ', shiftwidth())
  let l:foldLevelStr = repeat(l:indent, v:foldlevel - v:count1)
  let l:foldLineHead = substitute(l:line, '^\s*', l:foldLevelStr, '')
  " size foldtext according to window width
  let l:foldSize = (1 + (v:foldend - v:foldstart))
  " estimate fold length
  let l:foldSizeStr = " " . l:foldSize . " lines "
  " build up foldtext
  let l:foldLineTail = l:foldSizeStr . s:foldline_percentage()
  let l:lengthTail = strwidth(l:foldLineTail)
  let l:lengthHead = (s:editor_width() - (lengthTail + indent))
  if strwidth(l:foldLineHead) > l:lengthHead
    let l:foldLineHead = strpart(l:foldLineHead, 0, l:lengthHead - 2) . '...'
  endif
  let l:lengthMiddle = (s:editor_width() - strwidth(l:foldLineHead.l:foldLineTail))
  " truncate foldtext according to window width
  let l:expansionString = repeat(a:delim, l:lengthMiddle)
  return l:foldLineHead . l:expansionString . l:foldLineTail
endfunction


" Section: Help
function! vimrc#helptab()
  if &buftype == 'help'
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

function! s:callback.on_exit(id, status, event)
  bdelete!
endfunction

function! vimrc#execute(cmd)
  let height = 13
  execute "botright" height "new"
  call termopen(a:cmd, s:callback)
  setlocal nospell bufhidden=wipe nobuflisted nonumber nornu
  setfiletype fzf
  startinsert
endfunction
