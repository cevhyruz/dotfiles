-- Returns a table of default options.

local M = {}

 -- path i.e "custom.plugins" -> custom/plugins.lua only and not custom/plugins/init.lua!!!!
M.plugins = ""

-- config for lazy.nvim startup options
M.lazy_nvim = require "plugins.configs.lazy_nvim"

-- these are default mappings, check core.mappings for table structure
M.mappings = {}

return M
