"------------------------------------------------------------------------------
" File:        colors/mytheme.vim
" Description: a super bias dark theme for my vim.
" Author:      John Fred Fadrigalan <github.com/cevhyruz>
" License:     DWTFYWTPL
"------------------------------------------------------------------------------

" Section: Initialisation
" - - - - - - - - - - - -
set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
call execute((!empty($TMUX) ? ":hi clear Normal" : ":hi Normal ctermbg=235"))
let g:colors_name = "mytheme"

"tmp: re-arrange:
hi Nontext cterm=none ctermbg=none ctermfg=none
" Section: Built-in highlight group
" - - - - - - - - - - - - - - - - -
hi ColorColumn  cterm=none             ctermbg=234
hi Conceal      cterm=none ctermfg=240 ctermbg=none
" hi Cursor
" hi CursorIM
hi CursorColumn cterm=none ctermbg=235

hi Comment cterm=none ctermfg=242 ctermbg=none
hi cursorline cterm=none ctermfg=none ctermbg=236
hi foldcolumn cterm=none ctermbg=none ctermfg=242
hi folded cterm=none ctermbg=none ctermfg=242
hi LineNR cterm=none ctermbg=235 ctermfg=243
hi cursorlineNR cterm=bold ctermbg=237 ctermfg=11
hi vertsplit cterm=none ctermbg=none ctermfg=240

hi ErrorMsg cterm=none ctermbg=none ctermfg=203

hi modemsg cterm=none ctermfg=203


" nerdtree
hi NERDTreeDir cterm=none ctermbg=none ctermfg=30
hi Visual cterm=none ctermbg=239 ctermfg=none
hi NERDTreeCWD cterm=none ctermbg=none ctermfg=30

hi vimCommentTitle cterm=bold ctermbg=none ctermfg=14

hi Wildmenu cterm=none ctermbg=235 ctermfg=yellow

hi signcolumn cterm=none ctermbg=235
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
