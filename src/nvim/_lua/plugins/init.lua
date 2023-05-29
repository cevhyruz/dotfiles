local default_plugins = {

  "p00f/nvim-ts-rainbow",

  "christoomey/vim-tmux-navigator",

  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      --dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "tomasiser/vim-code-dark",
    lazy = false,
    config = function()
      vim.cmd "colorscheme codedark"
    end
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      --return { override = require("nvchad_ui.icons").devicons }
    end,
    config = function(_, opts)
      --dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },
  {
    "junegunn/fzf",
    cmd = { "FZF" },
    config = function()
      vim.cmd "cnoreabbrev f FZF<CR>"
      require("plugins.configs.fzf")
    end

  },

  "junegunn/fzf.vim",

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      --dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
      --vim.g.nvimtree_side = opts.view.side
    end,
  },
}

local config = require("core.utils").load_config()

print(vim.inspect(config))
 
if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
