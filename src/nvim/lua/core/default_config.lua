-- Returns a table of default configurations.

local M = {}

M.ui = {
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = {
    style = "borderless", -- borderless / bordered
  },
}

-- Additional custom plugins.
-- [path] "custom.plugins" -> custom/plugins.lua
M.plugins = ""

-- config for lazy.nvim startup options
M.lazy_nvim = require "plugins.configs.lazy_nvim"

-- these are default mappings, check core.mappings for table structure
M.mappings = {}

return M
