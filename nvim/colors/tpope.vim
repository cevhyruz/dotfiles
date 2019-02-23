set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "tpope"

hi colorcolumn cterm=none ctermbg=233
hi Comment cterm=none ctermfg=242 ctermbg=none
hi cursorline cterm=none ctermfg=none ctermbg=235
hi foldcolumn cterm=none ctermbg=none ctermfg=242
hi folded cterm=none ctermbg=none ctermfg=242
hi LineNR cterm=none ctermbg=234 ctermfg=242
hi cursorlineNR ctermbg=none ctermfg=red
hi vertsplit cterm=none ctermbg=234 ctermfg=236

hi ErrorMsg cterm=none ctermbg=none ctermfg=203

hi modemsg cterm=none ctermfg=203

hi Visual cterm=bold ctermbg=0

" nerdtree
hi NERDTreeDir cterm=none ctermbg=none ctermfg=30
hi NERDTreeCWD cterm=none ctermbg=none ctermfg=30

hi vimCommentTitle cterm=bold ctermbg=none ctermfg=14

hi signcolumn cterm=none ctermbg=234
" ------------------------------------------------------------------
" spelling
" ------------------------------------------------------------------
hi SpellBad cterm=italic ctermfg=red ctermbg=none

" ------------------------------------------------------------------
" statusline
" ------------------------------------------------------------------
" hi statusline cterm=none ctermbg=235
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

" todos
hi shTodo cterm=none ctermbg=none

hi! EndOfBuffer ctermfg=234

hi NerdIgnored cterm=none ctermfg=242
hi vimTodo cterm=bold ctermbg=241 ctermfg=234

source $XDG_CONFIG_HOME/nvim/colors/sh.vim
