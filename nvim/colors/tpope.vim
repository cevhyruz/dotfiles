"------------------------------------------------------------------------------
" File:          colors/mytheme.vim
" Description:   dark theme for vim.
" Author:        John Fred Fadrigalan <github.com/cevhyruz>
" License:       DWTFYWTPL
"------------------------------------------------------------------------------

" Section: Initialisation{{{
set background=dark
" To achieved synchronized `dim-inactive-window` effect on both tmux panes
" and vim splits, `Normal` highlighting should be cleared if tmux is active,
" and let tmux window-active-style/window-style option to pass through.
call execute((empty($TMUX)        ? ':hi clear'     : ':hi clear Normal'))
call execute((exists('syntax_on') ? ':syntax reset' :                 ''))
let g:colors_name = 'mytheme' "}}}

" hi Normal ctermbg=235
hi colorcolumn cterm=none ctermbg=233
hi Comment cterm=none ctermfg=242 ctermbg=none
hi cursorline cterm=none ctermfg=none ctermbg=235
hi cursorcolumn cterm=none ctermbg=235
hi foldcolumn cterm=none ctermbg=none ctermfg=242
hi folded cterm=none ctermbg=none ctermfg=242
hi LineNR cterm=none ctermbg=234 ctermfg=242
hi cursorlineNR ctermbg=none ctermfg=red
hi vertsplit cterm=none ctermbg=234 ctermfg=236

hi ErrorMsg cterm=none ctermbg=none ctermfg=203

hi modemsg cterm=none ctermfg=203

hi Visual cterm=none ctermbg=239 ctermfg=none

" nerdtree
hi NERDTreeDir cterm=none ctermbg=none ctermfg=30
hi NERDTreeCWD cterm=none ctermbg=none ctermfg=30

hi vimCommentTitle cterm=bold ctermbg=none ctermfg=14

hi Wildmenu cterm=none ctermbg=235 ctermfg=yellow

hi signcolumn cterm=none ctermbg=234
" ------------------------------------------------------------------
" spelling
" ------------------------------------------------------------------
hi SpellBad cterm=italic ctermfg=red ctermbg=none

" ------------------------------------------------------------------
" statusline
" ------------------------------------------------------------------
hi statusline cterm=none ctermbg=235 ctermfg=242
" hi StatusLineNC cterm=none ctermbg=23
" hi User1 cterm=none ctermbg=23 ctermfg=230
" ------------------------------------------------------------------
"  [?] Tab Page
" ------------------------------------------------------------------
" active tab
hi TabLineSel cterm=none ctermbg=234 ctermfg=246
" inactive tab
hi TabLine cterm=none ctermbg=235 ctermfg=244
" tab bar
hi TabLineFill cterm=none ctermbg=235

hi Matchparen cterm=bold ctermfg=234

syntax match Test #/\$[a-z]# containedin=tmuxString contained
hi Test cterm=bold ctermfg=14

hi tmuxVariableExpansion ctermfg=217
" todos
hi shTodo cterm=none ctermbg=none

hi! EndOfBuffer ctermfg=234

hi NerdIgnored cterm=none ctermfg=242
hi vimTodo cterm=bold ctermbg=241 ctermfg=234

source $XDG_CONFIG_HOME/nvim/colors/sh.vim
