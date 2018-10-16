"------------------------------------------------
" config.vim - neovim general configuration file |
"------------------------------------------------
"
  " General Settings
  " -----------------
  set nocompatible                " Make vim more useful.
  syntax on                       " Enable syntax highlighting.
  filetype plugin on              " Enable loading of plugins per filetype.
  set t_Co=256                    " Tell vim that terminal supports 256 colors.
  set encoding=utf-8 nobomb       " Use utf-8 encoding without BOM.
  set background=dark             " Disable dark texts on dark backgrounds.
  set colorcolumn=79              " Character per line guide.
  set numberwidth=1               " Line numbers gutter indention.
  set signcolumn=yes              " Always open signcolumn gutter.
  set number                      " Display line numbers.
  set scrolloff=12                " Line wrap around cursor while scrolling.
  set autoindent                  " Automatically set indent for new lines.
  set autoread                    " Detect if a file has changed.
  set laststatus=2                " Always show the status line.
  set backspace=indent,eol,start  " Allow backspace in insert mode.
  set showcmd                     " Show partial commands at bottom-right.
  set wildmenu                    " Enhance commandline completion.
  set clipboard=unnamed           " Use OS clipboard by default.
  set gdefault                    " Add the `g` flag to search/replace.
  set list                        " Show trailing whitespace, tabs, EOL, etc..
  set showbreak=...               " Show ellipsis where the line breaks.
  " set linebreak                   " Enable soft wrapping.
  " set wrap                        " Enable line-wrapping.
  " set wrapmargin=1                " Wrap lines from within `n` characters.
  set ttyfast                     " Faster redrawing.
  set cmdheight=1                 " Set command bar height.
  set history=10000               " Set vim history to maximum size.
  set ignorecase                  " Make searching case-insensitive.
  set smartcase                   " Case-sensitive if expression has a capital.
  set binary                      " No empty newlines at the end of files.
  set noeol                       " Same as `set binary`.
  set hlsearch                    " Highlight search results.
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
"  set showtabline=2               " Always show the tabline.
  set swapfile                    " Always create swapfile.
  set backupdir=/tmp//            " Store backup in this directory.
  set fillchars+=vert:\┃          " Vertical split border style.
  set virtualedit=onemore         " One more space at the end for navigation.

  " TODO: check first if fzf is installed
  " in the terminal before setting the rtp.
  set rtp+=~/.fzf                 " Enable the fzf wrapper function for vim.


" Don't bother creating backups when i'm in this directories.
  set backupskip=/tmp/*