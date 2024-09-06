local M = {}

-- Plugins and their specifications

local plugname = {
  -- core plugins
  { "tomasiser/vim-code-dark" },
  {"3rd/image.nvim"},

  {"preservim/tagbar"},

  { "vimwiki/vimwiki" },

  -- UI
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-treesitter/nvim-treesitter" },
  { "lukas-reineke/indent-blankline.nvim" },

  -- git integration
  { "lewis6991/gitsigns.nvim" },

  -- file manager/picker
  { "nvim-tree/nvim-tree.lua" },
  { "junegunn/fzf" },


  { "alexghergh/nvim-tmux-navigation" },

  -- utilities
  { "windwp/nvim-autopairs" },
  { "kylechui/nvim-surround" },
  { "numToStr/Comment.nvim" },



  -- Completion
  { "hrsh7th/nvim-cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" }
    }
  }

  -- LSP
}

-- plugin specification should be in their respective config files.

local function _load_config(plugURL)
  local config_path = "plugins.config"
    .. "."
    .. string.match( string.match(plugURL, "([^/]+)$"), "^([^%.]+)" )
  local ok, plugin = pcall(require, config_path)
  if not ok then
    return {}
  end
  return plugin
end

-- Setup and configure plugin specifications
-- @return table specification
--
-- [/] create file inside 'config/' won't error
-- [x] adding field inside 'plugname' without a config file.
M.setup = function()
  local specs = {}
  for key, plugin in pairs(plugname) do
    local config = _load_config(plugname[key][1])
    local plugspecs = vim.tbl_deep_extend("keep",
      plugin,
      config.specs or {}
    )
    table.insert(specs, plugspecs)
  end
  return specs
end


return M
