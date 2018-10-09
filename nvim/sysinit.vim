"-------------------------------------------------
" sysinit.vim - neovim system-wide bootstrap file |
"-------------------------------------------------

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