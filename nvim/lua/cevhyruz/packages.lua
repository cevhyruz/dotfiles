local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path })
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tomasiser/vim-code-dark'
  use 'tpope/vim-surround'
  use 'tpope/vim-endwise'
  use { 'airblade/vim-gitgutter',
    config = function() require('package_config/git-gutter') end
  }
  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require('package_config/indent-blankline') end
  }
  use 'easymotion/vim-easymotion'
  use 'blueyed/vim-diminactive'
  use 'itchyny/lightline.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use { 'kyazdani42/nvim-tree.lua',
    opt = true,
    requires = { 'kyazdani42/nvim-web-devicons' },
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle' },
    config = function() require('package_config/nvim-tree') end
  }
  use {
    'aliou/bats.vim',
    opt = true,
    ft = { 'bats' }
  }
  use {
    'majutsushi/tagbar',
    opt = true,
    cmd = { 'Tagbar', 'TagbarToggle' }
  }
  use {
    'junegunn/fzf',
    run = ':call fzf#install()',
    requires = {{ 'junegunn/fzf.vim' }},
    config = function() require('package_config/fzf') end
  }
  use 'jiangmiao/auto-pairs'
  use 'preservim/nerdcommenter'
  -- treesitter
  use 'nvim-treesitter/nvim-treesitter'
  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use { 'hrsh7th/nvim-cmp',
    requires = {
      { 'SirVer/Ultisnips',
        config = function()
          vim.cmd [[
            let g:UltiSnipsSnippetDirectories = [
            \ '/home/devs/Projects/dotfiles/nvim/UltiSnips',
            \ 'UltiSnips' ]
          ]]
        end
      },
      { 'quangnguyen30192/cmp-nvim-ultisnips' }
    }
  }

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
