local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

local packpath = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty( vim.fn.glob( packpath ) ) > 0 then
  Packer_bootstrap = vim.fn.system({
    'git', 'clone', '--depth', '1',
    'git@github.com:wbthomason/packer.nvim.git',
    packpath
  })
print('Installing packer close and reopen Neovim...')
  vim.cmd [[ packadd packer.nvim ]]
end

-- display as popup
packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float {
        border = 'rounded'
      }
    end
  }
}
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'tomasiser/vim-code-dark',
    config = function()
      vim.cmd [[ colorscheme codedark ]]
    end
  }
  use 'tpope/vim-surround'
  use 'tpope/vim-endwise'
  use { 'airblade/vim-gitgutter',
    config = function() require('plugins.config.git-gutter') end
  }
  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require('plugins.config.indent-blankline') end
  }
  use 'easymotion/vim-easymotion'
  use 'blueyed/vim-diminactive'
  use 'itchyny/lightline.vim'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use { 'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
      config = { function() require('plugins.config.nvim-web-devicons') end }
    },
    config = function() require('plugins.config.nvim-tree') end
  }
  use {
    'aliou/bats.vim',
    opt = true,
    ft = { 'bats' }
  }
  use {
    'majutsushi/tagbar',
    opt = true,
    cmd = { 'Tagbar', 'TagbarToggle' } }
  use {
    'junegunn/fzf',
    run = ':call fzf#install()',
    requires = {{ 'junegunn/fzf.vim' }},
    config = function() require('plugins.config.fzf') end }
  use 'jiangmiao/auto-pairs'
  use 'preservim/nerdcommenter'
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugins.config.treesitter') end }
  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/nvim-lsp-installer'
  use 'kosayoda/nvim-lightbulb'
  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'f3fora/cmp-spell'
  use { 'hrsh7th/nvim-cmp',
    requires = {
      { 'SirVer/Ultisnips',
        config = function()
          vim.cmd [[
            let g:UltiSnipsSnippetDirectories = [ 'UltiSnips', '/home/devs/Projects/dotfiles/nvim/UltiSnips' ]
          ]]
        end
      },
      { 'quangnguyen30192/cmp-nvim-ultisnips' }
    },
    config = function() require('plugins.config.nvim-cmp') end
  }

  -- init
  if Packer_bootstrap then
    require('packer').sync()
  end
end)
