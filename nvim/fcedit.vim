"--------------------------------------------------------------------------
"  fcedit.vim - minimal configuration file for bash built-in `fc` command  |
"--------------------------------------------------------------------------


" Disable shitload of global plugins {{{

  let loaded_matchit       = 1
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  let loaded_gzip          = 1
  let g:loaded_zipPlugin   = 1
  let g:loaded_zip         = 1

" }}}

hi! EndOfBuffer ctermfg=234
hi! Statusline ctermfg=235 ctermbg=250
" Basic Settings {{{

  syntax enable                 " Enable syntax highlighting.
  set ft=sh                     " Enable syntax highliting for shell scripts.

  set background=dark           " Disable dark texts on dark backgrounds.
  set number
  set signcolumn=yes            " Always show signcolumn gutter.
  set clipboard=unnamedplus     " Always use system clipboard.
  set list                      " Show trailing whitespace, tabs, EOL, etc..
  set expandtab                 " Expand tabs to spaces.
  set tabstop=2                 " Tabs width.
  set softtabstop=2             " Use 2 spaces for tabs.
  set shiftwidth=2              " Number of spaces to use for indention.
  set noshowmode                " Hide mode display.


" }}}

  set statusline=%0*\ Edit\ history\ and\ run

  source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
