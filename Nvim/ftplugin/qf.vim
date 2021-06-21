" ------------------------------------------------------------------
"  Quickfix window
" ------------------------------------------------------------------

if ! &cul          | setlocal cul      | endif " enable cursorline
if   &nu           | setlocal nu nornu | endif " disable linenumber
if   &cc           | setlocal cc=      | endif " disable colorcolumn
if   &scl == 'yes' | setlocal scl=no   | endif " disable signcolumn

autocmd BufRead  <buffer> setlocal statusline=quickfix\ window
autocmd BufLeave <buffer> if &ls == 0 | setlocal laststatus=2 | endif
