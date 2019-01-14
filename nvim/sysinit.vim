" General {{{
    syntax enable " Allow using :hi to set my preferred colors.
    filetype plugin indent on " Enable loading of plugins per filetype.
    set autoread " Detect if the file is changed.
    set history=10000 " More room for history logs.
    set backspace=indent,eol,start " Make <BS> behave in a sane manner.
    set clipboard+=unnamedplus " Use the OS clipboard by default.
    set updatetime=100 " Faster update time.
    set nolazyredraw " Don't redraw while running a macro.
    set shortmess+=F " Don't give the fileinfo when editing a file.
    set wildmode=list:longest,full
    set textwidth=120 " Max width of text before breaking after whitespace.
" }}}

" Appearance {{{
    set noshowmode " Don't show current mode in commandline.
    set cursorline " Highlight the current line where the cursor is.
    set background=dark " Use light texts in dark background.
    set colorcolumn=79 " Character per line threshold guide.
    " Gutter
    set signcolumn=yes " Always open signcolumn gutter.
    set number relativenumber " Always display the line numbers.
    " Check spelling.
    set spell spelllang=en_us " Enable word spelling checks.
    " Code folding
    set foldmethod=marker " Lines with equal indent form a fold.
    set foldtext=functions#myFoldText()
    " Display invisible characters.
    set list
    set listchars=trail:~,tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
    set showbreak=↪
    " Splits
    set splitbelow " Horizontal split spawns below.
    set splitright " Vertical splits spawns at right side.
    set fillchars+=vert:\┃ " Vertical split border.
" }}}

" Behaviour {{{
    " Searching
    set ignorecase " Make searching case-insensitive.
    set smartcase " Case-sensitive if expression has a capital.
    " Tab control
    set expandtab " Expand <Tabs> as spaces.
    set tabstop=2 " visible <Tab> width.
    set smarttab " <Tabs> respects 'tabstops', 'shiftwidth', and 'softtabstop.
    set softtabstop=2 " edit as if the <Tab> if four characters wide.
    set shiftwidth=2 " Number of spaces to use for indention.
    " Scrolling
    set scrolloff=15 " Line wrap around cursor while scrolling.
    " Mouse support
    set mouse=a " Enable mouse in all modes.
" }}}

" Paths and Locations {{{
    set rtp+=/home/devs/.fzf " Enable the fzf wrapper function for vim.
    set backupdir=/tmp// " Set the backup directory.
" }}}

" Components {{{
    source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
    source /home/devs/Projects/dotfiles/nvim/components/statusline.vim
    source /home/devs/Projects/dotfiles/nvim/components/macros.vim
    source /home/devs/Projects/dotfiles/nvim/components/tabline.vim
" }}}

" Plugin sripts {{{
    source /home/devs/Projects/dotfiles/nvim/packages/nerdtree.vim
    source /home/devs/Projects/dotfiles/nvim/packages/nerdcommenter.vim
    source /home/devs/Projects/dotfiles/nvim/packages/ale.vim
    source /home/devs/Projects/dotfiles/nvim/packages/gitgutter.vim
    source /home/devs/Projects/dotfiles/nvim/packages/ycm.vim
    source /home/devs/Projects/dotfiles/nvim/packages/ultisnips.vim
  " source /home/devs/Projects/dotfiles/nvim/packages/nerdtree-git-plugin.vim
  " source /home/devs/Projects/dotfiles/nvim/packages/vim-airline.vim
    source /home/devs/Projects/dotfiles/nvim/packages/fzf.vim
    source /home/devs/Projects/dotfiles/nvim/packages/vim-devicons.vim
    source /home/devs/Projects/dotfiles/nvim/packages/indentline.vim
" }}}

" Local config {{{
    if filereadable("/home/devs/Projects/dotfiles/_localrc/local.nvimrc")
      source /home/devs/Projects/dotfiles/_localrc/local.nvimrc
    endif
" }}}
