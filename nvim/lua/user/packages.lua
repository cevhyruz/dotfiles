local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end
local packpath = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end
  }
}

if vim.fn.empty( vim.fn.glob( packpath ) ) > 0 then
  Packer_bootstrap = vim.fn.system({ 'git', 'clone', '--depth', '1',
    'git@github.com:wbthomason/packer.nvim.git', packpath })

  print('Installing packer close and reopen Neovim...')
  vim.cmd [[ packadd packer.nvim ]]
end

return require('packer').startup(function(use)
  use 'edluffy/hologram.nvim'
  use 'wbthomason/packer.nvim'
  use { 'stevearc/aerial.nvim',
    config = function() require('aerial').setup() end
  }
  -- use { 'blueyed/vim-diminactive' }
  use { 'petertriho/nvim-scrollbar',
    requires = "kevinhwang91/nvim-hlslens",
    config = function() require("plugins.scrollbar") end
  }
  use 'tpope/vim-scriptease'
  use { 'morhetz/gruvbox' }
  use {
    'tomasiser/vim-code-dark',
    config = function()
      vim.cmd [[ colorscheme codedark ]]
    end
  }
  use 'tpope/vim-surround'
  use 'tpope/vim-endwise'
  use 'p00f/nvim-ts-rainbow'
  use { 'lukas-reineke/indent-blankline.nvim',
    config = function() require('plugins.indent-blankline') end }
  use 'easymotion/vim-easymotion'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-fugitive'
  use 'preservim/vim-markdown'
  use { 'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
      config = { function() require('plugins.nvim-web-devicons') end }
    },
    config = function() require('plugins.nvim-tree') end
  }
  use {
    'aliou/bats.vim',
    opt = true,
    ft = { 'bats' }
  }
  use {
    'preservim/tagbar',
    opt = true,
    cmd = { 'Tagbar', 'TagbarToggle' } }
  use {
    'junegunn/fzf',
    run = ':call fzf#install()',
    requires = { 'junegunn/fzf.vim' },
    config = function() require('plugins.fzf') end }
  use 'jiangmiao/auto-pairs'
  use 'tomtom/tcomment_vim'
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugins.treesitter') end }
  -- lsp and completion
  use 'neovim/nvim-lspconfig'
  use { 'williamboman/nvim-lsp-installer' }
  use { 'williamboman/mason.nvim' }
  use { 'jose-elias-alvarez/null-ls.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use '~/Projects/dotfiles/nvim/cmp-spell'
  -- use 'f3fora/cmp-spell'
  use {
    'SirVer/ultisnips',
    config = function() require('plugins.ultisnips') end
  }
  use { 'chrisbra/unicode.vim' }
  use { 'hrsh7th/nvim-cmp',
    requires = {
    "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function() require('plugins.nvim-cmp') end
  }
  use 'kosayoda/nvim-lightbulb'
  use { 'lewis6991/gitsigns.nvim',
    config = function() require('plugins.gitsigns') end }

  -- init
  if Packer_bootstrap then
    require('packer').sync()
  end
end)
