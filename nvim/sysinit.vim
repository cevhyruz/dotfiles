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

"
  " General Settings
  " -----------------
  syntax on                       " Enable syntax highlighting.
  filetype plugin on              " Enable loading of plugins per filetype.
  set encoding=utf-8 nobomb       " Use utf-8 encoding without BOM.
  set background=dark             " Disable dark texts on dark backgrounds.
  set colorcolumn=79              " Character per line guide.
  set numberwidth=1               " Line numbers gutter indention.
  set signcolumn=yes              " Always open signcolumn gutter.
  set number                      " Display line numbers.
  set scrolloff=12                " Line wrap around cursor while scrolling.
  set autoindent                  " Automatically set indent for new lines.
  set backspace=indent,eol,start  " Allow backspace in insert mode.
  set wildmenu                    " Enhance commandline completion.
  set clipboard=unnamed           " Use OS clipboard by default.
  set gdefault                    " Add the `g` flag to search/replace.
  set list                        " Show trailing whitespace, tabs, EOL, etc..
  set showbreak=...               " Show ellipsis where the line breaks.
  " set linebreak                   " Enable soft wrapping.
  " set wrap                        " Enable line-wrapping.
  " set wrapmargin=1                " Wrap lines from within `n` characters.
  set ignorecase                  " Make searching case-insensitive.
  set smartcase                   " Case-sensitive if expression has a capital.
  set incsearch                   " Highlight as pattern is typed.
  set nolazyredraw                " Don't redraw while running a macro.
  set diffopt+=vertical           " Vertical `diff`ing.
  set expandtab                   " Expand tabs to spaces.
  set smarttab                    " Don't override file default tabs.
  set tabstop=2                   " Tabs width.
  set softtabstop=2               " Use 2 spaces for tabs.
  set foldmethod=marker           " Manually create my own code folding method.
  set shiftwidth=2                " Number of spaces to for indention.
  set cursorline                  " Highlight current line.
  set mouse=a                     " Enable mouse in all modes.
  set ruler                       " Show cursor position in the file.
  set noshowmode                  " Show current mode.
  set swapfile                    " Always create swapfile.
  set backupdir=/tmp//            " Store backup in this directory.
  set fillchars+=vert:\┃          " Vertical split border style.
  set virtualedit=onemore         " One more space at the end for navigation.

  " TODO: check first if fzf is installed
  " in the terminal before setting the rtp.
  set rtp+=~/.fzf                 " Enable the fzf wrapper function for vim.



" Load the main configuration file.
" ----------------------------------
  source /home/devs/Projects/dotfiles/nvim/config.vim

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
