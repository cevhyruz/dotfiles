"-------------------------------------------------
" sysinit.vim - neovim system-wide bootstrap file |
"-------------------------------------------------

" Initialize packages.
" ---------------------
  execute pathogen#infect('packages/{}')

" Initialize package-specific configuration files.
" -------------------------------------------------
  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree.vim
  source /home/devs/Projects/dotfiles/nvim/packages/nerdtree-git-plugin.vim

" Load Components.
" -----------------
  source /home/devs/Projects/dotfiles/nvim/components/keybindings.vim
  source /home/devs/Projects/dotfiles/nvim/components/statusline.vim
  source /home/devs/Projects/dotfiles/nvim/components/macros.vim

" Load the main configuration file.
" ----------------------------------
  source /home/devs/Projects/dotfiles/nvim/config.vim

" Load the local.nvimrc for local configuration.
" -----------------------------------------------
  source /home/devs/Projects/dotfiles/_localrc/local.nvimrc