"-------------------------------------------------
" sysinit.vim - neovim system-wide bootstrap file |
"-------------------------------------------------

" Disable some global plugins {{{

  let loaded_matchit       = 1
  let g:loaded_netrw       = 1
  let g:loaded_netrwPlugin = 1
  let loaded_gzip          = 1
  let g:loaded_zipPlugin   = 1
  let g:loaded_zip         = 1

" }}}

" Some options were omited, see `:help nvim-defaults` for details.

" Basic Settings {{{

  syntax on                       " Enable syntax highlighting.
  filetype plugin on              " Enable loading of plugins per filetype.

  set background=dark             " Disable dark texts on dark backgrounds.
  set colorcolumn=79              " Character per line guide.
  set signcolumn=yes              " Always open signcolumn gutter.
  set number                      " Display line numbers.
  set nofoldenable
  set scrolloff=16                " Line wrap around cursor while scrolling.
  set backspace=indent,eol,start  " Allow backspace in insert mode.
  set clipboard+=unnamedplus      " Use OS clipboard by default.
  set list                        " Show trailing whitespace, tabs, EOL, etc..
  set showbreak=...               " Show ellipsis where the line breaks.
  set ignorecase                  " Make searching case-insensitive.
  set smartcase                   " Case-sensitive if expression has a capital.
  set nolazyredraw                " Don't redraw while running a macro.
  set expandtab                   " Expand tabs to spaces.
  set tabstop=2                   " Tabs width.
  set softtabstop=2               " Use 2 spaces for tabs.
  set foldmethod=marker           " Manually create my own code folding method.
  set shiftwidth=2                " Number of spaces to for indention.
  set cursorline                  " Highlight current line.
  set mouse=a                     " Enable mouse in all modes.
  set backupdir=/tmp//            " Set the backup directory.
  set noshowmode                  " Don't show current mode in commandline.
  set fillchars+=vert:\┃,fold:\   " Vertical split border style.
  set rtp+=~/.fzf                 " Enable the fzf wrapper function for vim.

" }}}

" Load the main configuration file.
" ----------------------------------
"  source /home/devs/Projects/dotfiles/nvim/config.vim

" Load Components.
" -----------------
  source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
  source /home/devs/Projects/dotfiles/nvim/components/statusline.vim
  source /home/devs/Projects/dotfiles/nvim/components/macros.vim

" Initialize package-specific configuration files.
" -------------------------------------------------
  source /home/devs/Projects/dotfiles/nvim/packages/pathogen.vim
  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree.vim
"  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree-git-plugin.vim
"  source /home/devs/Projects/dotfiles/nvim/packages/vim-airline.vim
"  source /home/devs/Projects/dotfiles/nvim/packages/fzf.vim
  source /home/devs/Projects/dotfiles/nvim/packages/vim-devicons.vim

" Load the local.nvimrc for local configuration.
" -----------------------------------------------
if filereadable("/home/devs/Projects/dotfiles/_localrc/local.nvimrc")
  source /home/devs/Projects/dotfiles/_localrc/local.nvimrc
endif
