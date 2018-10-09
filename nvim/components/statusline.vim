" Statusline (requires Powerline font)
set statusline=
set statusline+=%(%{&buflisted?bufnr('%'):''}\ \ %)
set statusline+=%< " Truncate line here
set statusline+=%f\  " File path, as typed or relative to current directory
set statusline+=%{&modified?'+\ ':''}
set statusline+=%{&readonly?'\ ':''}
set statusline+=%= " Separation point between left and right aligned items
set statusline+=\ %{&filetype!=#''?&filetype:'none'}
set statusline+=%(\ %{(&bomb\|\|&fileencoding!~#'^$\\\|utf-8'?'\ '.&fileencoding.(&bomb?'-bom':''):'')
  \.(&fileformat!=#(has('win32')?'dos':'unix')?'\ '.&fileformat:'')}%)
  set statusline+=%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)
  set statusline+=\ 
  set statusline+=\ %{&number?'':printf('%2d,',line('.'))} " Line number
  set statusline+=%-2v " Virtual column number
  set statusline+=\ %2p%% " Percentage through file in lines as in |CTRL-G|

  " ------------------------ 8< ------------------------

  " Statusline with highlight groups (requires Powerline font, using Solarized theme)
  set statusline=
  set statusline+=%(%{&buflisted?bufnr('%'):''}\ \ %)
  set statusline+=%< " Truncate line here
  set statusline+=%f\  " File path, as typed or relative to current directory
  set statusline+=%{&modified?'+\ ':''}
  set statusline+=%{&readonly?'\ ':''}
  set statusline+=%1*\  " Set highlight group to User1
  set statusline+=%= " Separation point between left and right aligned items
  set statusline+=\ %{&filetype!=#''?&filetype:'none'}
  set statusline+=%(\ %{(&bomb\|\|&fileencoding!~#'^$\\\|utf-8'?'\ '.&fileencoding.(&bomb?'-bom':''):'')
    \.(&fileformat!=#(has('win32')?'dos':'unix')?'\ '.&fileformat:'')}%)
    set statusline+=%(\ \ %{&modifiable?(&expandtab?'et\ ':'noet\ ').&shiftwidth:''}%)
    set statusline+=\ %* " Restore normal highlight
    set statusline+=\ %{&number?'':printf('%2d,',line('.'))} " Line number
    set statusline+=%-2v " Virtual column number
    set statusline+=\ %2p%% " Percentage through file in lines as in |CTRL-G|

    " Logic for customizing the User1 highlight group is the following
    " - if StatusLine colors are reverse, then User1 is not reverse and User1 fg = StatusLine fg
    hi StatusLine cterm=reverse gui=reverse ctermfg=14 ctermbg=8 guifg=#93a1a1 guibg=#002732
    hi StatusLineNC cterm=reverse gui=reverse ctermfg=11 ctermbg=0 guifg=#657b83 guibg=#073642
    hi User1 ctermfg=14 ctermbg=0 guifg=#93a1a1 guibg=#073642