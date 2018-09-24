
" Load Components
  source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
  source /home/devs/Projects/dotfiles/nvim/components/statusline.vim

  source /home/devs/Projects/dotfiles/nvim/components/macros.vim


" General Settings

  set nocompatible               " Make vim more useful.
  syntax on                      " Enable syntax highlighting.
  set t_Co=256                   " Tell vim that terminal supports 256 colors.
  set encoding=utf-8 nobomb      " Use utf-8 encoding without BOM.
  set background=dark            " Disable dark texts on dark backgrounds.
  set colorcolumn=78             " Character per line guide.
  set numberwidth=4              " Line numbers left-indention.
  set number relativenumber      " Display hy-brid line numbers.
  set scrolloff=6                " Line wrap around cursor while scrolling.
  set autoindent                 " Automatically set indent for new lines.
  set autoread                   " Detect if a file has changed.
  set laststatus=2               " Always show the status line.
  set backspace=indent,eol,start " Allow backspace in insert mode.
  set showcmd                    " Show partial commands at bottom-right.
  set wildmenu                   " Enhance commandline completion.
  set clipboard=unnamed          " Use OS clipboard by default.
  set gdefault                   " Add the `g` flag to search/replace.
  set list                       " Show trailing whitespace, tabs, EOL, etc..
  set showbreak=...              " Show ellipsis where the line breaks.
" set linebreak                  " Enable soft wrapping.
" set wrap                       " Enable line-wrapping.
" set wrapmargin=1               " Wrap lines from within `n` characters.
  set ttyfast                    " Faster redrawing.
  set cmdheight=1                " Set command bar height.
  set history=10000              " Set vim history to maximum size.
  set ignorecase                 " Make searching case-insensitive.
  set smartcase                  " Case-sensitive if expression has a capital.
  set binary                     " No empty newlines at the end of files.
  set noeol                      " Same as `set binary`.
  set hlsearch                   " Highlight search results.
  set incsearch                  " Highlight as pattern is typed.
  set nolazyredraw               " Don't redraw whle running a macro.
  set diffopt+=vertical          " Vertical `diff`ing.
  set expandtab                  " Expand tabs to spaces.
  set smarttab                   " Don't override file default tabs.
  set tabstop=2                  " Tabs width.
  set softtabstop=2              " Use 2 spaces for tabs.
  set foldmethod=manual          " Manually create my own code folding method.
  set shiftwidth=2               " Number of spaces to for indention.
  set cursorline                 " Highlight current line.
  set mouse=a                    " Enable mouse in all modes.
  set ruler                      " Show cursor position in the file.
  set noshowmode                   " Show current mode.
  set showtabline=2              " Always show the tabline.

  set backupdir=/tmp//

" Don't create backup when in certain directories.
  set backupskip=/tmp/*,/private/tmp/*