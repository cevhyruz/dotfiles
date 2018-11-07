"-------------------------------------------------
" sysinit.vim - neovim system-wide bootstrap file |
"-------------------------------------------------

augroup TermConfig
  au!
  autocmd TermOpen * setlocal nonumber          " Disable LineNumbers.
  autocmd BufEnter term://* startinsert         " Always start in InsertMode.
augroup end



" Disable some global plugins {{{

  let loaded_matchit       = 1
  let loaded_netrw         = 1
  let loaded_netrwPlugin   = 1
  let loaded_gzip          = 1
  let g:loaded_zipPlugin   = 1
  let g:loaded_zip         = 1

" }}}


" Basic Settings {{{

  " Some options were omited, see `:help nvim-defaults` for details.

  syntax enable                  " Allow using :hi to set my preffered colors.
  filetype plugin indent on      " Enable loading of plugins per filetype.

  set background=dark            " Use light texts in dark background.
"  colorscheme codedark
  set colorcolumn=79             " Character per line threshold guide.
  set signcolumn=yes             " Always open signcolumn gutter.
  set number relativenumber      " Display hybrid line numbers.
  set nofoldenable               " Dont fold marked folds by default.
  set scrolloff=16               " Line wrap around cursor while scrolling.
  set backspace=indent,eol,start " Allow backspace in insert mode.
  set clipboard+=unnamedplus     " Use OS clipboard by default.
  set showbreak=↪                " Indicate where the line breaks.
  set ignorecase                 " Make searching case-insensitive.
  set smartcase                  " Case-sensitive if expression has a capital.
  set nolazyredraw               " Don't redraw while running a macro.
  set expandtab                  " Expand tabs to spaces.
  set tabstop=2                  " Tabs width.
  set softtabstop=2              " Use 2 spaces for tabs.
  set foldmethod=marker          " Manually create my own code folding method.
  set shiftwidth=2               " Number of spaces to for indention.
  set cursorline                 " Highlight current line.
  set shortmess+=F               " Don't give the fileinfo when editing a file.
  set mouse=a                    " Enable mouse in all modes.
  set backupdir=/tmp//           " Set the backup directory.
  set noshowmode                 " Don't show current mode in commandline.
  set fillchars+=vert:\┃,fold:\  " Vertical split border style.
  set rtp+=/home/devs/.fzf       " Enable the fzf wrapper function for vim.
  set list                       " Show trailing whitespace, tabs, EOL, etc..
  set showtabline=0              " Do not show the tabline.
  set listchars=trail:~,tab:▸\ ,extends:❯,precedes:❮,nbsp:␣

  hi! TrailingWhitespace cterm=bold ctermbg=235 ctermfg=30
  match TrailingWhitespace #\s\+$#

" }}}

" Abbreviation {{{

" Try appending <cr> or <bs>

    cnoreabbrev f FZF<cr>

    cnoreabbrev snip UltiSnipsEdit<cr>

    inoreabbrev nerdtree NERDTree

" }}}

" Load Components.
" -----------------
source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
source /home/devs/Projects/dotfiles/nvim/components/statusline.vim
source /home/devs/Projects/dotfiles/nvim/components/macros.vim
source /home/devs/Projects/dotfiles/nvim/components/tabline.vim

" Initialize package-specific configuration files.
" -------------------------------------------------
"  TODO: Check first if their respective plugin
" is enabled or not before sourcing to avoid errors poppingup.


  source /home/devs/Projects/dotfiles/nvim/packages/pathogen.vim
  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree.vim
  source /home/devs/Projects/dotfiles/nvim/packages/ale.vim
  source /home/devs/Projects/dotfiles/nvim/packages/gitgutter.vim
  source /home/devs/Projects/dotfiles/nvim/packages/ycm.vim
  source /home/devs/Projects/dotfiles/nvim/packages/ultisnips.vim
"  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree-git-plugin.vim
"  source /home/devs/Projects/dotfiles/nvim/packages/vim-airline.vim
  source /home/devs/Projects/dotfiles/nvim/packages/fzf.vim
  source /home/devs/Projects/dotfiles/nvim/packages/vim-devicons.vim

" Load the local.nvimrc for local configuration.
" -----------------------------------------------
if filereadable("/home/devs/Projects/dotfiles/_localrc/local.nvimrc")
  source /home/devs/Projects/dotfiles/_localrc/local.nvimrc
endif

hi! LineNR ctermbg=234 ctermfg=239
hi! Cursorline cterm=none ctermbg=236
