"--------------------------------------------------------------------------
"  fcedit.vim - minimal configuration file for bash built-in `fc` command  |
"--------------------------------------------------------------------------

" Disable some global plugins {{{

  let loaded_matchit       = 1
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  let loaded_gzip          = 1
  let g:loaded_zipPlugin   = 1
  let g:loaded_zip         = 1

" }}}

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
  set shortmess+=F

" }}}

  set statusline=
  set statusline=%0*\ Edit\ last\ history\ and\ run
  set statusline+=%=
  set statusline+=%0*☰\ %2v\                        " Column Number.

  source /home/devs/Projects/dotfiles/nvim/components/keybindings/basic.vim

hi! EndOfBuffer ctermfg=234
hi! Statusline ctermfg=23 ctermbg=250
