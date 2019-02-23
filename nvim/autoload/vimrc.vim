
function! vimrc#navigate(direction)
  execute 'wincmd ' . a:direction
endfunction

function! vimrc#tmuxNav(direction)
  let curwin = winnr()
  if ! (a:direction == 'p')
    call vimrc#navigate(a:direction)
  endif
  if (curwin == winnr())
    let pane = shellescape($TMX_PANE)
    let jump = 'selectp -t ' . pane . ' -' .tr(a:direction, 'phjkl', 'lLDUR')
    call system('tmux -S '.split($TMUX, ',')[0].' '.jump)
  endif
endfunction
