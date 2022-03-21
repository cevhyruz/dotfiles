local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tomasiser/vim-code-dark'
  use 'tpope/vim-surround'
  use 'tpope/vim-endwise'
  use {
    'ycm-core/YouCompleteMe',
    run = { 'python3 install.py' }
  }
  use 'airblade/vim-gitgutter'
  use 'Yggdroot/indentLine'
  use 'easymotion/vim-easymotion'
  use 'blueyed/vim-diminactive'
  use 'itchyny/lightline.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use 'ryanoasis/vim-devicons'
  use 'dense-analysis/ale'
  use 'SirVer/ultisnips'
  use {
    'aliou/bats.vim',
    ft = { 'bats' }
  }
  use {
    'majutsushi/tagbar',
    opt = true,
    cmd = {
      'Tagbar',
      'TagbarToggle'
    }
  }
  use {
    'junegunn/vader.vim',
    cmd = { 'Vader' },
    ft = { 'vader' }
  }
  use {
    'junegunn/fzf.vim',
    requires = {{ 'junegunn/fzf' }}
  }
  use 'jiangmiao/auto-pairs'
  use 'preservim/nerdcommenter'
  use {
    'preservim/nerdtree',
    opt = true,
    cmd = {
      'NERDTree',
      'NERDTreeToggle'
    }
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
