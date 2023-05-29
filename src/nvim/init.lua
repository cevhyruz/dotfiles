require "core"

-- custom options, autocmds, usercommands.
local localrc_path = vim.api.nvim_get_runtime_file("/lua/custom/localrc.lua", false)[1]
if localrc_path then
  dofile(localrc_path)
end

require("core.utils").load_mappings()

-- Installs lazy.nvim, mason.nvim and configures lazy plugin configs,
-- If no path has been given, install location defaults to '~/.local/share/nvim'.
-- @param1 lazy_path:string Path to lazy.nvim install location.
-- @param2 mason_path:string Path to mason.nvim install location.
require("core.bootstrap").init()
